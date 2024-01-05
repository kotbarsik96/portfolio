<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;
use App\Models\Work;

class WorksRequest extends FormRequest
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
        $work = Work::where('name', $this->request->get('name'))->first();
        $ignoreId = $work ? $work->id : null;
        return [
            'name' => ['required', Rule::unique('works')->ignore($ignoreId)],
            'url' => 'nullable|regex:/^https?:\/\/.+\..+$/',
            'pages_count' => 'nullable|numeric',
            'image_desktop_id' => 'nullable|exists:images,id',
            'image_mobile_id' => 'nullable|exists:images,id',
        ];
    }

    public function messages()
    {
        return [
            'name.required' => 'Не указано название',
            'name.unique' => 'Работа с таким названием уже существует',
            'url.regex' => 'Неверный ыформат url',
            'pages_count' => 'Неверное количество страниц',
            'image_desktop_id.exists' => 'Изображение не существует',
            'image_mobile_id.exists' => 'Изображение не существует',
        ];
    }
}
