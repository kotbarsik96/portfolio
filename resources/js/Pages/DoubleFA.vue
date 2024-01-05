<script setup>
import { router } from '@inertiajs/vue3'
import { reactive } from 'vue'
import Layout from '../Layout/Layout.vue'
import TextInput from '../Components/TextInput.vue'

const form = reactive({
    secret: '',
})
</script>

<template>
    <Layout>
        <form class="hello-form" @submit.prevent="router.post('/identifyyourself', form)">
            <div class="container">
                <TextInput class="text-input--full" name="input" id="input" placeholder="Не помню что" v-model="form.input">
                    <template v-slot:label>
                        Что-то нужно ввести
                    </template>
                </TextInput>
                <button class="button" type="submit">Вперед</button>
            </div>
        </form>
    </Layout>
</template>