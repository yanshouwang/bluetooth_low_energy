package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattService

class MyGattService(val gatt: BluetoothGatt, val service: BluetoothGattService, private val instanceManager: MyInstanceManager) : MyObject(service) {
    fun toArgs(): MyGattServiceArgs {
        val key = hashCode()
        instanceManager.allocate(key, this)
        val hashCode = key.toLong()
        val uuidValue = service.uuid.toString()
        return MyGattServiceArgs(hashCode, uuidValue)
    }
}