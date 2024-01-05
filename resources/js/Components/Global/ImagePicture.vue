<template>
    <picture :class="{ '__empty': !wasIntersected }" ref="el">
        <source :srcset="supportsWebp ? webpSrc : noWebpSrc" :media="media">
        <source v-for="obj in mediaSourcesComputed" :srcset="getSrcset(obj)" :media="obj.media">
        <img :src="noWebpSrc" :alt="alt" ref="img">
    </picture>
</template>

<script setup>
import { onMounted, computed, ref } from 'vue'
import { getImagePath, checkMediaRegexp } from '../../helpers/scripts.js'
import { useGlobalStore } from "@/store/global.js"

const globalStore = useGlobalStore()

const props = defineProps({
    alt: String,
    obj: Object,
    path: String,
    media: {
        type: String,
        validator(media) {
            return checkMediaRegexp(media)
        }
    },
    /* прочие варианты изображений. Используют те же пропсы */
    mediaSources: {
        type: Array,
        validator(array) {
            for (let obj of array) {
                if (typeof obj.media !== 'string')
                    return false
                if (!checkMediaRegexp(obj.media))
                    return false

                if (obj.webpPath && typeof obj.webpPath !== 'string')
                    return false
                if (obj.path && typeof obj.path !== 'string')
                    return false

                if (obj.obj && typeof obj.obj !== 'object')
                    return false
            }

            return true
        }
    },
    /* позволяет задать дополнительные требования для ленивой загрузки. Только при удовлетворении всех требований и wasIntersected.value === true будут выставлены src и srcset */
    lazyLoadConditions: Object
})

const wasIntersected = ref(false)
const isVisible = computed(() => {
    if (props.lazyLoadConditions && typeof props.lazyLoadConditions === 'object') {
        for (let bool of Object.values(props.lazyLoadConditions)) {
            if (!bool)
                return false
        }
    }
    return wasIntersected.value
})
const noWebpSrc = computed(() => {
    if (!isVisible)
        return '#'

    if (props.path)
        return getImagePath(props.path)

    return getImagePath(props.obj)
})
const webpSrc = computed(() => {
    if (!isVisible)
        return '#'

    if (props.path)
        return getImagePath(props.path, { isWebp: true })

    return getImagePath(props.obj, { isWebp: true })
})
const mediaSourcesComputed = computed(() => {
    if (!wasIntersected)
        return []

    return props.mediaSources
})
const supportsWebp = computed(() => globalStore.supportsWebp)

const el = ref(null)
const img = ref(null)

const onIntersect = (entries) => {
    entries.forEach(entry => {
        if (!entry.isIntersecting)
            return

        wasIntersected.value = true
        if (el.value)
            observer.value.unobserve(el.value)
        observer.value = null
    })
}
const observer = ref(new IntersectionObserver(onIntersect))

onMounted(() => {
    observer.value.observe(el.value)
})

defineExpose({
    el,
    img
})

function getSrcset(obj) {
    if (obj.webpPath)
        return getImagePath(obj.webpPath, { isWebp: supportsWebp })

    return getImagePath(obj.obj, { isWebp: supportsWebp })
}
</script>