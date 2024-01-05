<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class LoginRequest extends FormRequest
{
    public function authorize(): bool
    {
        return auth()->guest();
    }

    public function rules(): array
    {
        return [
            'name' => 'required|exists:users',
            'password' => 'required'
        ];
    }

    public function messages()
    {
        return [
            'name' => 'Имя не указано/указано неверно',
            'password' => 'Пароль не указан/указан неверно'
        ];
    }
}
