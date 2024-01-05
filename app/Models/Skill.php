<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use App\Models\FilterableModel;
use Illuminate\Database\Eloquent\Builder;

class Skill extends FilterableModel
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'image_id',
        'video_id'
    ];

    protected $table = 'skills';

    public static function scopeWithMedia(Builder $query, $limit, $offset)
    {
        return $query->leftJoin('images', 'images.id', '=', 'skills.image_id')
            ->leftJoin('video', 'video.id', '=', 'skills.video_id')
            ->limit($limit)
            ->offset($offset)
            ->get(['skills.*', 'images.path as image_path', 'video.path as video_path']);
    }
}
