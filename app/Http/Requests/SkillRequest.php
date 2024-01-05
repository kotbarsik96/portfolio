<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class SkillRequest extends FormRequest
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
            'name' => ['required', Rule::unique('skills')->ignore($this->request->get('id'))],
            'image_id' => 'nullable|exists:images,id',
            'video_id' => 'nullable|exists:video,id'
        ];
    }

    public function messages()
    {
        return [
            'required' => ':attribute не указано',
            'exists' => ':attribute не существует',
            'name.unique' => 'Навык с таким названием уже существует'
        ];
    }

    public function attributes()
    {
        return [
            'name' => 'Название',
            'image_id' => 'Изображение',
            'video_id' => 'Видео'
        ];
    }
}
