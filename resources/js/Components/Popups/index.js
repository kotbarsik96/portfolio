import { usePopupsStore } from "@/store/popups"

export default function usePopupsHelpers(ctx) {
    const store = usePopupsStore()

    const removeSelf = (removeTimeout = null) => {
        store.remove(ctx.props.id)
        if(removeTimeout)
            clearTimeout(removeTimeout)
    }

    return {
        store,
        removeSelf
    }
}