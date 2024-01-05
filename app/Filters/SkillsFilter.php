<?php

namespace App\Filters;

class SkillsFilter extends QueryFilter
{
    public function search($query = '')
    {
        if (trim($query) === '')
            return;

        $this->builder->where('skills.name', 'LIKE', '%' . $query . '%');
    }
}
