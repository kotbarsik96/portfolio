<script setup>
import { ref, computed, onBeforeUnmount } from 'vue'

const emit = defineEmits(['update:modelValue', 'enterKeyup'])
const props = defineProps({
    name: {
        type: String,
        required: true
    },
    type: {
        type: String,
        default: 'text'
    },
    modelValue: [String, Number],
    initialValue: [String, Number],
    numberonly: Boolean,
    id: String,
    autocomplete: String,
    placeholder: String
})

if(props.initialValue)
    emit('update:modelValue', props.initialValue)

const screenWidth = typeof document !== 'undefined'
    ? ref(document.documentElement.clientWidth)
    : 0
const minPadding = ref(40)

const textInputBefore = ref(null)
const textInputAfter = ref(null)

const calcPadding = (textInputElem) => {
    let coef = screenWidth.value * 0.003
    if (coef > 5 || coef < 3)
        coef = 5

    if (!textInputElem)
        return `${minPadding.value}px`

    const width = textInputElem.offsetWidth
    if (width < 1)
        return `${minPadding.value}px`

    return `${minPadding.value + width / 2 + coef}px`
}
const paddingLeft = computed(() => calcPadding(textInputBefore.value))
const paddingRight = computed(() => calcPadding(textInputAfter.value))

const onInput = (event) => {
    let value = event.target.value
    if (props.numberonly)
        value = event.target.value = value.replace(/\D/g, '')
    emit('update:modelValue', value)
}
const onResize = () => {
    screenWidth.value = typeof document === 'undefined'
        ? document.documentElement.clientWidth
        : 0
}

if (typeof window !== 'undefined') {
    window.addEventListener('resize', onResize)
    onBeforeUnmount(() => window.removeEventListener('resize', onResize))
}
</script>

<template>
    <div class="text-input">
        <label v-if="$slots.label" :for="id" class="label">
            <slot name="label"></slot>
        </label>
        <div class="text-input__wrapper">
            <div class="text-input__before" ref="textInputBefore">
                <slot name="before"></slot>
            </div>
            <input class="text-input__input" :style="{ 'padding-left': paddingLeft, 'padding-right': paddingRight }"
                :placeholder="placeholder" :type="type" :autocomplete="autocomplete" :id="id" :value="modelValue"
                @input="onInput" @keyup.enter="$emit('enterKeyup')">
            <div class="text-input__after" ref="textInputAfter" v-if="$slots.after">
                <slot name="after"></slot>
            </div>
        </div>
        <Transition name="grow">
            <div class="text-input__error" v-if="$slots.error">
                <slot name="error"></slot>
            </div>
        </Transition>
    </div>
</template>