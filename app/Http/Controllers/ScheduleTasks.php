<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\AuthAttempt;
use Illuminate\Support\Facades\DB;

class ScheduleTasks extends Controller
{
    public function clearAuthAttempts()
    {
        $oldAttempts = AuthAttempt::where('created_at', '<', DB::raw('NOW() - INTERVAL 10 MINUTE'))
            ->get();
        foreach ($oldAttempts as $row) {
            $row->delete();
        }
    }
}
