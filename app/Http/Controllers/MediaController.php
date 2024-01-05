<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class MediaController extends Controller
{
    public function createFilename($originalName)
    {
        $originalNameSlug = $this->slugify($originalName);
        return substr(md5(time()), -8) . '_' . $originalNameSlug;
    }

    public function slugify($string)
    {
        $string = \transliterator_transliterate('Any-Latin; NFD; [:Nonspacing Mark:] Remove; NFC; Lower();', $string);
        $string = preg_replace('/[-\s]+/', '-', $string);
        return trim($string, '-');
    }

    public function removeFileAndDirectory($path)
    {
        if (!is_file($path))
            return;

        unlink($path);
        $dirname = dirname($path);
        if (count(scandir($dirname)) <= 2)
            rmdir($dirname);
    }
}
