<script setup>
// добавить загруженного в cookie
import { ref, computed } from 'vue'
import { Link } from '@inertiajs/vue3'
import ProgressBar from '../ProgressBar.vue'
import LoadingScreen from '../LoadingScreen.vue'
import { handleAjaxError } from '../../helpers/scripts.js'
import { useSaveModelValues } from '../../helpers/save-model-values.js'
import Resumable from 'resumablejs'
import { onMounted } from 'vue'
import Cookies from 'js-cookie'
import VideoPlayer from '../VideoPlayer.vue'


const props = defineProps({
    title: {
        type: String,
        default: 'Видео'
    },
    modelValue: Object,
    errors: Object,
    id: String
})
const emit = defineEmits(['update:modelValue'])

const input = ref(null)

const isLoading = ref(false)
const loadProgress = ref(0)
const errorsList = computed(() => props.errors ? Object.values(props.errors) : [])
const resumable = new Resumable({
    target: '/me/video',
    headers: {
        'X-XSRF-TOKEN': Cookies.get('XSRF-TOKEN'),
        'Accept': 'application/json'
    },
    testChunks: false,
})

const openExplorer = () => {
    if (props.modelValue || isLoading.value)
        return

    input.value.click()
}

const removeVideo = () => {
    emit('update:modelValue', null)
}

const addVideo = () => {
    resumable.addFile(input.value.files[0])
    clearInput()
}

const clearInput = () => {
    const dt = new DataTransfer()
    input.value.files = dt.files
}

useSaveModelValues().saveModelValues(props, emit)

onMounted(() => {
    resumable.on('fileAdded', () => {
        isLoading.value = true
        resumable.upload()
    })
    resumable.on('fileProgress', (event) => {
        loadProgress.value = Math.round(event.progress() * 100)
    })
    resumable.on('fileError', () => {
        isLoading.value = false
        handleAjaxError({ errors: ['Произошла ошибка при загрузке видео'] })
    })
    resumable.on('fileSuccess', (file, res) => {
        loadProgress.value = 0
        isLoading.value = false

        res = JSON.parse(res)
        emit('update:modelValue', res.video)
        resumable.removeFile(file)
    })
})
</script>

<template>
    <div class="load-media">
        <div class="load-media__title" @click="openExplorer">
            {{ title }}
            <Transition name="scale-up">
                <Link :href="`/me/video/${modelValue.id}`" v-if="modelValue" preserve-scroll as="button" type="button"
                    method="delete" class="load-media__cancel" @click.stop="removeVideo">
                <CancelIcon></CancelIcon>
                </Link>
            </Transition>
        </div>
        <div class="load-media__container" :class="{ 'load-media__container--loaded': modelValue }" @click="openExplorer">
            <Transition name="scale-up" mode="out-in">
                <VideoPlayer v-if="modelValue" :src="modelValue.path"></VideoPlayer>
                <VideoIcon v-else></VideoIcon>
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
        <input type="file" accept="video/mp4" ref="input" @input="addVideo">
    </div>
</template>