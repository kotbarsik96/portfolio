import { defineStore } from 'pinia'
import { h } from 'vue'
import { generateRandom } from '../helpers/scripts.js'
import Popup from '../Components/Popups/Popup.vue'


export const usePopupsStore = defineStore('popups', {
    state: () => {
        return {
            popupsList: []
        }
    },
    actions: {
        add(props) {
            const usedIds = this.popupsList.map(obj => obj.id)
            props.id = generateRandom(usedIds)
            this.popupsList.push({
                component: h(Popup, props),
                id: props.id
            })
        },
        remove(id) {
            this.popupsList = this.popupsList.filter(o => o.id !== id)
        },
        removeFirst() {
            if (this.popupsList.length < 1)
                return

            this.remove(this.popupsList[0].id)
        }
    }
})