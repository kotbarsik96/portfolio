<script setup>
import { onMounted, ref, computed, onBeforeUnmount } from 'vue'
import { mapStringToObject } from '../helpers/scripts.js'

const props = defineProps({
    modelValue: {
        type: String,
        required: true
    },
    name: String,
    values: {
        type: Array,
        default: []
    },
    setDefault: Boolean
})
const emit = defineEmits(['update:modelValue'])

const isShown = ref(false)

const el = ref(null)
const list = ref(null)

const valueToShow = computed(() => {
    if (props.modelValue) {
        const obj = valuesArray.value.find(o => o.value === props.modelValue)
        if (obj)
            return obj.string

        return '(значение не выбрано)'
    }
})
const valuesArray = computed(() => props.values.map(mapStringToObject).filter(o => o))

const onChange = (obj) => {
    emit('update:modelValue', obj.value)
    isShown.value = false
}

const onDocumentClick = (event) => {
    if (event.target.closest('.select') === el.value)
        return

    setTimeout(() => isShown.value = false, 100);
}
const onSelectClick = (event) => {
    if (list.value && event.target.closest('.select__list') === list.value)
        return

    isShown.value = !isShown.value
}


onMounted(() => {
    if (valuesArray.value[0] && props.setDefault)
        emit('update:modelValue', valuesArray.value[0].value)

    if (typeof document !== 'undefined') {
        document.addEventListener('click', onDocumentClick)
    }
})
onBeforeUnmount(() => {
    document.removeEventListener('click', onDocumentClick)
})
</script>

<template>
    <div class="select" :class="{ '__shown': isShown }" @click="onSelectClick" ref="el">
        <span v-if="$slots.label" class="label">
            <slot name="label"></slot>
        </span>
        <div class="select__wrapper">
            <ChevronRightIcon class="select__icon"></ChevronRightIcon>
            <div class="select__value">
                {{ valueToShow || '(значение не выбрано)' }}
            </div>
            <Transition name="fade-in">
                <ul v-if="isShown" class="select__list" ref="list">
                    <li v-for="obj in valuesArray" :key="obj.value" class="select__item">
                        <label>
                            <input type="radio" :name="name" :value="obj.string" @change="onChange(obj)">
                            {{ obj.string }}
                        </label>
                    </li>
                </ul>
            </Transition>
        </div>
    </div>
</template>