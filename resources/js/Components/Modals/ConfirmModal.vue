<script setup>
import { getCurrentInstance, reactive, ref, onMounted } from 'vue'
import useModalHelpers from './'

const props = defineProps({
    /* будет сгенерирован автоматически */
    modalId: Number,
    title: String,
    buttons: Array,
    /* возможные варианты children[i]:
        1. 'div';
        2. { hasvmodel: true, component: h(TextInput, { name: 'text-input', ... }), name: 'modelname' };
        3. { component: h(SomeComponent, { ... }) }
    */
    children: Array,
    message: String,
    confirmData: Object,
    declineData: Object
})

const ctx = getCurrentInstance()

const el = ref(null)

const modalHelpers = useModalHelpers(ctx)

const vModels = reactive({})

const removeSelf = modalHelpers.removeSelf
const onButtonClick = (data = {}) => {
    const callback = data.callback

    if (typeof callback === 'function')
        callback(ctx)

    if (!data.noRemoveSelf)
        removeSelf()
}
// срабатывает только при фокусировке на input
const onEnterKeyup = () => {
    onButtonClick(props.confirmData)
}
const onEscKeyup = () => {
    onButtonClick(props.declineData)
}

onMounted(() => {
    el.value.focus()
})
</script>

<template>
    <div class="modal-window" @keyup.enter="onEnterKeyup" @keyup.esc="onEscKeyup" tabindex="1" ref="el">
        <div class="modal-window__window">
            <button class="modal-window__close" type="button" @click="removeSelf">
                <CancelIcon></CancelIcon>
            </button>
            <div v-if="title" class="modal-window__title">
                {{ title }}
            </div>
            <div class="modal-window__body">
                <p v-if="message" v-html="message"></p>
                <template v-for="el in children">
                    <component v-if="(typeof el === 'string')" :is="el"></component>
                    <component v-else-if="el.hasvmodel" :is="el.component" v-model="vModels[el.name]"></component>
                    <component v-else :is="el.component"></component>
                </template>
            </div>
            <div class="modal-window__buttons">
                <button v-if="confirmData" class="button button--color-2" type="button" @click="onButtonClick(confirmData)">
                    {{ confirmData.title || 'Принять' }}
                </button>
                <button v-for="button in buttons" :key="button.title"
                    :class="['button button--color-2', ...button.classList]" type="button" @click="onButtonClick(button)">
                    {{ button.title }}
                </button>
                <button v-if="declineData" class="button button--cancel" type="button" @click="onButtonClick(declineData)">
                    {{ declineData.title || 'Отклонить' }}
                </button>
            </div>
        </div>
    </div>
</template>