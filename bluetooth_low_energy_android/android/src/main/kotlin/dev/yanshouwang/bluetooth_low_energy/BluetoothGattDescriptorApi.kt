package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGattDescriptor

class BluetoothGattDescriptorApi(private val instanceManager: InstanceManager) : BluetoothGattDescriptorHostApi {
    override fun getCharacteristic(hashCode: Long): Long {
        val descriptor = instanceManager.valueOf(hashCode) as BluetoothGattDescriptor
        val characteristic = descriptor.characteristic
        return instanceManager.allocate(characteristic)
    }

    override fun getUUID(hashCode: Long): Long {
        val descriptor = instanceManager.valueOf(hashCode) as BluetoothGattDescriptor
        val uuid = descriptor.uuid
        return instanceManager.allocate(uuid)
    }

    override fun getPermissions(hashCode: Long): Long {
        val descriptor = instanceManager.valueOf(hashCode) as BluetoothGattDescriptor
        return descriptor.permissions.toLong()
    }

    override fun getValue(hashCode: Long): ByteArray {
        val descriptor = instanceManager.valueOf(hashCode) as BluetoothGattDescriptor
        return descriptor.value
    }

    override fun setValue(hashCode: Long, value: ByteArray): Boolean {
        val descriptor = instanceManager.valueOf(hashCode) as BluetoothGattDescriptor
        return descriptor.setValue(value)
    }
}