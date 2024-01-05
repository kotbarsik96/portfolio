<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class TaxonomiesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $now = DB::raw('NOW()');

        // типы
        DB::table('taxonomy_types')->insert([
            'type' => 'stack',
            'title' => 'Стек',
            'created_at' => $now,
            'updated_at' => $now
        ]);
        DB::table('taxonomy_types')->insert([
            'type' => 'type',
            'title' => 'Тип',
            'created_at' => $now,
            'updated_at' => $now
        ]);
        DB::table('taxonomy_types')->insert([
            'type' => 'tag',
            'title' => 'Тег',
            'created_at' => $now,
            'updated_at' => $now
        ]);

        // значения: стек
        DB::table('taxonomies')->insert([
            'type' => 'stack',
            'name' => 'HTML'
        ]);
        DB::table('taxonomies')->insert([
            'type' => 'stack',
            'name' => 'CSS'
        ]);
        DB::table('taxonomies')->insert([
            'type' => 'stack',
            'name' => 'JavaScript'
        ]);
        DB::table('taxonomies')->insert([
            'type' => 'stack',
            'name' => 'PHP'
        ]);
        DB::table('taxonomies')->insert([
            'type' => 'stack',
            'name' => 'Vue JS 3'
        ]);
        DB::table('taxonomies')->insert([
            'type' => 'stack',
            'name' => 'Laravel'
        ]);
        DB::table('taxonomies')->insert([
            'type' => 'stack',
            'name' => 'MySQL'
        ]);
        DB::table('taxonomies')->insert([
            'type' => 'stack',
            'name' => 'Gulp'
        ]);
        DB::table('taxonomies')->insert([
            'type' => 'stack',
            'name' => 'Vite'
        ]);
        DB::table('taxonomies')->insert([
            'type' => 'stack',
            'name' => 'Git'
        ]);

        // значения: тип
        DB::table('taxonomies')->insert([
            'type' => 'type',
            'name' => 'Верстка по макету'
        ]);
        DB::table('taxonomies')->insert([
            'type' => 'type',
            'name' => 'Интеграция с backend'
        ]);

        // значения: тег
        DB::table('taxonomies')->insert([
            'type' => 'tag',
            'name' => 'Лендинг'
        ]);
        DB::table('taxonomies')->insert([
            'type' => 'tag',
            'name' => 'Интернет-магазин'
        ]);
        DB::table('taxonomies')->insert([
            'type' => 'tag',
            'name' => 'Блог/Интернет-магазин'
        ]);
    }
}
