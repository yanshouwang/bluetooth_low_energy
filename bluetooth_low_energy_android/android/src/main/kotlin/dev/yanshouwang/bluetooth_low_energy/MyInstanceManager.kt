package dev.yanshouwang.bluetooth_low_energy

class MyInstanceManager {
    private val counters = mutableMapOf<Int, MyCounter>()

    fun instanceOf(key: Int): Any? {
        synchronized(counters) {
            return counters[key]?.instance
        }
    }

    fun allocate(key: Int, instance: Any) {
        synchronized(counters) {
            val counter = counters[key]
            if (counter == null) {
                counters[key] = MyCounter(instance)
            } else {
                counter.count++
            }
        }
    }

    fun free(key: Int) {
        synchronized(counters) {
            val counter = counters[key] ?: return
            counter.count--
            if (counter.count > 0) {
                return
            }
            counters.remove(key)
        }
    }
}