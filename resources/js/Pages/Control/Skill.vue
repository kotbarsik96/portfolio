<script setup>
import { ref, reactive, computed } from 'vue'
import { Link } from '@inertiajs/vue3'
import Control from '../../Pages/Control.vue'
import TextInput from '../../Components/TextInput.vue'
import LoadImage from '../../Components/LoadMedia/LoadImage.vue'
import LoadVideo from '../../Components/LoadMedia/LoadVideo.vue'
import { watchEffect } from 'vue'
import { useSaveModelValues } from '../../helpers/save-model-values.js'

const props = defineProps({
    skill: Object,
    errors: Object,
    image: Object,
    video: Object,
})

const errorsList = computed(() => props.errors ? Object.values(props.errors) : [])

const title = computed(() => props.skill ? 'Редактирование навыка' : 'Добавление навыка')
const href = computed(() => props.skill ? `/me/skill/${props.skill.id}` : '/me/skill')
const skillId = computed(() => props.skill ? props.skill.id : 0)

const image = ref(props.image)
const video = ref(props.video)
const save = ref(null)

const form = reactive({
    id: skillId,
    name: props.skill ? props.skill.name : '',
    image_id: null,
    video_id: null
})

watchEffect(() => {
    form.image_id = image.value ? image.value.id : null
    form.video_id = video.value ? video.value.id : null
})

const loadImageId = computed(() => props.skill ? null : 'load-skill-image')
const loadVideoId = computed(() => props.skill ? null : 'load-skill-video')

const onEnterKeyup = () => {
    save.value.$el.click()
}

const clearSavedModelValues = () => {
    useSaveModelValues().clearSavedModelValues([loadImageId.value, loadVideoId.value])
}
const deleteAndClear = () => {
    form.name = ''
    image.value = null
    video.value = null
    clearSavedModelValues()
}
</script>

<template>
    <Control>
        <div class="container">
            <section>
                <h2 class="section-title">
                    {{ title }}
                </h2>
                <div class="add">
                    <div v-if="errorsList.length > 0" class="errors-list">
                        <div class="errors-list__item" v-for="err in errorsList">
                            {{ err }}
                        </div>
                    </div>
                    <div class="add__inputs-section">
                        <TextInput v-model="form.name" name="name" id="name" placeholder="Название"
                            @enterKeyup="onEnterKeyup">
                            <template v-slot:label>
                                Название
                            </template>
                        </TextInput>
                    </div>
                    <div class="add__load-media">
                        <div class="add__load-media-item">
                            <LoadImage v-model="image" :id="loadImageId"></LoadImage>
                        </div>
                        <div class="add__load-media-item">
                            <LoadVideo v-model="video" :id="loadVideoId"></LoadVideo>
                        </div>
                    </div>
                    <div class="add__buttons">
                        <Link class="button button--color_2" as="button" :href="href" :data="form" method="post"
                            preserve-scroll type="button" @click="clearSavedModelValues" ref="save">
                        {{ props.skill ? 'Сохранить' : 'Добавить' }}
                        </Link>
                        <Link v-if="props.skill" class="button button--cancel" as="button"
                            :href="`/me/skill/${props.skill.id}`" method="delete" type="button" @click="deleteAndClear"
                            ref="save" preserve-scroll>
                        Удалить
                        </Link>
                    </div>
                </div>
            </section>
        </div>
    </Control>
</template>