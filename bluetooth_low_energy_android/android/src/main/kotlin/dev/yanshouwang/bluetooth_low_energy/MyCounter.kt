package dev.yanshouwang.bluetooth_low_energy

class MyCounter(val instance: MyObject) {
    private var _count = 1
    val count get() = _count

    fun increase() {
        _count++
    }

    fun decrease() {
        _count--
    }
}