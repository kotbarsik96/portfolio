<template>
    <div class="video-player-container" ref="el" @click="onFirstOfDoubleClick">
        <div class="video-player" :class="{ 'is-playing': isPlaying }">
            <div class="video-player__controls" :style="{ backgroundColor: controlsBackgroundColor }"
                @click="onControlsClick">
                <Transition name="fade-in">
                    <button v-if="isPlaying" class="video-player__pause-button" type="button" aria-label="Пауза">
                        <PauseIcon></PauseIcon>
                    </button>
                    <button v-else class="video-player__play-button" type="button" aria-label="Воспроизвести">
                        <PlayVideoIcon></PlayVideoIcon>
                    </button>
                </Transition>
                <div class="video-player__track" ref="track">
                    <div class="video-player__track-upper">
                        <div class="video-player__timer">
                            <span class="video-player__timer-current">
                                {{ currentTime }}
                            </span>
                            <span class="video-player__timer-delimeter">/</span>
                            <span class="video-player__timer-duration">
                                {{ durationTime }}
                            </span>
                        </div>
                        <button class="video-player__expand" @click="expandOrShrink" aria-label="На весь экран">
                            <ExpandIcon></ExpandIcon>
                        </button>
                    </div>
                    <div class="video-player__scale" ref="scale" @pointerdown="onScalePointerdown">
                        <div class="video-player__bar" :style="{ 'width': `${barWidth}%` }" ref="bar">
                            <div class="video-player__toddler" ref="toddler" @pointerdown="onToddlerPointerdown"></div>
                        </div>
                    </div>
                </div>
            </div>
            <video class="video-player__video" :src="videoSrc" muted loop preload="metadata" ref="video"
                @loadedmetadata="onVideoLoad" @timeupdate="onTimeupdate" @click="pauseOrPlay"></video>
        </div>
    </div>
</template>

<script setup>
import { formatSeconds, getCoords } from '../helpers/scripts.js'
import { useModalsStore } from '../store/modals.js'
import { onMounted, ref, computed, getCurrentInstance } from 'vue'

const props = defineProps({
    src: {
        type: String,
        required: true
    }
})

const modalsStore = useModalsStore()

const el = ref(null)
const scale = ref(null)
const bar = ref(null)
const toddler = ref(null)
const video = ref(null)
const isExpanded = ref(false)

const barWidth = ref(0)
const intersectionObs = ref(null)
const videoSrc = ref('') // меняется благодаря IntersectionObserver
const isPlaying = ref(false)
const durationTime = ref('00:00')
const currentTime = ref('00:00')
const currentTimeSeconds = ref(0)
const durationTimeSeconds = ref(0)
const isMovingToddlerByPointer = ref(false)

const controlsBackgroundColor = computed(() => {
    if (isPlaying.value)
        return 'transparent'

    return 'rgba(0, 0, 0, 0.25)'
})

const ctx = getCurrentInstance()

