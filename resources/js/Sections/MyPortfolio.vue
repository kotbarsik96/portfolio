<template>
    <section id="portfolio">
        <div class="container">
            <h1 class="section-title">
                Портфолио: мои работы
            </h1>
            <div class="portfolio">
                <div class="portfolio__list-container">
                    <Transition name="fade-in" mode="out-in">
                        <TransitionGroup v-if="shownWorksList.length > 0" tag="ul" class="portfolio__list"
                            name="portfolio-item">
                            <PortfolioItem v-for="work in shownWorksList" :key="work.id" :data="work" />
                        </TransitionGroup>
                        <div v-else class="empty">
                            <img :src="emptyIcon" alt="" class="empty__icon">
                            <div class="empty__text">
                                <p>
                                    К сожалению, ничего не найдено
                                </p>
                                <p>
                                    Возможно, стоит выбрать другие фильтры
                                </p>
                            </div>
                        </div>
                    </Transition>
                    <Transition name="fade-in">
                        <button v-if="showMoreButton" class="button list-more" type="button"
                            @click="loadWorks({ byLoadMoreButton: true })">
                            Показать еще
                        </button>
                    </Transition>
                </div>
                <Filters class="portfolio__filter" :sections="filterSections" v-model="filters" />
            </div>
        </div>
    </section>
</template>

<script setup>
import { ref, inject, computed, watch } from 'vue'
import PortfolioItem from '@/Components/Items/PortfolioItem.vue'
import Filters from '@/Components/Filters.vue'
import emptyIcon from '../../images/icons/cricket.svg'
import axios from 'axios'

const props = defineProps({
    works: Array,
    skills: Array
})

const types = inject('types')
const stack = inject('stack')
const worksCount = inject('worksCount')

const filters = ref({})
const loadedWorks = ref([...props.works])
const filteredWorks = ref([])
const filteredWorksCount = ref(0)
const isWorksLoading = ref(false)

const filterSections = computed(() => {
    return [
        {
            name: 'types',
            title: 'Типы',
            list: types.map(str => {
                return { title: str, value: str }
            })
        },
        {
            name: 'stack',
            title: 'Стек',
            list: stack.map(str => {
                return { title: str, value: str }
            })
        },
        {
            name: 'skills',
            title: 'Навыки',
            list: props.skills.map(obj => {
                return { title: obj.name, value: obj.name }
            })
        }
    ]
})
const hasCheckedFilters = computed(() => {
    return Object.values(filters.value).some(arr => arr.length > 0)
})
const showMoreButton = computed(() => {
    if (hasCheckedFilters.value)
        return filteredWorks.value.length < filteredWorksCount.value

    return loadedWorks.value.length < worksCount
})
const shownWorksList = computed(() => {
    if (hasCheckedFilters.value)
        return filteredWorks.value

    return loadedWorks.value
})

watch(filters, loadWorks)

async function loadWorks(options = {}) {
    isWorksLoading.value = true

    if (!options.byLoadMoreButton && !hasCheckedFilters.value)
        filteredWorks.value = []

    let offset = loadedWorks.value.length
    if (hasCheckedFilters.value && options.byLoadMoreButton)
        offset = filteredWorks.value.length
    else if (!options.byLoadMoreButton)
        offset = 0

    try {
        const params = {
            limit: 4,
            offset,
            types: filters.value.types,
            stack: filters.value.stack,
            skills: filters.value.skills
        }

        const res = await axios.get('/works', { params })

        if (hasCheckedFilters.value)
            filteredWorksCount.value = res.data.count

        res.data.list.forEach(obj => {
            if (!loadedWorks.value.find(o => o.id === obj.id) && options.byLoadMoreButton)
                loadedWorks.value.push(obj)
        })

        if (!options.byLoadMoreButton && hasCheckedFilters.value)
            filteredWorks.value = res.data.list
    } catch (err) {
        console.error(err)
    }

    isWorksLoading.value = false
}
</script>

<style>
.fade-in-enter-active,
.fade-in-leave-active {
    transition: all .2s
}

.fade-in-enter-from,
.fade-in-leave-to {
    opacity: 0
}

.fade-in-enter-to,
.fade-in-leave-from {
    opacity: 1
}
</style>