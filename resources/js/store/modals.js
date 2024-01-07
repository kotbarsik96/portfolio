import { defineStore } from 'pinia'
import { h } from 'vue'
import { generateRandom } from '../helpers/scripts.js'

import ConfirmModal from '../Components/Modals/ConfirmModal.vue'

export const useModalsStore = defineStore('modals', {
    state: () => {
        return {
            modalsList: [],
            mediaModal: null
        }
    },
    actions: {
        add(componentName, props = {}) {
            let componentInstance = ConfirmModal
            // switch (componentName) {
            //     case 'x':
            //         component = x
            // }

            const usedIds = this.modalsList.map(obj => obj.id)
            props.modalId = generateRandom(usedIds)
            const component = h(componentInstance, props)
            const obj = { component, modalId: props.modalId }
            this.modalsList.push(obj)
            return obj
        },
        addMedia(inst) {
            const el = inst.setupState.el
            const parent = el.parentNode
            this.mediaModal = {
                inst,
                parent,
                el
            }
        },
        removeMedia() {
            this.mediaModal?.parent.append(this.mediaModal.el)
            this.mediaModal = null
        },
        remove(id) {
            this.modalsList = this.modalsList.filter(obj => obj.modalId !== id)
        },
        removeFirst() {
            const first = this.modalsList[0]
            if (!first)
                return

            this.remove(first.modalId)
        }
    }
})