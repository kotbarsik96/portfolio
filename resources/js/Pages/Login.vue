<script setup>
import { router } from '@inertiajs/vue3'
import { reactive } from 'vue'
import Layout from '../Layout/Layout.vue'
import TextInput from '../Components/TextInput.vue'

defineProps({ errors: Object })

const form = reactive({
    name: '',
    password: '',
})
</script>

<template>
    <Layout>
        <form class="hello-form" @submit.prevent="router.post('/login', form)">
            <div class="container">
                <TextInput class="text-input--full" name="name" id="name" placeholder="Имя" v-model="form.name">
                    <template v-slot:label>
                        Имя
                    </template>
                    <template v-slot:error v-if="errors.name">
                        {{ errors.name }}
                    </template>
                </TextInput>
                <TextInput class="text-input--full" name="password" id="password" type="password" placeholder="Пароль"
                    v-model="form.password">
                    <template v-slot:label>
                        Пароль
                    </template>
                    <template v-slot:error v-if="errors.password">
                        {{ errors.password }}
                    </template>
                </TextInput>
                <button class="button" type="submit">Вперед</button>
            </div>
        </form>
    </Layout>
</template>