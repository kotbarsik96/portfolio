<template>
    <li class="skill-item" :class="{ '__shown-links': isShownLinks }" ref="el">
        <div class="skill-item__buttons">
            <button v-if="data.image_path" class="skill-item__button" :class="{ '__active': mediaType === 'image' }"
                type="button" aria-label="Изображение" @click="changeMedia('image')">
                <ImageIcon />
            </button>
            <button v-if="data.video_path" class="skill-item__button" :class="{ '__active': mediaType === 'video' }"
                type="button" aria-label="Видео" @click="changeMedia('video')">
                <VideoIcon />
            </button>
            <button v-if="slicedLinksPages.length > 0" class="skill-item__button" :class="{ '__active': isShownLinks }"
                type="button" aria-label="Дополнительно" @click="toggleLinks">
                <QuestionMarkIcon />
            </button>
            <Link v-if="isMe" :href="`/me/skill/${data.id}`" class="skill-item__button">
            <PencilIcon />
            </Link>
        </div>
        <div class="skill-item__container" ref="itemContainer">
            <div class="skill-item__folder-back" :style="{ backgroundImage: folderBackgroundBack }">
            </div>
            <div class="skill-item__links">
                <div class="skill-item__links-container">
                    <ol class="skill-item__links-list" ref="linksList" v-html="currentShownLinks"></ol>
                </div>
                <div v-if="slicedLinksPages.length > 1" class="skill-item__links-pagination">
                    <button class="skill-item__links-prev" type="button" @click="linksPageNumber--"
                        :disabled="isFirstLinksPage">
                        <ChevronRightIcon />
                    </button>
                    <span>|</span>
                    <button class="skill-item__links-next icon-chevron-right" type="button" @click="linksPageNumber++"
                        :disabled="isLastLinksPage">
                        <ChevronRightIcon />
                    </button>
                </div>
            </div>
            <div class="skill-item__media-container" ref="mediaContainer">
                <Transition name="shrink-out" mode="out-in">
                    <ImagePicture v-if="imageSrc && mediaType === 'image'" class="skill-item__media" :path="imageSrc" :alt="data.name" />
                    <VideoPlayer v-else-if="videoSrc && mediaType === 'video'" class="skill-item__media" :src="videoSrc">
                    </VideoPlayer>
                </Transition>
            </div>
            <div class="skill-item__folder-front" :style="{ backgroundImage: folderBackgroundFront }">
            </div>
        </div>
        <div class="skill-item__text">
            <button class="skill-item__title" type="button" @click="toggleLinks">
                {{ data.name }}
            </button>
        </div>
    </li>
</template>

<script setup>
import { getCoords } from '../../helpers/scripts.js'
import VideoPlayer from '../VideoPlayer.vue'
import { onMounted, ref, computed } from 'vue'
import gsap from 'gsap'
import { Link } from "@inertiajs/vue3"
import { useGlobalStore } from '@/store/global.js'

import folderBackUrl from '/resources/images/portfolio-item/folder-back.png'
import folderFrontUrl from '/resources/images/portfolio-item/folder-front.png'
import folderBackDarkUrl from '/resources/images/portfolio-item/folder-dark-back.png'
import folderFrontDarkUrl from '/resources/images/portfolio-item/folder-dark-front.png'

const props = defineProps({
    data: {
        type: Object,
        required: true
    }
})

const globalStore = useGlobalStore()
const theme = computed(() => globalStore.theme)
const isMe = computed(() => globalStore.isMe)

const isShownLinks = ref(true)
const mediaType = ref('')
const isTogglingLinks = ref(false)
const sliceLinksTimeout = ref(null)
const slicedLinksPages = ref([])
const linksPageNumber = ref(1)

const mediaContainer = ref(null)
const el = ref(null)
const linksList = ref(null)

