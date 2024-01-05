<script setup>

const props = defineProps({
    loadProgress: {
        type: Number,
        default: 0
    }
})
</script>

<template>
    <div class="loading-scale">
        <div class="loading-scale__progressbar" :style="{ 'width': `${loadProgress}%` }"></div>
        <div class="loading-scale__percentage">
            {{ loadProgress }} %
        </div>
    </div>
</template>
