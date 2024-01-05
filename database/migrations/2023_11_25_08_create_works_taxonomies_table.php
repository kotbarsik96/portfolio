<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('works_taxonomies', function (Blueprint $table) {
            $table->id();
            $table->foreignId('work_id')
                ->constrained('works')
                ->cascadeOnDelete()
                ->cascadeOnUpdate();
            $table->foreignId('taxonomy_id')
                ->constrained('taxonomies')
                ->cascadeOnDelete()
                ->cascadeOnUpdate();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('works_taxonomies');
    }
};
