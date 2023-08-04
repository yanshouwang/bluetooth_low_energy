package dev.yanshouwang.bluetooth_low_energy

class Instance(val value: Any) {
    private var _count = 1
    val count get() = _count

    fun increase() {
        _count++
    }

    fun decrease() {
        _count--
    }
}