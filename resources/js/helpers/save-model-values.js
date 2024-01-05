import Cookies from 'js-cookie'
import { watchEffect } from 'vue'

export function useSaveModelValues() {
    return {
        key: 'saved_model_values',
        getObject() {
            const strJson = Cookies.get(this.key)
            if (strJson)
                return JSON.parse(strJson)

            return {}
        },
        saveObject(obj) {
            Cookies.set(this.key, JSON.stringify(obj), { expires: 1 })
        },
        addToObject(id, json) {
            const obj = this.getObject()
            obj[id] = JSON.stringify(json)
            this.saveObject(obj)
        },
        removeFromObject(id) {
            const obj = this.getObject()
            if (obj[id])
                delete obj[id]
            this.saveObject(obj)
        },
        /* позволяет удалить запись, когда, например, модель уже была сохранена */
        clearSavedModelValues(idsList) {
            idsList.forEach(id => this.removeFromObject(id))
        },
        /* обязательно: 
            props = defineProps({ id: String, modelValue: Object })
            emit = defineEmit(['update:modelValue'])
            далее прописать useSaveModelValues().saveModelValues(props, emit)
        */
        saveModelValues(props, emit) {
            if (props.id) {
                const obj = this.getObject()
                const savedModelValue = obj[props.id]
                if (savedModelValue)
                    emit('update:modelValue', JSON.parse(savedModelValue))

                watchEffect(() => {
                    if (!props.modelValue) {
                        this.removeFromObject(props.id)
                        return
                    }

                    if (props.id)
                        this.addToObject(props.id, props.modelValue)
                })
            }
        }
    }
}