// перемотка, управление шкалой воспроизведения
function onTimeupdate() {
    if (!video.value)
        return

    const l_durationTimeSeconds = parseInt(video.value.duration)
    const l_durationTime = formatSeconds(l_durationTimeSeconds)
    if (durationTime.value !== l_durationTime)
        durationTime.value = l_durationTime
    if (durationTimeSeconds.value !== l_durationTimeSeconds)
        durationTimeSeconds.value = l_durationTimeSeconds

    if (!isMovingToddlerByPointer.value) {
        const l_currentTimeSeconds = video.value.currentTime
        currentTimeSeconds.value = l_currentTimeSeconds
        currentTime.value = formatSeconds(l_currentTimeSeconds)
    }

    moveToddlerByTime()
}
function moveToddlerByTime() {
    // когда пользователь двигает ползунок, данный метод не отрабатывает
    if (isMovingToddlerByPointer.value)
        return

    let percent = parseInt(currentTimeSeconds.value / (durationTimeSeconds.value / 100))
    setBarWidthByPercent(percent)
}
function setBarWidthByPercent(percent) {
    if (percent < 0)
        percent = 0
    if (percent > 100)
        percent = 100

    barWidth.value = percent
}
function onToddlerPointerdown() {
    isMovingToddlerByPointer.value = true
    const scaleCoords = getCoords(scale.value)
    const scaleWidth = scaleCoords.right - scaleCoords.left
    const toddlerOffset = toddler.value.offsetWidth / 2

    let percent = barWidth.value
    percent = percent + toddlerOffset / (scaleWidth / 100)

    document.addEventListener('pointermove', onPointermove)
    document.addEventListener('pointerup', onPointerup)

    function onPointermove(moveEvent) {
        const pageX = moveEvent.pageX || moveEvent.detail.pageX
        const toddlerX = pageX - scaleCoords.left + toddlerOffset
        percent = parseInt(toddlerX / (scaleWidth / 100))
        setBarWidthByPercent(percent)

        calcCurrentTime(percent)
    }
    function onPointerup() {
        // изменить currentTime
        percent = parseInt(percent)
        if (percent || percent === 0) {
            calcCurrentTime(percent)
            video.value.currentTime = currentTimeSeconds.value
        }
        // убрать обработчик
        document.removeEventListener('pointermove', onPointermove)
        document.removeEventListener('pointerup', onPointerup)
        isMovingToddlerByPointer.value = false
    }
    function calcCurrentTime(percent) {
        currentTimeSeconds.value = durationTimeSeconds.value / 100 * percent
        currentTime.value = formatSeconds(currentTimeSeconds.value)
    }
}
function onScalePointerdown(event) {
    const scaleCoords = getCoords(scale.value)
    const scaleWidth = scaleCoords.right - scaleCoords.left
    const clickX = event.pageX - scaleCoords.left
    const percent = clickX / (scaleWidth / 100)
    setBarWidthByPercent(percent)

    onToddlerPointerdown()
    document.dispatchEvent(
        new CustomEvent('pointermove', { detail: { pageX: event.pageX } })
    )
}
// конец - перемотка, управление шкалой воспроизведения

// пауза/воспроизведение
function pauseOrPlay() {
    isPlaying.value = !isPlaying.value
    isPlaying.value ? play() : pause()
}
function play() {
    isPlaying.value = true
    video.value.play()
}
function pause() {
    isPlaying.value = false
    video.value.pause()
}
// конец - пауза/воспроизведение

function onVideoLoad() {
    onTimeupdate()
}
function onControlsClick(event) {
    const playPauseExceptions = ['.video-player__track']
    let isPlayPauseException = false
    for (let selector of playPauseExceptions) {
        if (event.target.closest(selector)) {
            isPlayPauseException = true
            break
        }
    }
    if (isPlayPauseException == false)
        pauseOrPlay()
}

function expandOrShrink() {
    isExpanded.value = !isExpanded.value

    if (isExpanded.value)
        modalsStore.addMedia(ctx)
    else
        modalsStore.removeMedia()
}

function onFirstOfDoubleClick(event) {
    el.value.addEventListener('pointerdown', onDoublePointerDown)

    setTimeout(() => {
        el.value.removeEventListener('pointerdown', onDoublePointerDown)
    }, 250);

    function onDoublePointerDown() {
        el.value.removeEventListener('pointerdown', onDoublePointerDown)
        expandOrShrink()
    }
}

onMounted(() => {
    scale.value.ondragstart = () => false
    bar.value.ondragstart = () => false
    toddler.value.ondragstart = () => false

    intersectionObs.value = new IntersectionObserver((entries) => {
        for (let entry of entries) {
            if (entry.target === el.value) {
                if (entry.isIntersecting) {
                    videoSrc.value = props.src.startsWith('/') ? props.src : `/${props.src}`
                    intersectionObs.value.disconnect()
                }
                break
            }
        }
    }, {
        root: null,
        threshold: 0.2
    })
    intersectionObs.value.observe(el.value)
})
</script>

<style>
.video-player__pause-button.fade-in-enter-active,
.video-player__pause-button.fade-in-leave-active {
    position: absolute
}
</style>