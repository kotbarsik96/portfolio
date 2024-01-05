<script setup>

defineProps({
    isAbsolute: Boolean,
    isFixed: Boolean
})
</script>

<template>
    <div class="loading" :class="{
        'loading--absolute': isAbsolute,
        'loading--fixed': isFixed
    }"></div>
</template>