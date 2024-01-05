<template>
    <section id="skills">
        <div class="container">
            <h3 class="section-title">
                <span>
                    Навыки: что я умею
                </span>
            </h3>
            <div class="skills">
                <div class="skills__search">
                    <TextInput class="text-input--full" v-model="search" id="skill-search" name="skill-search"
                        placeholder="Поиск">
                        <template v-slot:before>
                            <SearchIcon></SearchIcon>
                        </template>
                    </TextInput>
                </div>
                <div class="skills__list-container">
                    <TransitionGroup v-if="shownSkills.length > 0" tag="ul" class="skills__list" name="skill-item">
                        <SkillItem v-for="item in shownSkills" :key="item.id" :data="item"></SkillItem>
                    </TransitionGroup>
                    <div v-else class="empty">
                        <img :src="emptyIcon" alt="" class="empty__icon">
                        <div class="empty__text">
                            <p>
                                К сожалению, ничего не найдено
                            </p>
                            <p>
                                Попробуйте поиск по другим словам
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div ref="intersection"></div>
    </section>
</template>

<script setup>
import TextInput from '../Components/TextInput.vue'
import SkillItem from '../Components/Items/SkillItem.vue'
import emptyIcon from '../../images/icons/cricket.svg'
import axios from 'axios'
import { ref, onBeforeUnmount, onMounted, computed, watch } from 'vue'

const props = defineProps({
    skills: Array
})

const intersection = ref(null)

const search = ref('')
const intersectionObs = new IntersectionObserver(onIntersect, {
    rootMargin: '0px 0px 80px 0px'
})

const loadedSkills = ref([...props.skills])
const searchedSkills = ref([])
const shownSkills = computed(() => {
    return search.value.trim()
        ? searchedSkills.value
        : loadedSkills.value
})

watch(search, doSearch)

onMounted(() => {
    intersectionObs.observe(intersection.value)
})
onBeforeUnmount(() => {
    intersectionObs.unobserve(intersection.value)
})

function onIntersect(entries) {
    entries.forEach(obj => {
        if (obj.isIntersecting) {
            loadSkills()
        }
    })
}
async function loadSkills() {
    const params = {
        limit: 2,
        offset: loadedSkills.value.length
    }
    const res = await axios.get('/skills', { params })
    if (Array.isArray(res.data.list))
        loadedSkills.value.push(...res.data.list)
}
async function doSearch() {
    const params = { limit: 4, search: search.value }
    const res = await axios.get('/skills', { params })
    if (Array.isArray(res.data.list)) {
        searchedSkills.value = res.data.list
    }
}
</script>