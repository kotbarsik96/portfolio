<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ImageRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return !auth()->guest();
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'image' => 'required|mimes:jpeg,jpeg,png|max:1024'
        ];
    }

    public function messages()
    {
        return [
            'image.required' => 'Изображение не указано',
            'image.mimes' => 'Допустимые форматы изображений: jpg, png',
            'image.max' => 'Изображение не должно весить более 1 МБ'
        ];
    }
}
