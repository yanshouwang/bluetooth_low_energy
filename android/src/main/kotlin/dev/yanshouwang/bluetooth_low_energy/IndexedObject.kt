package dev.yanshouwang.bluetooth_low_energy

import java.util.*

open class IndexedObject<T>(val value: T) {
    val indexedUUID = UUID.randomUUID().toString()
}