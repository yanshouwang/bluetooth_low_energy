package dev.yanshouwang.bluetooth_low_energy

class InstanceManager {
    private val instances = mutableMapOf<Long, Instance>()

    fun valueOf(hashCode: Long): Any? {
        synchronized(instances) {
            return instances[hashCode]?.value
        }
    }

    fun allocate(value: Any): Long {
        synchronized(instances) {
            val hashCode = value.hashCode1
            val oldInstance = instances[hashCode]
            if (oldInstance == null) {
                val newInstance = Instance(value)
                instances[hashCode] = newInstance
            } else {
                oldInstance.increase()
            }
            return hashCode
        }
    }

    fun free(hashCode: Long): Any? {
        synchronized(instances) {
            val instance = instances[hashCode] ?: return null
            instance.decrease()
            if (instance.count > 0) {
                return null
            }
            instances.remove(hashCode)
            return instance.value
        }
    }
}