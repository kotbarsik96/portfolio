<script setup>
import { ref, computed } from 'vue'
import { Link } from '@inertiajs/vue3'
import ProgressBar from '../ProgressBar.vue'
import LoadingScreen from '../LoadingScreen.vue'
import { handleAjaxError } from '../../helpers/scripts.js'
import { useSaveModelValues } from '../../helpers/save-model-values.js'

const props = defineProps({
    title: {
        type: String,
        default: 'Изображение'
    },
    modelValue: Object,
    errors: Object,
    id: String
})
const emit = defineEmits(['update:modelValue'])

const isLoading = ref(false)
const input = ref(null)
const loadProgress = ref(0)
const errorsList = computed(() => props.errors ? Object.values(props.errors) : [])

const openExplorer = () => {
    if (isLoading.value)
        return

    input.value.click()
}

const onLoad = async (event) => {
    isLoading.value = true
    const formData = new FormData()
    formData.append('image', event.target.files[0])
    const link = props.modelValue && props.modelValue.id
        ? `/me/image/${props.modelValue.id}` : '/me/image'

    try {
        const res = await axios.post(link, formData, {
            onUploadProgress: (event) => {
                if (event.progress > 0.99)
                    loadProgress.value = 0
                else
                    loadProgress.value = Math.round(event.progress * 100)
            }
        })
        emit('update:modelValue', res.data.uploaded)
    } catch (err) {
        handleAjaxError(err)
    }

    clearInput()
    isLoading.value = false
}
const clearInput = () => {
    const dt = new DataTransfer()
    input.value.files = dt.files
}
const removeImage = () => {
    emit('update:modelValue', null)
}

useSaveModelValues().saveModelValues(props, emit)
</script>

<template>
    <div class="load-media">
        <div class="load-media__title" @click="openExplorer">
            {{ title }}
            <Transition name="scale-up">
                <Link :href="`/me/image/${modelValue.id}`" v-if="modelValue" preserve-scroll as="button" type="button"
                    method="delete" class="load-media__cancel" @click.stop="removeImage">
                <CancelIcon></CancelIcon>
                </Link>
            </Transition>
        </div>
        <div class="load-media__container" :class="{ 'load-media__container--loaded': modelValue }" @click="openExplorer">
            <Transition name="scale-up" mode="out-in">
                <ImagePicture v-if="modelValue" :obj="modelValue"></ImagePicture>
                <ImageIcon v-else></ImageIcon>
            </Transition>
            <LoadingScreen v-if="isLoading" isAbsolute></LoadingScreen>
        </div>
        <ProgressBar v-if="loadProgress" :loadProgress="loadProgress"></ProgressBar>
        <Transition name="fade-in">
            <div class="errors-list" v-if="errorsList.length > 0">
                <div class="errors-list__item" v-for="err in errorsList">
                    {{ err }}
                </div>
            </div>
        </Transition>
        <input type="file" accept="image/png, image/jpeg" @input="onLoad" ref="input">
    </div>
</template>