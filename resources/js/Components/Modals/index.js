import { useModalsStore } from '../../store/modals.js'

export default function useModalHelpers(ctx) {
    const store = useModalsStore()

    const removeSelf = () => {
        store.remove(ctx.props.modalId)
    }

    return {
        store,
        removeSelf
    }
}