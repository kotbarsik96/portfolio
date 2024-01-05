import { computed } from 'vue'
import { defineStore } from 'pinia'
import { usePage } from '@inertiajs/vue3'
import { checkWebpSupport } from '@/helpers/scripts.js'

const page = usePage()
const supportsWebp = checkWebpSupport()

const isMe = computed(() => page.props.auth.user)

const themeKey = 'kb96_portfolio_theme'

export const useGlobalStore = defineStore('global', {
    state: () => {
        return {
            theme: 'light',
            isMe,
            supportsWebp
        }
    },
    actions: {
        init() {
            const self = this
            initTheme()

            function initTheme() {
                if (typeof window === 'undefined')
                    return

                const lsTheme = localStorage.getItem(themeKey)
                if (!lsTheme) {
                    const isPreferredDarkTheme = window.matchMedia('(prefers-color-scheme: dark)')
                        .matches

                    if (isPreferredDarkTheme)
                        self.theme = 'dark'
                    else self.theme = 'light'

                } else {
                    self.setTheme(lsTheme)
                }
            }
        },
        setTheme(changedTheme) {
            switch (changedTheme) {
                case 'dark':
                    this.theme = 'dark'
                    break
                default:
                    this.theme = 'light'
                    break
            }

            localStorage.setItem(themeKey, this.theme)
        }
    }
})