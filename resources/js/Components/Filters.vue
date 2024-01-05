<template>
    <div class="filter modal">
        <div class="filter__header" @click="toggleIfHideable">
            <div class="filter__header-icon">
                <FilterIcon />
            </div>
            <div class="filter__header-title">
                Фильтр
            </div>
        </div>
        <div class="filter__body" ref="body">
            <div class="filter__section" v-for="section in sections">
                <div class="filter__section-title">
                    {{ section.title }}
                </div>
                <ul class="filter__section-list">
                    <li class="filter__section-list-item" v-for="obj in section.list">
                        <CheckboxLabel :value="obj.value" :name="section.name" @change="onChange">
                            {{ obj.title }}
                        </CheckboxLabel>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed, ref, watch, onMounted } from 'vue'
import CheckboxLabel from '@/Components/CheckboxLabel.vue'
import { useMediaQueries } from '@/helpers/media-queries.js'
import { gsap } from 'gsap'

const gsapDuration = .3
const mediaQueries = useMediaQueries()
const hideableQueryMedia = 1259
mediaQueries.register(hideableQueryMedia, 'max-width')

const body = ref(null)

const isShown = ref(false)

const isHideable = computed(() => mediaQueries.matches[hideableQueryMedia])

const props = defineProps({
    modelValue: Object,
    sections: {
        type: Array,
        validator(value) {
            for (let obj of value) {
                if (typeof obj.name !== 'string' || typeof obj.title !== 'string')
                    return false
                if (!Array.isArray(obj.list))
                    return false

                for (let subobj of obj.list) {
                    if (typeof subobj.title !== 'string' || typeof subobj.value !== 'string')
                        return false
                }
            }

            return true
        }
    }
})

const emit = defineEmits(['update:modelValue'])

watch(isHideable, () => {
    if (!isHideable.value)
        gsap.set(body.value, { maxHeight: body.value.scrollHeight })
    else 
        toggleIfHideable()
})

const _mv = Object.assign({}, props.modelValue)
props.sections.forEach(obj => {
    if (!Array.isArray(_mv[obj.name]))
        _mv[obj.name] = []
})
emit('update:modelValue', _mv)

onMounted(() => toggleIfHideable())

function toggleIfHideable() {
    if (!isHideable.value)
        return

    if (isShown.value) {
        isShown.value = false
        gsap.to(body.value, { maxHeight: 0, duration: gsapDuration })
    } else {
        isShown.value = true
        gsap.to(body.value, { maxHeight: body.value.scrollHeight + 10, duration: gsapDuration })
    }
}

function onChange(data) {
    const value = data.value
    const name = data.name

    const updatedMV = Object.assign({}, props.modelValue)
    if (data.checked) {
        if (!updatedMV[name].find(v => v === value))
            updatedMV[name].push(value)
    } else {
        updatedMV[name] = updatedMV[name].filter(v => v !== value)
    }
    emit('update:modelValue', updatedMV)
}
</script>