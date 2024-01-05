<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Video extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'path',
        'name',
        'original_name',
        'extension',
        'size_kb',
        'width',
        'height',
        'duration_seconds'
    ];

    protected $table = 'video';
}
