<?php

namespace App\Http\Controllers;

use App\Http\Controllers\MediaController;
use Illuminate\Http\Request;
use App\Http\Requests\ImageRequest;
use Intervention\Image\ImageManagerStatic as ImageIntervention;
use App\Models\Image;

class ImageController extends MediaController
{
    public function createFilename($originalName)
    {
        $originalNameSlug = $this->slugify($originalName);
        return substr(md5(time()), -8) . '_' . $originalNameSlug;
    }

    public function upload(ImageRequest $request)
    {
        $image = $request->file('image');
        $name = $this->createFilename($image->getClientOriginalName());
        $extension = $image->getClientOriginalExtension();

        $image->move(public_path('images'), $name);
        $image = ImageIntervention::make(public_path('images') . '/' . $name);
        if (!is_dir(public_path('webp/images')))
            mkdir(public_path('webp/images'), 0755, true);

        $image->save(public_path('images') . '/' . $name, 50);
        $image->encode('webp', 100)
            ->save(public_path('webp/images') . '/' . $name . '.webp');

        $width = $image->width();
        $height = $image->height();
        $size = round($image->filesize() / 1024);

        return [
            'path' => '/images' . '/' . $name,
            'name' => $name,
            'extension' => $extension,
            'size_kb' => $size,
            'width' => $width,
            'height' => $height
        ];
    }

    public function store(ImageRequest $request)
    {
        $userId = auth()->id();
        $data = array_merge(['user_id' => $userId], $this->upload($request));
        $image = Image::create($data);
        return response()->json(['uploaded' => $image], 200);
    }

    public function update(ImageRequest $request, $id)
    {
        $image = Image::find($id);
        if (empty($image))
            return $this->store($request);

        $image->update($this->upload($request));
    }

    public function destroy($id)
    {
        $image = Image::find($id);
        if (empty($image))
            return back()->withErrors(['image' => 'Изображение не существует']);

        $this->removeFileAndDirectory(public_path($image->path));
        $this->removeFileAndDirectory(public_path('webp' . $image->path) . '.webp');

        $image->delete();
    }
}
