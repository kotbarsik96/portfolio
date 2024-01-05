<script setup>
import { router } from '@inertiajs/vue3'
import { reactive } from 'vue'
import Layout from '../Layout/Layout.vue'
import TextInput from '../Components/TextInput.vue'

defineProps({ errors: Object })

const form = reactive({
    name: '',
    email: '',
    password: '',
    password_confirmation: ''
})
</script>

<template>
    <Layout>
        <form class="hello-form" @submit.prevent="router.post('/register', form)">
            <div class="container">
                <TextInput class="text-input--full" name="name" id="name" placeholder="Имя" v-model="form.name">
                    <template v-slot:label>
                        Имя
                    </template>
                    <template v-slot:error v-if="errors.name">
                        {{ errors.name }}
                    </template>
                </TextInput>
                <TextInput class="text-input--full" name="email" id="email" placeholder="Email" v-model="form.email">
                    <template v-slot:label>
                        Email
                    </template>
                    <template v-slot:error v-if="errors.email">
                        {{ errors.email }}
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
                <TextInput class="text-input--full" name="password_confirmation" id="password_confirmation" type="password"
                    placeholder="Пароль еще раз" v-model="form.password_confirmation">
                    <template v-slot:label>
                        Пароль еще раз
                    </template>
                </TextInput>
                <button class="button" type="submit">Вперед</button>
            </div>
        </form>
    </Layout>
</template>

<style></style>