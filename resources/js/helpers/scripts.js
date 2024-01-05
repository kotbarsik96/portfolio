import { usePopupsStore } from '../store/popups.js'

export function onTransitionEnd(el, callback = function () { }) {
    return new Promise(resolve => {
        const elTransitionDuration = parseFloat(getComputedStyle(el).transitionDuration.replace(/[^.0-9]/g, ""))
        if (!elTransitionDuration)
            resolve()

        setTimeout(onTransEnd, elTransitionDuration * 1000)
        function onTransEnd() {
            el.removeEventListener("transitionend", onTransEnd)
            callback()
            resolve()
        }
    })
}

export function delay(timeout = 0) {
    return new Promise(resolve => {
        setTimeout(resolve, timeout)
    })
}

export function createElement(tagName, className = "", insertingHTML = "", attributes = {}) {
    if (typeof document === 'undefined')
        return {}

    let element = document.createElement(tagName)
    if (className) element.className = className
    if (insertingHTML) element.insertAdjacentHTML("afterbegin", insertingHTML)
    if (attributes) {
        for (let key in attributes) {
            const value = attributes[key]
            element.setAttribute(key, value)
        }
    }
    return element
}

export function doInFade(element, callback = function () { }) {
    return new Promise(async resolve => {
        element.style.transition = "all .2s"
        element.style.opacity = "0"
        await onTransitionEnd(element)

        try {
            callback()
        } catch (err) {
            resolve()
        }

        element.style.opacity = "1"
        await onTransitionEnd(element)
        element.style.removeProperty("transition")

        resolve()
    })
}

export function getHeight(el, opts = {}) {
    if (typeof document === 'undefined')
        return {}

    let clone = el.cloneNode(true)
    clone.style.cssText = `
        width: ${opts.width || el.offsetWidth}px 
        z-index: 100 
        position: absolute 
        top: 0 
        left: 0
        z-index: -999
    `
    document.body.append(clone)
    const height = clone.offsetHeight
    clone.remove()
    clone = null

    return height
}

export function getCoords(el) {
    if (typeof window === 'undefined')
        return { top: 0, left: 0, right: 0, bottom: 0 }

    const box = el.getBoundingClientRect()
    return {
        top: box.top + window.pageYOffset,
        left: box.left + window.pageXOffset,
        right: box.right + window.pageXOffset,
        bottom: box.bottom + window.pageYOffset
    }
}

export function qsAll(selector, relative) {
    if (!relative) {
        if (typeof document === 'undefined')
            return []

        relative = document
    }

    return Array.from(relative.querySelectorAll(selector))
}

export function formatSeconds(secondsValue, format = "ss:mm") {
    secondsValue = parseInt(secondsValue)
    if (!secondsValue && secondsValue !== 0)
        return

    let seconds, minutes
    switch (format) {
        case "ss:mm":
        default:
            minutes = parseInt(secondsValue / 60)
            seconds = secondsValue - minutes * 60
            return `${startZero(minutes)}:${startZero(seconds)}`
    }
}

export function startZero(num, length = 2) {
    if (parseInt(num) === NaN)
        return num

    let newNum = num
    const numLength = num.toString().length
    if (numLength < length) {
        const diff = length - numLength
        let zeros = "0"
        while (zeros.length < diff) {
            zeros += "0"
        }

        newNum = `${zeros}${num}`
    }
    return newNum
}

export function getTextContent(el) {
    return el.textContent.trim().replace(/\s{2,}/g, "")
}

export function getDataFromForms(form) {
    const data = {}
    qsAll("input[name]", form).forEach(input => {
        data[input.name] = input.value
    })
    return data
}

export function adjustInputWidth(input) {
    input.style.oveflowY = 'scroll'
    input.style.width = 0
    input.style.width = `${input.scrollWidth + 10}px`
}

export function windowScrollY() {
    if (typeof window === 'undefined')
        return 0

    return window.scrollY
}

export function generateRandom(used = []) {
    used = used.filter(i => i).map(i => i.toString())
    const firstPart = Math.floor(Math.random() * 100)
    const secondPart = Math.floor(Math.random() * 100)

    let rand = `${firstPart}${secondPart}`;
    while (used.includes(rand))
        rand = generateRandom(used)

    return parseInt(rand)
}

export function getImagePath(pathOrObject, params = {}) {
    const isWebp = params.isWebp || false

    let path = pathOrObject
    if (typeof pathOrObject === 'object') {
        path = pathOrObject.image_path || pathOrObject.path
    }
    if (!path)
        return '#'

    if (isWebp)
        return path.startsWith('/') || hasProtocol() ? `${path}.webp` : `/${path}.webp`

    return path.startsWith('/') || hasProtocol() ? path : `/${path}`

    function hasProtocol(){
        return path.startsWith('http')
    }
}

export function checkMediaRegexp(string) {
    if (!string.match(/\(min-width: \d+px\)|\(max-width: \d+px\)/))
        return false
    return true
}

export function checkWebpSupport() {
    let elem = document.createElement('canvas')

    if (!!(elem.getContext && elem.getContext('2d'))) {
        return elem.toDataURL('image/webp').indexOf('data:image/webp') == 0
    }
    else
        return false
}

export function handleAjaxError(err) {
    let message = ``
    if (err.response && err.response.data && err.response.data.errors) {
        Object.values(err.response.data.errors)
            .forEach(e => message += `<p>${e}</p>`)
    } else if (Array.isArray(err.errors)) {
        err.errors.forEach(e => message += `<p>${e}</p>`)
    }

    usePopupsStore().add({ message })
}

export function mapStringToObject(objOrString) {
    if (!objOrString)
        return null

    if (typeof objOrString === 'string')
        return { string: objOrString, value: objOrString }

    if (typeof objOrString === 'object') {
        if (objOrString.value && objOrString.string)
            return objOrString
        else if (objOrString.value && !objOrString.string) {
            objOrString.string = objOrString.value
            return objOrString
        }
        else if (objOrString.string && !objOrString.value) {
            objOrString.value = objOrString.string
            return objOrString
        }
    }

    return null
}

export function adjustTextarea(textarea) {
    textarea.style.height = '1px'
    textarea.style.height = `${textarea.scrollHeight}px`
}