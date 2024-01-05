<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class SignupRequest extends FormRequest
{
    public function authorize(): bool
    {
        return auth()->guest();
    }

    public function rules(): array
    {
        return [
            'name' => 'required|unique:users|max:50',
            'email' => 'required|unique:users|email:rfc,dns',
            'password' => 'required|confirmed',
        ];
    }

    public function messages()
    {
        return [
            'required' => 'Не указано поле :attribute',
            'name.unique' => 'Пользователь с таким именем уже существует',
            'email.unique' => 'Пользователь с таким email уже существует',
            'password.confirmed' => 'Пароль не подтвержден'
        ];
    }

    public function attributes()
    {
        return [
            'name' => 'Имя',
            'email' => 'Email',
            'password' => 'Пароль'
        ];
    }
}
