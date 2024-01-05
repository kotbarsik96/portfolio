<script setup>
import { onMounted, ref, getCurrentInstance } from 'vue'
import usePopupsHelpers from './'
import { gsap } from 'gsap'

const popupHelpers = usePopupsHelpers(getCurrentInstance())

const props = defineProps({
    id: Number,
    message: String,
    timeout: {
        type: Number,
        default: 7500
    }
})

const removeSelf = popupHelpers.removeSelf
const removeTimeout = setTimeout(removeSelf, props.timeout)

const bar = ref(null)

onMounted(() => {
    gsap.set(bar.value, { scaleX: 0 })
    gsap.to(bar.value, {
        scaleX: 1,
        duration: props.timeout / 1000,
        ease: 'none'
    })
})
</script>

<template>
    <div class="popup">
        <button class="popup__close" type="button" @click="removeSelf(removeTimeout)">
            <CancelIcon></CancelIcon>
        </button>
        <div class="popup__text" v-html="message"></div>
        <div class="popup__scale">
            <div class="popup__bar" ref="bar"></div>
        </div>
    </div>
</template>