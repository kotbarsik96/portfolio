<?php

namespace App\Filters;

use Illuminate\Database\Query\Builder;

class WorksFilter extends QueryFilter
{
    public function filterByTaxonomy($values = [], $taxonomyType)
    {
        if (count($values) < 1)
            return;

        $this->builder->whereIn('works.id', function (Builder $query) use ($values, $taxonomyType) {
            $query->select(['works_taxonomies.work_id'])
                ->from('works_taxonomies')
                ->leftJoin('taxonomies', 'taxonomies.id', '=', 'works_taxonomies.taxonomy_id')
                ->where('taxonomies.type', $taxonomyType)
                ->whereIn('taxonomies.name', $values)
                ->groupBy('works_taxonomies.work_id')
                ->havingRaw('COUNT(DISTINCT taxonomies.id) = ?', [count($values)]);
        });
    }

    public function types($values = [])
    {
        $this->filterByTaxonomy($values, 'type');
    }

    public function stack($values = [])
    {
        $this->filterByTaxonomy($values, 'stack');
    }

    public function skills($values = [])
    {
        if (count($values) < 1)
            return;

        $this->builder->whereIn('works.id', function (Builder $query) use ($values) {
            $query->select(['works_skills.work_id'])
                ->from('works_skills')
                ->whereIn('works_skills.skill_id', function (Builder $subquery) use ($values) {
                    $subquery->select(['skills.id'])
                        ->from('skills')
                        ->whereIn('skills.name', $values);
                });
        });
    }
}
