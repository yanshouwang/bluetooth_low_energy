package dev.yanshouwang.bluetooth_low_energy

object InstanceManager {
    private val instances = mutableMapOf<String, Any>()
    private val ids = mutableMapOf<Any, String>()

    operator fun get(id: String): Any? {
        return instances[id]
    }

    operator fun set(id: String, instance: Any) {
        instances[id] = instance
        ids[instance] = id
    }

    fun remove(id: String): Any? {
        val instance = instances.remove(id)
        if (instance != null) {
            ids.remove(instance)
        }
        return instance
    }

    fun findId(instance: Any): String? {
        return ids[instance]
    }

    fun findIdNotNull(instance: Any): String {
        return ids[instance] as String
    }
}

inline fun <reified T : Any> InstanceManager.free(id: String): T? {
    return remove(id) as T?
}

inline fun <reified T : Any> InstanceManager.freeNotNull(id: String): T {
    return remove(id) as T
}

inline fun <reified T : Any> InstanceManager.find(id: String): T? {
    return this[id] as T?
}

inline fun <reified T : Any> InstanceManager.findNotNull(id: String): T {
    return this[id] as T
}