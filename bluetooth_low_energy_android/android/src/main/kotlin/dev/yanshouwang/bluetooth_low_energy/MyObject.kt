package dev.yanshouwang.bluetooth_low_energy

open class MyObject(instance: Any) {
    private val hashCode = instance.hashCode()

    override fun hashCode(): Int {
        return hashCode
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false
        return hashCode() == other.hashCode()
    }
}