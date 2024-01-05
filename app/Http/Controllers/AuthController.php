<?php

namespace App\Http\Controllers;

use App\Http\Requests\LoginRequest;
use App\Http\Requests\SignupRequest;
use Illuminate\Http\Request;
use PragmaRX\Google2FA\Google2FA;
use SimpleSoftwareIO\QrCode\Facades\QrCode;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use App\Models\AuthAttempt;
use Illuminate\Support\Facades\Cookie;

class AuthController extends Controller
{
    public $authAttemptCookie = 'ah_at_k';

    public function getRandom()
    {
        return bin2hex(random_bytes(8));
    }

    public function register(SignupRequest $request)
    {
        $validated = $request->validated();

        $google2fa = new Google2FA();
        $google2faKey = $google2fa->generateSecretKey();
        $qrCodeUrl = $google2fa->getQRCodeUrl(
            'kb96_portfolio',
            $validated['name'],
            $google2faKey
        );
        $qrCodeSrc = QrCode::generate($qrCodeUrl);

        User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => $validated['password'],
            'google2fa_secret' => $google2faKey,
        ]);

        return redirect('/show-code')->with('qrCode', $qrCodeSrc);
    }

    public function login(LoginRequest $request)
    {
        $validated = $request->validated();
        $user = User::where('name', $validated['name'])->first();

        if (!Hash::check($validated['password'], $user->password))
            return redirect('/');

        $label = $this->getRandom();
        AuthAttempt::create([
            'user_id' => $user->id,
            'label' => $label
        ]);

        return redirect('/identifyyourself')->withCookie($this->authAttemptCookie, $label);
    }

    public function doubleAuthenticate(Request $request)
    {
        try {
            $label = $request->cookie($this->authAttemptCookie)
                ?? throw new \Exception();
            $attemptRow = AuthAttempt::where('label', $label)->first()
                ?? throw new \Exception();
            $user = User::find($attemptRow->user_id)
                ?? throw new \Exception();
            $secret = $request->input('input')
                ?? throw new \Exception();

            $google2fa = new Google2FA();

            $valid = $google2fa->verifyKey($user->google2fa_secret, $secret);
            if (empty($valid))
                throw new \Exception();

            $attemptRow->delete();
            auth()->loginUsingId($user->id, true);
            return redirect('/')
                ->withCookie(Cookie::forget($this->authAttemptCookie));
        } catch (\Exception $e) {
            return redirect('/doubleFA');
        }
    }

    public function logout(Request $request)
    {
        auth()->logout();

        $request->session()->invalidate();

        $request->session()->regenerateToken();

        return redirect('/');
    }
}
