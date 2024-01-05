<script setup>
import { ref, reactive, onMounted, watchEffect, computed } from 'vue'
import { Link } from '@inertiajs/vue3'
import { adjustInputWidth } from '../../helpers/scripts.js'
import Control from '../../Pages/Control.vue'
import TextInput from '../../Components/TextInput.vue'
import { gsap } from 'gsap'
import { nextTick } from 'vue'
import { useModalsStore } from '@/store/modals'

const props = defineProps({
    list: Array,
    type: String,
    title: String,
    errors: Object
})

const searchValue = ref('')
const searchRegexp = computed(() => new RegExp(searchValue.value, 'i'))
const listComputed = computed(() => props.list.filter(item => {
    return item.name.match(searchRegexp.value)
}))

const addButton = ref(null)
const listValueInput = ref(null)

const form = reactive({
    type: props.type,
    name: ''
})

const values = reactive({})

const fillValues = () => {
    props.list.forEach(item => values[item.id] = item.name)
}
const adjustInputs = () => {
    if (!listValueInput || (listValueInput && !listValueInput.value))
        return

    listValueInput.value.forEach(input => adjustInputWidth(input))
}
const isUnsaved = (id) => {
    const savedVersion = props.list.find(o => o.id === id)
    const unsavedVersion = values[id]

    return savedVersion.name !== unsavedVersion
}
const setInitialValue = async (id) => {
    const obj = props.list.find(o => o.id === id)
    values[id] = obj.name
    await nextTick()
    adjustInputs()
}
const onDeleteClick = (event, item) => {
    const link = event.currentTarget.querySelector('.hidden-link')

    if (!link)
        return

    useModalsStore().add('ConfirmModal', {
        title: `Удалить ${props.title} ${item.name}?`,
        confirmData: {
            callback: () => {
                link.click()
            },
            title: 'Удалить'
        },
        declineData: {
            title: 'Не удалять'
        }
    })
}
const saveByEnter = (event) => {
    const li = event.target.closest('li')
    const editButton = li.querySelector('.edit-taxonomy__list-edit')
    if (editButton)
        editButton.click()
}

const onBeforeEnter = (el) => {
    gsap.set(el, { maxHeight: 0 })
}
const onEnter = (el, done) => {
    gsap.to(el, {
        maxHeight: '3em',
        duration: .7,
        opacity: 1,
        onComplete: done
    })
}
const onLeave = (el, done) => {
    gsap.to(el, {
        maxHeight: '0em',
        duration: .7,
        margin: 0,
        padding: 0,
        opacity: 0,
        onComplete: done
    })
}

fillValues()
watchEffect(() => {
    fillValues()
    adjustInputs()
})

onMounted(async () => {
    adjustInputs()
})
</script>

<template>
    <Control>
        <div class="container">
            <section>
                <h2 class="section-title">
                    {{ title }}
                </h2>
                <div class="add edit-taxonomy">
                    <ul class="errors-list" v-if="errors && Object.values(errors).length > 0">
                        <li class="errors-list__item" v-for="err in errors">
                            {{ err }}
                        </li>
                    </ul>
                    <div class="edit-taxonomy__search-container">
                        <TextInput class="text-input--full" v-model="searchValue" id="search" name="search"
                            placeholder="Поиск">
                            <template v-slot:before>
                                <SearchIcon></SearchIcon>
                            </template>
                        </TextInput>
                    </div>
                    <div class="edit-taxonomy__new-input">
                        <TextInput class="text-input--full" v-model="form.name" id="new_taxonomy" name="new_taxonomy"
                            :placeholder="`Добавить ${title.toLowerCase()}`" @enterKeyup="addButton.$el.click()">
                        </TextInput>
                        <Link href="/me/taxonomy" method="post" :data="form" as="button" class="button" type="button"
                            ref="addButton" preserve-scroll @click="form.name = ''">
                        Добавить тип
                        </Link>
                    </div>
                    <ul class="edit-taxonomy__list">
                        <TransitionGroup :css="false" @before-enter="onBeforeEnter" @enter="onEnter" @leave="onLeave">
                            <li class="edit-taxonomy__list-item" v-for="item in listComputed" :key="item.id">
                                <div class="edit-taxonomy__list-value">
                                    <input v-model="values[item.id]" @input="event => adjustInputWidth(event.target)"
                                        ref="listValueInput" @keyup.enter="saveByEnter">
                                </div>
                                <button class="edit-taxonomy__button edit-taxonomy__list-remove" type="button"
                                    @click="onDeleteClick($event, item)">
                                    <CircleMinusIcon></CircleMinusIcon>
                                    <Link class="hidden-link" preserve-scroll :href="`/me/taxonomy/${item.id}`"
                                        method="delete" as="button" @click.stop>
                                    </Link>
                                </button>
                                <Link class="edit-taxonomy__button edit-taxonomy__list-edit" v-if="isUnsaved(item.id)"
                                    :href="`/me/taxonomy/${item.id}`" method="post" :data="{ name: values[item.id] }"
                                    as="button" type="button" preserve-scroll @click.stop>
                                <SaveIcon></SaveIcon>
                                </Link>
                                <button class="edit-taxonomy__button edit-taxonomy__list-back" v-if="isUnsaved(item.id)"
                                    @click="setInitialValue(item.id)" type="button">
                                    <TurnBackIcon></TurnBackIcon>
                                </button>
                            </li>
                        </TransitionGroup>
                    </ul>
                </div>
            </section>
        </div>
    </Control>
</template>