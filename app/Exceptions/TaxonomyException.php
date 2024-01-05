<?php

namespace App\Exceptions;

use Exception;

class TaxonomyException extends Exception
{
    public static function notExists()
    {
        return back()->withErrors(['taxonomy' => 'Таксономия не существует']);
    }
}
