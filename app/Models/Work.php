<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use App\Models\FilterableModel;
use Illuminate\Database\Eloquent\Builder;

class Work extends FilterableModel
{
    use HasFactory;

    protected $fillable = [
        'name',
        'url',
        'image_desktop_id',
        'image_mobile_id',
        'pages_count',
        'user_id'
    ];

    public static function scopeWithMedia(Builder $query, $limit, $offset)
    {
        $query->leftJoin('images as image_desktop', 'image_desktop.id', '=', 'works.image_desktop_id')
            ->leftJoin('images as image_mobile', 'image_mobile.id', '=', 'works.image_mobile_id');

        if ($limit)
            $query->limit($limit);
        if ($offset)
            $query->offset($offset);

        return $query->get(['works.*', 'image_desktop.path as image_desktop', 'image_mobile.path as image_mobile']);
    }
}
