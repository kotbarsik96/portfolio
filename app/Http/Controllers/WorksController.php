<?php

namespace App\Http\Controllers;

use App\Http\Requests\WorksRequest;
use App\Models\Image;
use App\Models\Skill;
use App\Models\Taxonomy;
use App\Models\Work;
use Inertia\Inertia;
use App\Models\WorkSkill;
use App\Models\WorkTaxonomy;
use Illuminate\Database\Query\Builder;
use App\Filters\WorksFilter;

class WorksController extends Controller
{
    public function getList(WorksFilter $queryFilter)
    {
        $limit = $queryFilter->request->query('limit') ?? null;
        $offset = $queryFilter->request->query('offset') ?? null;
        return $this->getWorksFullData($limit, $offset, $queryFilter);
    }

    public function getWorksFullData($limit, $offset, $queryFilter = null)
    {
        $works = null;
        $count = 0;

        if ($queryFilter) {
            $works = Work::filter($queryFilter);
            $count = $works->count();
            $works = $works->withMedia($limit, $offset);
        } else {
            $works = Work::withMedia($limit, $offset);
            $count = Work::all()->count();
        }

        foreach ($works as $workRow) {
            $workRow->skills = WorkSkill::where('work_id', $workRow->id)
                ->leftJoin('skills', 'skills.id', '=', 'works_skills.skill_id')
                ->get(['skills.name as name', 'works_skills.comment']);

            $workRow->stack = Taxonomy::where('taxonomies.type', 'stack')
                ->whereIn('taxonomies.id', function ($subquery) use ($workRow) {
                    $subquery->select('works_taxonomies.taxonomy_id')
                        ->from('works_taxonomies')
                        ->where('works_taxonomies.work_id', $workRow->id);
                })->get(['name']);

            $tag = Taxonomy::where('taxonomies.type', 'tag')
                ->whereIn('taxonomies.id', function ($subquery) use ($workRow) {
                    $subquery->select('works_taxonomies.taxonomy_id')
                        ->from('works_taxonomies')
                        ->where('works_taxonomies.work_id', $workRow->id);
                })->first();
            if ($tag)
                $workRow->tag = $tag->name;
        }

        return ['list' => $works, 'count' => $count];
    }

    public function getRequiredProps()
    {
        return [
            'tags' => Taxonomy::where('type', 'tag')->get(),
            'types' => Taxonomy::where('type', 'type')->get(),
            'stack' => Taxonomy::where('type', 'stack')->get(),
            'skills' => Skill::all()
        ];
    }

    public function create()
    {
        return Inertia::render('Control/Work', $this->getRequiredProps());
    }

    public function edit($id)
    {
        $work = Work::find($id);
        if (empty($work))
            return redirect()->route('work_create');

        $workTaxonomies = [
            'tag' => $this->getWorkTaxonomy('tag', $work->id)->first(),
            'types' => $this->getWorkTaxonomy('type', $work->id)->get(),
            'stack' => $this->getWorkTaxonomy('stack', $work->id)->get()
        ];
        $workSkills = WorkSkill::select(['works_skills.*', 'skills.name AS name'])
            ->where('work_id', $work->id)
            ->leftJoin('skills', 'works_skills.skill_id', '=', 'skills.id')
            ->get();

        $props = array_merge($this->getRequiredProps(), [
            'work' => $work,
            'image_desktop' => Image::find($work->image_desktop_id),
            'image_mobile' => Image::find($work->image_mobile_id),
            'work_taxonomies' => $workTaxonomies,
            'work_skills' => $workSkills
        ]);
        return Inertia::render('Control/Work', $props);
    }

    public function store(WorksRequest $request)
    {
        $validated = $request->validated();
        $validated = array_merge(['user_id' => auth()->id()], $validated);

        $work = Work::create($validated);
        $this->updateTaxonomies($request, $work);
        $this->updateSingleTaxonomy('tag', $request->tag, $work);
        return redirect()->route('work_edit', ['id' => $work->id]);
    }

    public function update(WorksRequest $request, $id)
    {
        $validated = $request->validated();

        $work = Work::find($id);
        if (empty($work))
            return back()->withErrors(['work' => 'Работа не существует']);

        $this->updateTaxonomies($request, $work);
        $this->updateSingleTaxonomy('tag', $request->tag, $work);
        $work->update($validated);
    }

