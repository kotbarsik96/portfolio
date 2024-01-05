<?php

namespace App\Http\Controllers;

use App\Models\Video;
use Pion\Laravel\ChunkUpload\Exceptions\UploadMissingFileException;
use Pion\Laravel\ChunkUpload\Receiver\FileReceiver;
use Illuminate\Http\UploadedFile;
use FFMpeg\FFProbe;

class VideoController extends MediaController
{
    public function upload(FileReceiver $receiver)
    {
        try {
            if ($receiver->isUploaded() === false)
                throw new UploadMissingFileException();

            $save = $receiver->receive();
            if ($save->isFinished())
                return $this->save($save->getFile());

            $handler = $save->handler();
            return response()->json([
                'done' => $handler->getPercentageDone()
            ]);
        } catch (UploadMissingFileException $e) {
            return response()->json(['error' => 'Ошибка при загрузке видео'], 422);
        }
    }

    public function save(UploadedFile $file)
    {
        $origName = $file->getClientOriginalName();
        $extension = $file->getClientOriginalExtension();
        $name = $this->createFilename($file->getClientOriginalName());
        $file->move(public_path('video'), $name);

        $ffprobe = FFProbe::create([
            'ffmpeg.binaries' => '/usr/bin/ffmpeg',
            'ffprobe.binaries' => '/usr/bin/ffprobe'
        ]);
        $videoPath = public_path('video/' . $name);
        $videoDimensions = $ffprobe
            ->streams(public_path('video/' . $name))
            ->videos()
            ->first()
            ->getDimensions();

        $formatted = $ffprobe->format($videoPath);
        $video = Video::create([
            'path' => '/video' . '/' . $name,
            'name' => $name,
            'original_name' => $origName,
            'extension' => $extension,
            'size_kb' => round($formatted->get('size') / 1024),
            'width' => $videoDimensions->getWidth(),
            'height' => $videoDimensions->getHeight(),
            'duration_seconds' => round($formatted->get('duration')),
        ]);

        return response()->json(['video' => $video], 200);
    }

    public function destroy($id)
    {
        $video = Video::find($id);
        if (empty($video))
            return back()->withErrors(['video' => 'Видео не существует']);

        $this->removeFileAndDirectory(public_path($video->path));
        $video->delete();
    }
}
