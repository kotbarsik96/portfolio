<template>
    <li class="portfolio-item" :class="{ '__shown-skills': isShownSkills }" ref="el">
        <div class="portfolio-item__buttons">
            <button v-if="data.image_desktop" class="portfolio-item__button"
                :class="{ '__active': imageType === 'desktop' }" type="button" aria-label="Десктоп версия" @click="changeImage('desktop')">
                <DesktopIcon />
            </button>
            <button v-if="slicedSkillsPages.length > 0" class="portfolio-item__button"
                :class="{ '__active': isShownSkills }" type="button" aria-label="Дополнительно" @click="toggleLinks">
                <QuestionMarkIcon />
            </button>
            <button v-if="data.image_mobile" class="portfolio-item__button" :class="{ '__active': imageType === 'mobile' }"
                type="button" aria-label="Мобильная версия" @click="changeImage('mobile')">
                <MobileIcon />
            </button>
            <Link v-if="isMe" :href="`/me/work/${data.id}`" class="portfolio-item__button"
                :to="{ name: 'EditWork', params: { id: data.id } }" type="button">
            <PencilIcon />
            </Link>
        </div>
        <div class="portfolio-item__container" ref="itemContainer">
            <div class="portfolio-item__folder-back" :style="{ backgroundImage: folderBackgroundBack }">
            </div>
            <div class="portfolio-item__skills">
                <div class="portfolio-item__skills-container">
                    <ol class="portfolio-item__skills-list" v-html="currentShownSkills" ref="skillsList"></ol>
                </div>
                <div v-if="slicedSkillsPages.length > 1" class="portfolio-item__skills-pagination">
                    <button class="portfolio-item__skills-prev" type="button" aria-label="Листать назад" @click="skillsPageNumber--"
                        :disabled="isFirstSkillsPage">
                        <ChevronRightIcon />
                    </button>
                    <span>|</span>
                    <button class="portfolio-item__skills-next" type="button" @click="skillsPageNumber++"
                        :disabled="isLastSkillsPage" aria-label="Листать далее">
                        <ChevronRightIcon />
                    </button>
                </div>
            </div>
            <div class="portfolio-item__image" ref="imageContainer">
                <ImagePicture :path="imageUrl" ref="image" :alt="data.name" />
            </div>
            <div class="portfolio-item__folder-front" :style="{ backgroundImage: folderBackgroundFront }">
            </div>
        </div>
        <div class="portfolio-item__text">
            <a :href="data.url">
                <span class="portfolio-item__title">
                    {{ data.tag }} {{ data.name }}
                </span>
                <span class="portfolio-item__stack">
                    Стек:
                    {{ stackList }}
                </span>
            </a>
        </div>
    </li>
</template>

<script setup>
import { useGlobalStore } from '@/store/global.js'
import { onMounted, ref, computed, watch } from 'vue'
import { Link } from '@inertiajs/vue3'
import { gsap } from 'gsap'
import { getCoords } from '@/helpers/scripts.js'

import folderBackUrl from '/resources/images/portfolio-item/folder-back.png'
import folderFrontUrl from '/resources/images/portfolio-item/folder-front.png'
import folderBackDarkUrl from '/resources/images/portfolio-item/folder-dark-back.png'
import folderFrontDarkUrl from '/resources/images/portfolio-item/folder-dark-front.png'


const props = defineProps({
    data: {
        type: Object,
        required: true,
    }
})

const globalStore = useGlobalStore()
const theme = computed(() => globalStore.theme)
const isMe = computed(() => globalStore.isMe)

const el = ref(null)
const skillsList = ref(null)
const imageContainer = ref(null)
const image = ref(null)

