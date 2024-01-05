<template>
    <a :href="href" ref="el" @click.prevent="onClick">
        <slot></slot>
    </a>
</template>

<script setup>
import { getCoords } from '@/helpers/scripts'
import { ref, computed } from 'vue'

const props = defineProps({
    href: String
})

const anchor = computed(() => props.href.includes('#') ? props.href : `#${props.href}`)

const el = ref(null)

function onClick() {
    const target = document.querySelector(anchor.value)
    if (!target)
        return

    const coords = getCoords(target)
    window.scrollTo({
        behavior: 'smooth',
        top: coords.top - 100
    })
}
</script>