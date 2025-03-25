package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothGatt
import java.util.UUID

abstract class GATTAttribute {
    private val gatt: BluetoothGatt?
    abstract val uuid: UUID
    abstract val instanceId: Int

    internal val gattNotNull get() = gatt ?: throw NullPointerException("gatt is null")

    constructor() {
        this.gatt = null
    }

    internal constructor(gatt: BluetoothGatt) {
        this.gatt = gatt
    }
}

