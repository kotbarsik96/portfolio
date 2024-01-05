<?php

namespace App\Http\Controllers;

use App\Models\Skill;
use App\Models\Taxonomy;
use App\Models\Work;
use Inertia\Inertia;
use App\Http\Controllers\SkillsController;

class IndexController extends Controller
{
    public function getWorksFullData($limit)
    {
        $ctrl = new WorksController();
        return $ctrl->getWorksFullData($limit, 0)['list'];
    }

    public function getSkillsFullData($limit)
    {
        $ctrl = new SkillsController();
        return $ctrl->getSkillsFullData($limit, 0);
    }

    public function index()
    {
        $works = $this->getWorksFullData(4);
        $skills = $this->getSkillsFullData(2);

        return Inertia::render('Home', [
            'routeName' => 'home',
            'isMe' => !auth()->guest(),
            'stack' => Taxonomy::where('type', 'stack')->get(['name']),
            'types' => Taxonomy::where('type', 'type')->get(['name']),
            'worksCount' => Work::all()->count(),
            'skillsCount' => Skill::all()->count(),
            'works' => $works,
            'skills' => $skills,
        ]);
    }

    public function register()
    {
        return Inertia::render('Register', [
            'routeName' => 'register'
        ]);
    }

    public function login()
    {
        return Inertia::render('Login', [
            'routeName' => 'login'
        ]);
    }

    public function doubleFA()
    {
        return Inertia::render('DoubleFA', [
            'routeName' => 'doubleFA'
        ]);
    }

    public function showQrCode()
    {
        $code = session('qrCode');
        if (!empty($code))
            $code = $code->toHtml();

        return Inertia::render('ShowCode', [
            'code' => $code
        ]);
    }

    public function control()
    {
        return Inertia::render('Control');
    }
}
