import { reactive } from "vue"

export function useMediaQueries() {
    const data = reactive({})
    const matches = reactive({})

    function register(mediaValue, type = "max-width") {
        const media = window.matchMedia(`(${type}: ${mediaValue}px)`)
        data[mediaValue] = { media, callback }
        media.addEventListener("change", callback)
        callback()

        function callback() {
            matches[mediaValue] = media.matches
        }
    }
    function unregisterAll() {
        Object.values(data)
            .forEach(obj => obj.media.removeEventListener("change", obj.callback))
    }

    return {
        data,
        matches,
        register,
        unregisterAll
    }
}