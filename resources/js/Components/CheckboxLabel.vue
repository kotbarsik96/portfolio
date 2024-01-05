<template>
    <label class="checkbox-label">
        <input type="checkbox" :name="props.name" :value="props.value" :checked="props.checked" @change="onChange">
        <span class="checkbox-label__box"></span>
        <span class="checkbox-label__text">
            <slot></slot>
        </span>
    </label>
</template>

<script setup>
const props = defineProps({
    value: {
        type: String,
        required: true
    },
    name: {
        type: String,
        required: true
    },
    checked: Boolean
})
const emit = defineEmits(['change'])

const onChange = (event) => {
    emit('change', {
        value: props.value,
        checked: event.target.checked,
        name: props.name
    })
}
</script>