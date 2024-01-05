<template>
    <div class="checkboxes-list" ref="el">
        <div v-for="(section, sectionName) in sectionsComputed" class="checkboxes-list__section">
            <div class="checkboxes-list__section-title">
                {{ section.sectionTitle }}
            </div>
            <div class="checkboxes-list__section-body">
                <div class="checkboxes-list__section-item" v-for="(obj, index) in section.values">
                    <CheckboxLabel class="checkboxes-list__section-label" :value="obj.value"
                        @change="(checkedData) => onCheckboxChange(checkedData, sectionName, index)" :name="sectionName"
                        :checked="sectionsData[sectionName][index].checked">
                        {{ obj.string }}
                    </CheckboxLabel>
                    <div v-if="section.comment || section.attachment" class="checkboxes-list__item-controls">
                        <button v-if="section.attachment" class="checkboxes-list__item-controls-button"
                            :class="{ '__active': sectionsData[sectionName][index].attachment }" type="button"
                            @click="makeAttachment(sectionName, index)">
                            <AttachmentIcon></AttachmentIcon>
                        </button>
                    </div>
                    <textarea v-if="section.comment && sectionsData[sectionName][index].checked"
                        class="checkboxes-list__item-comment" @input="adjustTextarea($event.target)"
                        v-model="sectionsData[sectionName][index].comment" type="text" ref="textarea"
                        placheolder="Комментарий"></textarea>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import CheckboxLabel from './CheckboxLabel.vue'
import { computed, reactive, ref, nextTick, watch, h } from 'vue'
import TextInput from '../Components/TextInput.vue'
import { mapStringToObject, adjustTextarea } from '../helpers/scripts.js'
import { useModalsStore } from '../store/modals.js'

const props = defineProps({
    /* sections[key] == {
        sectionTitle: 'Навыки',
        values: [
            'навык1', 
            { string: 'навык2', value: 'skill_2' }, 
            { string: 'навык3', value: 'skill_3', checked: true, comment: '...', attachment: '...' } 
                — нужно, когда пробрасывается дефолтное значение
        ],
        comment: false|true,
        attachment: false|true
    } */
    sections: {
        type: Object,
        required: true
    },
})
const emit = defineEmits(['change'])
defineExpose({ reset })

const el = ref(null)
const textarea = ref(null)

// то же самое, что props.sections, отличие в том, что все values преобразуются в объект вида { string: '..', value: '..' }
const sectionsComputed = computed(() => {
    const o = Object.assign({}, props.sections)
    for (let key in o)
        o[key].values = o[key].values.map(mapStringToObject)
    return o
})

const sectionsData = reactive(initSectionsData())

emitChange()
watch(sectionsData, emitChange)

async function emitChange() {
    const changedSectionsData = Object.assign({}, sectionsData)
    for (let key in changedSectionsData) {
        const arr = changedSectionsData[key]
        if (!Array.isArray(arr))
            continue

        changedSectionsData[key] = arr.filter(obj => obj.checked)
            .map(obj => {
                // если нельзя ввести ни комментарий, ни аттачмент, отдать только строку
                if (!props.sections[key].comment && !props.sections[key].attachment)
                    return obj.value

                // если можно ввести комментарий и/или аттачмент, отдать объект
                return {
                    value: obj.value,
                    comment: obj.comment,
                    attachment: obj.attachment
                }
            })
    }
    emit('change', changedSectionsData)

    await nextTick()
    if (Array.isArray(textarea.value))
        textarea.value.forEach(ta => adjustTextarea(ta))
}
function onCheckboxChange(data, sectionName, index) {
    const obj = sectionsData[sectionName]
    obj[index].checked = data.checked
}
function initSectionsData() {
    const obj = {}
    for (let sectionName in props.sections) {
        obj[sectionName] = props.sections[sectionName].values
    }
    return obj
}
function makeAttachment(sectionName, index) {
    const name = 'url-attachment'
    const currentValue = sectionsData[sectionName][index].attachment || ''
    const component = h(TextInput, {
        name,
        placeholder: 'http(s)://...',
        initialValue: currentValue
    })

    useModalsStore().add('ConfirmModal', {
        title: 'Прикрепить URL к навыку',
        children: [
            {
                component,
                name,
                hasvmodel: true
            }
        ],
        confirmData: {
            callback(ctx) {
                sectionsData[sectionName][index].attachment = ctx.setupState.vModels[name] || ''
            },
            title: 'Прикрепить'
        },
        declineData: {
            title: 'Отменить'
        }
    })

    el.value.querySelectorAll('button')
        .forEach(b => b.blur())
}
function reset() {
    for (let key in props.sections) {
        const values = props.sections[key].values
        if (Array.isArray(values)) {
            values.forEach(obj => {
                obj.checked = false
                if (obj.comment)
                    obj.comment = null
                if (obj.attachment)
                    obj.attachment = null
            })
        }
    }
}
</script>
