<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TaxonomyType extends Model
{
    use HasFactory;

    protected $table = 'taxonomy_types';

    protected $fillable = [
        'type',
        'title'
    ];
}
