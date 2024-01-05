<template>
    <div class="wrapper">
        <Head>
            <title>Портфолио</title>
            <meta name="description"
                content="Портфолио Никифорова Алексея kotbarsik96. Здесь собраны мои работы по веб-разработке">
        </Head>
        <PageHeader :routeName="routeName"></PageHeader>
        <slot></slot>
        <TransitionGroup tag="div" name="fade-in" class="modal-windows">
            <component v-for="obj in modalsList" :key="obj.modalId" :is="obj.component"></component>
        </TransitionGroup>
        <TransitionGroup tag="div" name="popups-list" class="popups-list">
            <component v-for="obj in popupsList" :key="obj.id" :is="obj.component"></component>
        </TransitionGroup>
        <Transition name="fade-in">
            <div v-if="modalsStore.mediaModal" class="media-modal-window" ref="mediaModalWindow"
                @pointerdown.self="onMediaModalPointerdown"></div>
        </Transition>
    </div>
</template>

<script setup>
import PageHeader from './PageHeader.vue'
import { ref, computed, provide, watch, watchEffect } from 'vue'
import { useModalsStore } from '../store/modals.js'
import { useGlobalStore } from '../store/global.js'
import { usePopupsStore } from '../store/popups.js'
import { Head } from '@inertiajs/vue3'

const mediaModalWindow = ref(null)

const modalsStore = useModalsStore()
const popupsStore = usePopupsStore()
const modalsList = computed(() => modalsStore.modalsList)
const popupsList = computed(() => popupsStore.popupsList)

const props = defineProps({
    routeName: String
})

const globalStore = useGlobalStore()
globalStore.init()

const theme = computed(() => globalStore.theme)

provide('routeName', ref(props.routeName))

watchEffect(() => {
    if (typeof document !== 'undefined') {
        if (theme.value === 'dark')
            document.querySelector('html').classList.add('dark-theme')
        else
            document.querySelector('html').classList.remove('dark-theme')
    }
})
watch(mediaModalWindow, () => {
    if (mediaModalWindow.value) {
        mediaModalWindow.value.innerHTML = ''
        mediaModalWindow.value.append(modalsStore.mediaModal.el)
    }
})

const onMediaModalPointerdown = (event) => {
    const onPointerup = (upEvent) => {
        if (upEvent.target !== event.target)
            return

        modalsStore.removeMedia()
        event.target.removeEventListener('pointerup', onPointerup)
    }

    event.target.addEventListener('pointerup', onPointerup)
}
</script>