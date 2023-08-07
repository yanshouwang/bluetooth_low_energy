package dev.yanshouwang.bluetooth_low_energy

class MyInstanceManager {
    private val counters = mutableMapOf<Long, MyCounter>()

    fun instanceOf(hashCode: Long): MyObject? {
        synchronized(counters) {
            return counters[hashCode]?.instance
        }
    }

    fun allocate(instance: MyObject): Long {
        synchronized(counters) {
            val hashCode = instance.hashCode().toLong()
            val oldCounter = counters[hashCode]
            if (oldCounter == null) {
                instance.onAllocated()
                val newCounter = MyCounter(instance)
                counters[hashCode] = newCounter
            } else {
                oldCounter.increase()
            }
            return hashCode
        }
    }

    fun free(hashCode: Long) {
        synchronized(counters) {
            val counter = counters[hashCode] ?: return
            counter.decrease()
            if (counter.count > 0) {
                return
            }
            counters.remove(hashCode)
            counter.instance.onFreed()
        }
    }
}