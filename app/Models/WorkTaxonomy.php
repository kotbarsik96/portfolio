<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class WorkTaxonomy extends Model
{
    use HasFactory;

    protected $table = 'works_taxonomies';

    protected $fillable = [
        'work_id',
        'taxonomy_id'
    ];
}
