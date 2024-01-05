<script setup>
import { ref, reactive, computed, watch } from 'vue'
import { Link } from '@inertiajs/vue3'
import Control from '../../Pages/Control.vue'
import TextInput from '../../Components/TextInput.vue'
import LoadImage from '../../Components/LoadMedia/LoadImage.vue'
import SelectItem from '../../Components/SelectItem.vue'
import { useSaveModelValues } from '../../helpers/save-model-values.js'
import CheckboxesList from '../../Components/CheckboxesList.vue'

const props = defineProps({
    work: Object,
    image_desktop: Object,
    image_mobile: Object,
    errors: Object,
    tags: Array,
    types: Array,
    stack: Array,
    skills: Array,
    work_taxonomies: Object,
    work_skills: Array,
})

const errorsList = computed(() => props.errors ? Object.values(props.errors) : [])

watch(errorsList, () => {
    if (errorsList.value.length > 0 && typeof window !== 'undefined') {
        window.scrollTo({ top: 0, behavior: 'smooth' })
    }
})

const imageDesktop = ref(props.image_desktop)
const imageMobile = ref(props.image_mobile)

// id загруженных изображений
const imageDesktopId = computed(() => imageDesktop.value ? imageDesktop.value.id : null)
const imageMobileId = computed(() => imageMobile.value ? imageMobile.value.id : null)
// атрибуты id="" для компонента
const imageDesktopIdAttr = computed(() => props.work ? null : 'work-load-image_desktop')
const imageMobileIdAttr = computed(() => props.work ? null : 'work-load-image_mobile')

const checkboxesListRef = ref(null)

const href = computed(() => props.work ? `/me/work/${props.work.id}` : '/me/work')
const tagsForSelect = computed(() => props.tags.map(obj => obj.name))

const isInitialChecked = (taxonomyName, obj) => {
    return props.work_taxonomies
        ? props.work_taxonomies[taxonomyName].some((o) => o.name === obj.name)
        : false
}
const checkboxesListSections = reactive({
    type: {
        sectionTitle: 'Типы',
        values: props.types.map(obj => {
            return {
                value: obj.name,
                string: obj.name,
                checked: isInitialChecked('types', obj)
            }
        })
    },
    stack: {
        sectionTitle: 'Стек',
        values: props.stack.map(obj => {
            return {
                value: obj.name,
                string: obj.name,
                checked: isInitialChecked('stack', obj)
            }
        })
    },
    skills: {
        sectionTitle: 'Навыки',
        values: props.skills.map(obj => {
            const fromDb = props.work_skills
                ? props.work_skills.find(o => o.name === obj.name) || false
                : false
            return {
                string: obj.name,
                value: obj.name,
                checked: Boolean(fromDb),
                comment: fromDb ? fromDb.comment : '',
                attachment: fromDb ? fromDb.url : ''
            }
        }),
        comment: true,
        attachment: true
    }
})

const form = reactive({
    name: props.work ? props.work.name : '',
    url: props.work ? props.work.url : '',
    pages_count: props.work ? props.work.pages_count : '',
    image_desktop_id: imageDesktopId,
    image_mobile_id: imageMobileId,
    tag: props.work_taxonomies && props.work_taxonomies.tag
        ? props.work_taxonomies.tag.name : '',
    taxonomies: {}
})

const deleteAndClear = () => {
    form.name = ''
    form.url = ''
    form.pages_count = ''
    if (checkboxesListRef.value)
        checkboxesListRef.value.reset()
    imageDesktop.value = null
    imageMobile.value = null
    clearSavedModelValues()
}
const clearSavedModelValues = () => {
    useSaveModelValues().clearSavedModelValues([imageDesktopIdAttr.value, imageMobileIdAttr.value])
}
</script>

<template>
    <Control>
        <div class="container">
            <section class="add-work">
                <h2 class="section-title">
                    {{ props.work ? 'Редактирование' : 'Добавление' }}
                    работы
                </h2>
                <div class="add">
                    <div v-if="errorsList.length > 0" class="errors-list">
                        <div class="errors-list__item" v-for="err in errorsList">
                            {{ err }}
                        </div>
                    </div>
                    <div class="add__inputs-section">
                        <TextInput name="name" id="name" placeholder="Название" v-model="form.name">
                            <template v-slot:label>
                                Название
                            </template>
                        </TextInput>
                    </div>
                    <div class="add__inputs-section">
                        <TextInput name="url" id="url" placeholder="URL" v-model="form.url">
                            <template v-slot:label>
                                URL
                            </template>
                        </TextInput>
                    </div>
                    <div class="add__inputs-section">
                        <TextInput name="pages_count" id="pages_count" placeholder="Количество страниц" numberonly
                            v-model="form.pages_count">
                            <template v-slot:label>
                                Количество страниц
                            </template>
                        </TextInput>
                    </div>
                    <div class="add__inputs-section">
                        <SelectItem name="tag" :values="tagsForSelect" v-model="form.tag">
                            <template v-slot:label>
                                Тег
                            </template>
                        </SelectItem>
                    </div>
                    <div class="add__inputs-section">
                        <CheckboxesList :sections="checkboxesListSections" @change="(obj) => form.taxonomies = obj"
                            ref="checkboxesListRef"></CheckboxesList>
                    </div>
                    <div class="add__load-media">
                        <div class="add__load-media-item">
                            <LoadImage v-model="imageDesktop" title="Десктоп версия" :id="imageDesktopIdAttr"></LoadImage>
                        </div>
                        <div class="add__load-media-item add__load-media-item--mobile">
                            <LoadImage v-model="imageMobile" title="Мобильная версия" :id="imageMobileIdAttr"></LoadImage>
                        </div>
                    </div>
                    <div class="add__buttons">
                        <Link class="button button--color_2" as="button" :href="href" :data="form" method="post"
                            preserve-scroll type="button" @click="clearSavedModelValues" ref="save">
                        {{ props.work ? 'Сохранить' : 'Добавить' }}
                        </Link>
                        <Link v-if="props.work" class="button button--cancel" as="button"
                            :href="`/me/work/${props.work.id}`" method="delete" type="button" @click="deleteAndClear"
                            ref="save" preserve-scroll>
                        Удалить
                        </Link>
                    </div>
                </div>
            </section>
        </div>
    </Control>
</template>