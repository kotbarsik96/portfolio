<?php

use App\Http\Controllers\ImageController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\IndexController;
use App\Http\Controllers\SkillsController;
use App\Http\Controllers\TaxonomiesController;
use App\Http\Controllers\VideoController;
use App\Http\Controllers\WorksController;

Route::get('/', [IndexController::class, 'index'])
    ->name('home');

Route::get('/skills', [SkillsController::class, 'getList']);
Route::get('/works', [WorksController::class, 'getList']);

Route::middleware('is_guest')->group(function () {
    Route::get('/whoami', [IndexController::class, 'register'])
        ->name('register');
    Route::get('/yahochupizzu', [IndexController::class, 'login'])
        ->name('login');
    Route::get('/identifyyourself', [IndexController::class, 'doubleFA'])
        ->name('doubleFA');
    Route::get('/show-code', [IndexController::class, 'showQrCode'])
        ->name('show_code');
});

Route::middleware('is_me')->group(function () {
    Route::get('/me', [IndexController::class, 'control']);

    Route::get('/me/taxonomy/{taxType}', [TaxonomiesController::class, 'index']);
    Route::post('/me/taxonomy', [TaxonomiesController::class, 'store']);
    Route::post('/me/taxonomy/{id}', [TaxonomiesController::class, 'update']);
    Route::delete('/me/taxonomy/{id}', [TaxonomiesController::class, 'destroy']);

    Route::get('/me/skill/{id}', [SkillsController::class, 'edit']);
    Route::get('/me/skill', [SkillsController::class, 'create']);
    Route::post('/me/skill/{id}', [SkillsController::class, 'update'])
        ->name('skill_edit');
    Route::post('/me/skill', [SkillsController::class, 'store'])
        ->name('skill_create');
    Route::delete('/me/skill/{id}', [SkillsController::class, 'destroy']);

    Route::get('/me/work/{id}', [WorksController::class, 'edit']);
    Route::get('/me/work', [WorksController::class, 'create']);
    Route::post('/me/work/{id}', [WorksController::class, 'update'])
        ->name('work_edit');
    Route::post('/me/work', [WorksController::class, 'store'])
        ->name('work_create');
    Route::delete('/me/work/{id}', [WorksController::class, 'destroy']);

    Route::post('/me/image/{id}', [ImageController::class, 'update']);
    Route::post('/me/image', [ImageController::class, 'store']);
    Route::delete('/me/image/{id}', [ImageController::class, 'destroy']);

    Route::post('/me/video', [VideoController::class, 'upload']);
    Route::delete('/me/video/{id}', [VideoController::class, 'destroy']);
});

require __DIR__ . '/auth.php';
