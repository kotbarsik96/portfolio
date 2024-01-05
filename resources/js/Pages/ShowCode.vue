<script setup>
import { ref } from 'vue'
import Layout from '../Layout/Layout.vue'

const props = defineProps({
    code: [String, Object],
})

console.log(props.code);
</script>

<template>
    <Layout>
        <div class="container">
            <div class="qr-code" v-html="code"></div>
        </div>
    </Layout>
</template>

<style></style>