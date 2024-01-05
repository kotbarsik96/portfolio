<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class WorkSkill extends Model
{
    use HasFactory;

    protected $table = 'works_skills';

    protected $fillable = [
        'work_id',
        'skill_id',
        'comment',
        'url'
    ];
}
