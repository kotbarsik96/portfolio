<?php

namespace App\Http\Controllers;

use App\Models\Taxonomy;
use App\Models\TaxonomyType;
use Illuminate\Http\Request;
use Inertia\Inertia;
use App\Exceptions\TaxonomyException;
use App\Http\Requests\TaxonomyCreateRequest;

class TaxonomiesController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index($taxType)
    {
        $taxTypeRow = TaxonomyType::where('type', $taxType)->first();
        if (!$taxTypeRow)
            return redirect('/');

        $taxonomies = Taxonomy::where('type', $taxType)->get(['id', 'name']);

        return Inertia::render('Control/Taxonomy', [
            'type' => $taxType,
            'title' => $taxTypeRow->title,
            'list' => $taxonomies
        ]);
    }

    public function checkIfExists($taxType, $taxName)
    {
        $alreadyExists = Taxonomy::where('type', $taxType)
            ->where('name', $taxName)
            ->first();
        if ($alreadyExists) {
            $taxTypeRow = TaxonomyType::where('type', $taxType)->first();
            $taxTypeTitle = $taxTypeRow->title;
            return [
                'exists' => true,
                'redirect_back' => back()
                    ->withErrors(
                        ['name' => $taxTypeTitle . ' с названием ' . $taxName . ' уже существует']
                    )
            ];
        }

        return ['exists' => false];
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(TaxonomyCreateRequest $request)
    {
        $validated = $request->validated();
        $taxType = $validated['type'];
        $name = $validated['name'];

        $exists = $this->checkIfExists($taxType, $name);
        if ($exists['exists'])
            return $exists['redirect_back'];

        Taxonomy::create($validated);
    }

    public function update(Request $request, $id)
    {
        $taxonomy = Taxonomy::find($id);
        if (empty($taxonomy))
            return TaxonomyException::notExists();

        $name = $request->input('name');
        if (empty($name))
            return $this->destroy($id);

        $exists = $this->checkIfExists($taxonomy->type, $name);
        if ($exists['exists'])
            return $exists['redirect_back'];

        $taxonomy->update(['name' => $name]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $taxonomy = Taxonomy::find($id);
        if (empty($taxonomy))
            return TaxonomyException::notExists();

        $taxonomy->delete();
        return back();
    }
}
