<script setup>
import { provide } from 'vue'
import Layout from '../Layout/Layout.vue'
import MyPortfolio from '../Sections/MyPortfolio.vue'
import MyContacts from '../Sections/MyContacts.vue'
import AboutMe from '../Sections/AboutMe.vue'
import MySkills from '../Sections/MySkills.vue'

const props = defineProps({
    worksCount: Number,
    skillsCount: Number,
    stack: Array,
    types: Array,
    works: Array,
    skills: Array,
})

provide('worksCount', props.worksCount)
provide('skillsCount', props.skillsCount)
provide('stack', props.stack.map(o => o.name))
provide('types', props.types.map(o => o.name))
</script>

<template>
    <Layout>
        <div class="content">
            <MyPortfolio :works="props.works" :skills="skills" />
            <MyContacts />
            <AboutMe />
            <MySkills :skills="props.skills" />
        </div>
    </Layout>
</template>