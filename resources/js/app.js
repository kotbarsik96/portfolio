import './bootstrap'
import '../styles/style.scss'

import { createSSRApp, h } from 'vue'
import { createInertiaApp } from '@inertiajs/vue3'
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers'
import { ZiggyVue } from '../../vendor/tightenco/ziggy/dist/vue.m'
import { createPinia } from 'pinia'
import globalComponents from './Components/Global/'
import iconComponents from './Icons/'
import axios from 'axios'

axios.defaults.withCredentials = true

const appName = import.meta.env.VITE_APP_NAME || 'Laravel'
export const pinia = createPinia()

createInertiaApp({
    resolve: (name) => resolvePageComponent(`./Pages/${name}.vue`, import.meta.glob('./Pages/**/*.vue')),
    setup({ el, App, props, plugin }) {
        const app = createSSRApp({ render: () => h(App, props) })
            .use(plugin)
            .use(ZiggyVue, Ziggy)
            .use(pinia)
        iconComponents.forEach(obj => app.component(obj.name, obj.component))
        globalComponents.forEach(obj => app.component(obj.name, obj.component))
        return app.mount(el)
    },
    progress: {
        color: '#4B5563',
    },
})