    public function destroy($id)
    {
        $work = Work::find($id);
        if (empty($work))
            return back()->withErrors(['work' => 'Работа не существует']);

        $this->destroyImages($work->image_desktop_id);
        $this->destroyImages($work->image_mobile_id);
        $work->delete();
    }

    public function updateSingleTaxonomy($taxType, $taxName, Work $work)
    {
        // удалит старую прикрепленную таксономию и дубликаты, если вдруг есть
        $currentRows = WorkTaxonomy::where('work_id', $work->id)
            ->whereIn('taxonomy_id', function (Builder $query) use ($taxType) {
                $query->select('id')->from('taxonomies')
                    ->where('type', $taxType);
            });
        foreach ($currentRows as $row) {
            $row->delete();
        }

        // прикрепит новую таксономию
        $taxonomy = Taxonomy::where('type', $taxType)->where('name', $taxName)
            ->first();
        if (empty($taxonomy))
            return;

        WorkTaxonomy::create([
            'work_id' => $work->id,
            'taxonomy_id' => $taxonomy->id
        ]);
    }

    public function getWorkTaxonomy($taxType, $workId)
    {
        return Taxonomy::where('type', $taxType)
            ->whereIn('id', function (Builder $query) use ($workId) {
                $query->select('taxonomy_id')
                    ->from('works_taxonomies')
                    ->where('work_id', $workId);
            });
    }

    public function updateTaxonomies(WorksRequest $request, Work $work)
    {
        $taxonomies = $request->taxonomies ?? [];
        $idsFromRequest = [];
        foreach ($taxonomies as $taxType => $array) {
            if ($taxType === 'skills') {
                if (is_array($array))
                    $this->updateSkills($array, $work);
                continue;
            }

            foreach ($array as $taxName) {
                $taxonomy = Taxonomy::where('name', $taxName)
                    ->where('type', $taxType)
                    ->first();
                if (empty($taxonomy))
                    continue;

                array_push($idsFromRequest, $taxonomy->id);
                WorkTaxonomy::create([
                    'work_id' => $work->id,
                    'taxonomy_id' => $taxonomy->id
                ]);
            }
        }

        // удалит из works_taxonomies таксономии, которые НЕ переданы в $request->taxonomies
        WorkTaxonomy::where('work_id', $work->id)
            ->whereNotIn('taxonomy_id', function (Builder $query) use ($idsFromRequest) {
                $query->select(['id'])
                    ->from('taxonomies')
                    ->whereIn('id', $idsFromRequest);
            })->delete();
    }

    public function updateSkills($skills, Work $work)
    {
        $idsFromRequest = [];
        foreach ($skills as $data) {
            $hasAllKeys = array_key_exists('value', $data)
                && array_key_exists('comment', $data)
                && array_key_exists('attachment', $data);

            if ($hasAllKeys === false)
                continue;

            $skill = Skill::where('name', $data['value'])
                ->first();
            if (empty($skill))
                continue;

            array_push($idsFromRequest, $skill->id);

            $fill = [
                'work_id' => $work->id,
                'skill_id' => $skill->id
            ];
            if ($data['comment'])
                $fill['comment'] = $data['comment'];
            if ($data['attachment'])
                $fill['url'] = $data['attachment'];

            $existingRows = WorkSkill::where('work_id', $work->id)
                ->where('skill_id', $skill->id)
                ->get();
            if (count($existingRows) > 2) {
                foreach ($existingRows as $row) {
                    $row->delete();
                }
            } else if (count($existingRows) === 1) {
                $row = $existingRows[0];
                $row->update($fill);
                continue;
            }

            WorkSkill::create($fill);
        }

        // удалит из works_skills навыки, которые НЕ переданы в $request->skills
        WorkSkill::where('work_id', $work->id)
            ->whereNotIn('skill_id', function (Builder $query) use ($idsFromRequest) {
                $query->select(['id'])
                    ->from('skills')
                    ->whereIn('id', $idsFromRequest);
            })->delete();
    }

    public function destroyImages($id)
    {
        $image = Image::find($id);
        if (empty($image))
            return;

        $ctrl = new ImageController();
        $ctrl->destroy($id);
    }
}
