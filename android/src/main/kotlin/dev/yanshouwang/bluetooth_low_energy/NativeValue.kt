package dev.yanshouwang.bluetooth_low_energy

import java.util.*

open class NativeValue<T>(val value: T) {
    public val key = UUID.randomUUID().toString()
}