const imageType = ref('')
const isShownSkills = ref(false)
const isTogglingLinks = ref(false)
const isChangingImage = ref(false)
const skillsPageNumber = ref(1)
const slicedSkillsPages = ref([])
const sliceSkillsTimeout = ref(null)

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
const currentShownSkills = computed(() => {
    if (!skillsList.value)
        return []

    gsap.set(skillsList.value, { opacity: 0 })
    gsap.to(skillsList.value, { opacity: 1, duration: .2 })
    if (slicedSkillsPages.value.length > 0)
        return slicedSkillsPages.value[skillsPageNumber.value - 1]?.join('')

    return 'Для данной работы пока не добавлены навыки'
})
const isFirstSkillsPage = computed(() => skillsPageNumber.value === 1)
const isLastSkillsPage = computed(() => skillsPageNumber.value === slicedSkillsPages.value.length)
const stackList = computed(() => {
    if (!props.data.stack)
        return ''

    return props.data.stack.map(o => o.name).join(', ')
})
const imageUrl = computed(() => {
    if (imageType.value === 'desktop' && props.data.image_desktop)
        return `${props.data.image_desktop}`
    if (imageType.value === 'mobile' && props.data.image_mobile)
        return `${props.data.image_mobile}`

    return null
})

watch(skillsPageNumber, (num) => {
    if (num < 1)
        skillsPageNumber.value = 1

    if (num > slicedSkillsPages.value.length)
        skillsPageNumber.value = slicedSkillsPages.value.length
})

onMounted(() => {
    if (props.data.image_desktop)
        changeImage('desktop')
    else if (props.data.image_mobile)
        changeImage('mobile')

    sliceSkillsPages()
    window.addEventListener('resize', () => {
        // таким образом метод будет вызван спустя некоторое время после того, как пользователь изменит размер экрана, иначе он будет вызываться очень много раз
        if (sliceSkillsTimeout.value)
            clearInterval(sliceSkillsTimeout.value)
        sliceSkillsTimeout.value = setTimeout(sliceSkillsPages, 500)
    })
})

function toggleLinks() {
    if (isTogglingLinks.value)
        return

    isTogglingLinks.value = true

    let translateCoef = imageContainer.value.offsetWidth
    // если при сдвиге вправо изображение будет выходить за границы документа, сдвинуть его влево
    const isGoingOutOfDocument = getCoords(imageContainer.value).right + translateCoef
        > document.documentElement.clientWidth - 30
    if (isGoingOutOfDocument)
        translateCoef = -1 * translateCoef

    gsap.to(imageContainer.value, {
        x: translateCoef,
        duration: .2,
        ease: 'ease',
        // учитывается, что isShownSkills еще не изменен
        scale: isShownSkills.value ? 1 : .8,
        marginRight: isShownSkills.value ? 0 : 45,
        onComplete: () => {
            // показать изображение/видео, спрятать ссылки
            if (isShownSkills.value)
                isShownSkills.value = false
            // показать ссылки, спрятать изображение/видео
            else
                isShownSkills.value = true

            gsap.to(imageContainer.value, { x: 0, ease: 'ease' })
            el.value.style.removeProperty('z-index')
            isTogglingLinks.value = false
        }
    })
}
async function changeImage(newImgType) {
    if (isChangingImage.value || imageType.value === newImgType)
        return

    isChangingImage.value = true

    image.value.img.addEventListener('load', onLoad)

    const imgContainer = imageContainer.value
    gsap.to(imgContainer, {
        scale: 0,
        duration: .2,
        onComplete: () => {
            switch (newImgType) {
                default:
                case 'desktop':
                    imageType.value = newImgType
                    break
                case 'mobile':
                    imageType.value = newImgType
                    break
            }
        }
    })

    function onLoad() {
        image.value.img.removeEventListener('load', onLoad)

        gsap.to(imgContainer, {
            scale: 1,
            onComplete: () => isChangingImage.value = false
        })
    }
}
function sliceSkillsPages() {
    if (!skillsList.value)
        return

    slicedSkillsPages.value = []
    gsap.set(skillsList.value, { opacity: 0 })
    const clone = skillsList.value.cloneNode(true)
    skillsList.value.after(clone)
    gsap.set(clone, { opacity: 0, visibility: 'hidden', position: 'absolute' })

    const items = []
    props.data.skills?.forEach((obj, i) => {
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
        slicedSkillsPages.value.push(page)
        items.splice(0, page.length)
        if (page.length < 1)
            break
    }

    clone.remove()

    gsap.to(skillsList.value, { opacity: 1 })
}
</script>