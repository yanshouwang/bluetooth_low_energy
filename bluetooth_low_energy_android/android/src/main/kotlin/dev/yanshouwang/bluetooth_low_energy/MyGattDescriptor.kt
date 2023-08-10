package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattDescriptor

class MyGattDescriptor(val gatt: BluetoothGatt, val descriptor: BluetoothGattDescriptor, private val instanceManager: MyInstanceManager) : MyObject(descriptor) {
    fun toArgs(): MyGattDescriptorArgs {
        val key = hashCode()
        instanceManager.allocate(key, this)
        val hashCode = key.toLong()
        val uuidValue = descriptor.uuid.toString()
        return MyGattDescriptorArgs(hashCode, uuidValue)
    }
}