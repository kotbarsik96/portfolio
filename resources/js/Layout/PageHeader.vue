<template>
    <header class="header" :class="{ __scrolled: isScrolled }" ref="rootElem">
        <div class="header__container" ref="headerContainer">
            <nav class="header__nav">
                <button class="header__nav-button" :class="{ '__active': isNavMenuOpened }" @click="toggleNavMenu" aria-label="Меню">
                    <span class="header__nav-button-item"></span>
                    <span class="header__nav-button-item"></span>
                    <span class="header__nav-button-item"></span>
                </button>
                <ul v-if="isControlPage" class="header__nav-list">
                    <li class="header__nav-item">
                        <Link href="/me/work" class="header__nav-link">
                        Работа
                        </Link>
                    </li>
                    <li class="header__nav-item">
                        <Link href="/me/skill" :to="{ name: 'AddSkill' }" class="header__nav-link">
                        Навык
                        </Link>
                    </li>
                    <li class="header__nav-item" :class="{ '__shown': activeSublist === 'taxonomies' }">
                        <button class="header__nav-link" type="button" @click="toggleSublist('taxonomies')">
                            Таксономии
                        </button>
                        <ul class="header__nav-sublist">
                            <li class="header__nav-subitem" v-for="taxType in page.props.taxonomy_types" :key="taxType.id">
                                <Link :href="`/me/taxonomy/${taxType.type}`" class="link header__nav-link">
                                {{ taxType.title }}
                                </Link>
                            </li>
                        </ul>
                    </li>
                    <li class="header__nav-item">
                        <Link href="/" class="header__nav-link header__nav-link--me">
                        Назад
                        </Link>
                    </li>
                </ul>
                <ul v-else class="header__nav-list">
                    <li class="header__nav-item">
                        <AnchorLink href="#portfolio" class="header__nav-link"
                            :class="{ '__active': activeLink === 'portfolio' }" @click="isNavMenuOpened = false">
                            Портфолио
                        </AnchorLink>
                    </li>
                    <li class="header__nav-item">
                        <AnchorLink href="#contacts" class="header__nav-link"
                            :class="{ '__active': activeLink === 'contacts' }" @click="isNavMenuOpened = false">
                            Связь
                        </AnchorLink>
                    </li>
                    <li class="header__nav-item">
                        <AnchorLink href="#about" class="header__nav-link" :class="{ '__active': activeLink === 'about' }" @click="isNavMenuOpened = false">
                            О себе
                        </AnchorLink>
                    </li>
                    <li class="header__nav-item">
                        <AnchorLink href="#skills" class="header__nav-link"
                            :class="{ '__active': activeLink === 'skills' }" @click="isNavMenuOpened = false">
                            Мои навыки
                        </AnchorLink>
                    </li>
                    <li v-if="isMe && !isControlPage" class="header__nav-item">
                        <Link href="/me" :to="{ name: 'Me' }" class="header__nav-link header__nav-link--me">
                        кто я
                        </Link>
                    </li>
                </ul>
            </nav>
            <div class="header__theme-switcher">
                <Link v-if="isMe" class="header__theme-switcher-item icon-exit" href="/logout" method="post" as="button"
                    type="button">
                <ExitIcon></ExitIcon>
                </Link>
                <div v-if="isMe" class="header__theme-switcher-delimeter">
                    /
                </div>
                <button class="header__theme-switcher-item icon-sun" :class="theme === 'light' ? '__active' : ''"
                    @click="() => changeTheme('light')" aria-label="Светлая тема" type="button">
                    <SunIcon></SunIcon>
                </button>
                <div class="header__theme-switcher-delimeter">
                    /
                </div>
                <button class="header__theme-switcher-item icon-moon" :class="theme === 'dark' ? '__active' : ''"
                    @click="() => changeTheme('dark')" aria-label="Тёмная тема" type="button">
                    <MoonIcon></MoonIcon>
                </button>
            </div>
        </div>
    </header>
</template>

<script setup>
import { Link, usePage } from '@inertiajs/vue3'
import { ref, computed, nextTick } from 'vue'
import { qsAll, getCoords, windowScrollY } from '../helpers/scripts.js'
import { useGlobalStore } from '@/store/global.js'

const globalStore = useGlobalStore()
const theme = computed(() => globalStore.theme)
const isMe = computed(() => globalStore.isMe)

const page = usePage()
const isScrolled = ref(windowScrollY() > 0)
const isNavMenuOpened = ref(false)
const activeLink = ref('')
const activeSublist = ref('')

const isControlPage = computed(() => Boolean(page.url.match(/\/me\/|\/me$/)))

const changeTheme = (theme = 'light') => {
    globalStore.setTheme(theme)
}
const setActiveNavLink = () => {
    const sortCallback = (s1, s2) => {
        const s1Result = Math.abs(windowScrollY() - s1.coords.top)
        const s2Result = Math.abs(windowScrollY() - s2.coords.top)
        if (s1Result < s2Result)
            return -1
        if (s1Result > s2Result)
            return 1
        return 0
    }

    const sections = qsAll('.content > section')
        .map(section => {
            return { section, coords: getCoords(section) }
        })
    const closestToUserScroll = sections.sort(sortCallback)[0]
    if (!closestToUserScroll)
        return
    const id = closestToUserScroll.section.getAttribute('id')
    activeLink.value = id
}
const onScroll = () => {
    isScrolled.value = windowScrollY() > 50
    setActiveNavLink()
}
const toggleNavMenu = () => {
    isNavMenuOpened.value = !isNavMenuOpened.value
}
const toggleSublist = (name) => {
    if (activeSublist.value === name)
        activeSublist.value = ''
    else
        activeSublist.value = name
}

// oncreated
if (typeof window !== 'undefined') {
    window.addEventListener('scroll', onScroll)
    document.addEventListener('click', (event) => {
        if (event.target.closest('.header__nav-subitem') || !event.target.closest('.header__nav-item'))
            activeSublist.value = ''
    })
}
nextTick().then(onScroll)
</script>