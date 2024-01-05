<?php

namespace App\Http\Controllers;

use App\Http\Requests\SkillRequest;
use App\Models\Skill;
use Inertia\Inertia;
use App\Models\Image;
use App\Models\Video;
use App\Filters\SkillsFilter;
use App\Models\WorkSkill;

class SkillsController extends Controller
{
    public function getList(SkillsFilter $queryFilter)
    {
        $limit = $queryFilter->request->query('limit') ?? null;
        $offset = $queryFilter->request->query('offset') ?? null;
        $list = $this->getSkillsFullData($limit, $offset, $queryFilter);

        return ['list' => $list];
    }

    public function getSkillsFullData($limit, $offset, $queryFilter = null)
    {
        $skills = null;
        if ($queryFilter)
            $skills = Skill::filter($queryFilter)->withMedia($limit, $offset);
        else
            $skills = Skill::withMedia($limit, $offset);

        foreach ($skills as $skillRow) {
            $skillRow->works = WorkSkill::where('skill_id', $skillRow->id)
                ->leftJoin('works', 'works.id', '=', 'works_skills.work_id')
                ->get(['works.name as name', 'works_skills.url', 'works_skills.comment']);
        }

        return $skills;
    }

    public function create()
    {
        return Inertia::render('Control/Skill', [
            'skill' => null,
            'image' => null,
            'video' => null
        ]);
    }

    public function edit($id)
    {
        $skill = Skill::find($id);
        if (empty($skill))
            return redirect()->route('skill_create');

        return Inertia::render('Control/Skill', [
            'skill' => $skill,
            'image' => Image::find($skill->image_id),
            'video' => Video::find($skill->video_id)
        ]);
    }

    public function store(SkillRequest $request)
    {
        $validated = $request->validated();

        $validated = array_merge(['user_id' => auth()->id()], $validated);
        $skill = Skill::create($validated);

        return redirect()->route('skill_edit', ['id' => $skill->id]);
    }

    public function update(SkillRequest $request)
    {
        $validated = $request->validated();

        $skill = Skill::find($request->input('id'));
        if (empty($skill))
            return back()->withErrors(['name' => 'Навык не существует']);

        $skill->update($validated);
    }

    public function destroy($id)
    {
        $skill = Skill::find($id);
        if (empty($skill))
            return back()->withErrors(['name' => 'Навык не существует']);

        $this->destroyMedia($skill->image_id, ImageController::class);
        $this->destroyMedia($skill->video_id, VideoController::class);
        $skill->delete();
        return redirect()->route('skill_create');
    }

    public function destroyMedia($id, $controller)
    {
        if (empty($id))
            return;

        $inst = new $controller();
        $inst->destroy($id);
    }
}
