package dev.yanshouwang.bluetooth_low_energy

import java.util.*

open class IndexedObject<T>(val `object`: T) {
    val uuid = UUID.randomUUID().toString()
}