const folderBackgroundBack = computed(() => {
    if (theme.value === 'light')
        return `url(${folderBackUrl})`
    if (theme.value === 'dark')
        return `url(${folderBackDarkUrl})`
})
const folderBackgroundFront = computed(() => {
    if (theme.value === 'light')
        return `url(${folderFrontUrl})`
    if (theme.value === 'dark')
        return `url(${folderFrontDarkUrl})`
})
const imageSrc = computed(() => {
    if (props.data.image_path) {
        if (!mediaType.value) {
            mediaType.value = 'image'
            isShownLinks.value = false
        }
        return `${import.meta.env.VITE_LINK}${props.data.image_path}`
    }

    return null
})
const videoSrc = computed(() => {
    if (props.data.video_path) {
        if (!mediaType.value) {
            mediaType.value = 'video'
            isShownLinks.value = false
        }
        return props.data.video_path
    }

    return null
})
const currentShownLinks = computed(() => {
    if (!linksList.value)
        return []

    gsap.set(linksList.value, { opacity: 0 })
    gsap.to(linksList.value, { opacity: 1, duration: .2 })
    if (slicedLinksPages.value.length > 0)
        return slicedLinksPages.value[linksPageNumber.value - 1]?.join('')

    return 'Для данного навыка пока не добавлены работы'
})
const isFirstLinksPage = computed(() => {
    return linksPageNumber.value === 1
})
const isLastLinksPage = computed(() => {
    return linksPageNumber.value === slicedLinksPages.value.length
})

onMounted(() => {
    sliceLinksPages()
    if (typeof window !== 'undefined') {
        window.addEventListener("resize", onWindowResize);
    }
})

function onWindowResize() {
    // таким образом метод будет вызван спустя некоторое время после того, как пользователь изменит размер экрана, иначе он будет вызываться очень много раз
    if (sliceLinksTimeout.value)
        clearInterval(sliceLinksTimeout.value);
    sliceLinksTimeout.value = setTimeout(sliceLinksPages, 500);
}
function toggleLinks() {
    if (isTogglingLinks.value)
        return

    isTogglingLinks.value = true

    el.value.style.zIndex = '100'
    let translateCoef = mediaContainer.value.offsetWidth
    // если при сдвиге вправо изображение будет выходить за границы документа, сдвинуть его влево
    const isGoingOutOfDocument = getCoords(mediaContainer.value).right + translateCoef
        > document.documentElement.clientWidth - 30
    if (isGoingOutOfDocument)
        translateCoef = -1 * translateCoef

    gsap.to(mediaContainer.value, {
        x: translateCoef,
        duration: .2,
        ease: 'ease',
        // учитывается, что isShownLinks еще не изменен
        scale: isShownLinks.value ? 1 : .9,
        marginRight: isShownLinks.value ? 0 : 45,
        onComplete: () => {
            // показать изображение/видео, спрятать ссылки
            if (isShownLinks.value)
                isShownLinks.value = false
            // показать ссылки, спрятать изображение/видео
            else
                isShownLinks.value = true

            gsap.to(mediaContainer.value, { x: 0, ease: 'ease' })
            el.value.style.removeProperty('z-index')
            isTogglingLinks.value = false
        }
    })
}
async function changeMedia(newMediaType) {
    if (mediaType.value === newMediaType)
        return

    mediaType.value = newMediaType
}
function sliceLinksPages() {
    if(!linksList.value)
        return
    
    slicedLinksPages.value = []
    gsap.set(linksList.value, { opacity: 0 })
    const clone = linksList.value.cloneNode(true)
    linksList.value.after(clone)
    gsap.set(clone, { opacity: 0, visibility: 'hidden', position: 'absolute' })

    const items = []
    props.data.works?.forEach((obj, i) => {
        let text = obj.name
        if (obj.comment)
            text += ` (${obj.comment})`

        items.push(`
            <li class="skill-item__link-item">
                ${i + 1}. ${text}
            </li>
        `)
    })

    while (items.length > 0) {
        let page = [...items]
        let i = page.length
        do {
            page = page.slice(0, i)
            clone.innerHTML = page.join('')
            i--

        } while (page.length > 0 && clone.scrollHeight > clone.offsetHeight)
        slicedLinksPages.value.push(page)
        items.splice(0, page.length)
        if (page.length < 1)
            break
    }

    clone.remove()

    gsap.to(linksList.value, { opacity: 1 })
}
</script>