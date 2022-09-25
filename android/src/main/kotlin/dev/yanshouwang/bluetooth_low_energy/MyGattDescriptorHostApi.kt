package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattDescriptor
import android.util.Log
import dev.yanshouwang.bluetooth_low_energy.pigeon.Messages as Pigeon

object MyGattDescriptorHostApi : Pigeon.GattDescriptorHostApi {
    override fun allocate(id: Long, instanceId: Long) {
        Log.d(TAG, "allocate: $id, $instanceId")
        val list = instances.remove(instanceId) as List<Any>
        val descriptor = list[1]
        instances[id] = list
        identifiers[descriptor] = id
    }

    override fun free(id: Long) {
        Log.d(TAG, "free: $id")
        val list = instances.remove(id) as List<Any>
        val descriptor = list[1]
        identifiers.remove(descriptor)
    }

    override fun read(id: Long, result: Pigeon.Result<ByteArray>) {
        Log.d(TAG, "read: $id")
        val list = instances[id] as List<Any>
        val gatt = list[0] as BluetoothGatt
        val descriptor = list[1] as BluetoothGattDescriptor
        val succeed = gatt.readDescriptor(descriptor)
        if (succeed) {
            items["${descriptor.hashCode()}/$KEY_READ_RESULT"] = result
        } else {
            val error = BluetoothLowEnergyException("GATT read descriptor failed.")
            result.error(error)
        }
    }

    override fun write(id: Long, value: ByteArray, result: Pigeon.Result<Void>) {
        Log.d(TAG, "write: $id, $value")
        val list = instances[id] as List<Any>
        val gatt = list[0] as BluetoothGatt
        val descriptor = list[1] as BluetoothGattDescriptor
        descriptor.value = value
        val succeed = gatt.writeDescriptor(descriptor)
        if (succeed) {
            items["${descriptor.hashCode()}/$KEY_WRITE_RESULT"] = result
        } else {
            val error = BluetoothLowEnergyException("GATT write descriptor failed.")
            result.error(error)
        }
    }
}
