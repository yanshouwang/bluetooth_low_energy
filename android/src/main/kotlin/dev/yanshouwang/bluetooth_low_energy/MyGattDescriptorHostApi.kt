package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattDescriptor
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api

object MyGattDescriptorHostApi : Api.GattDescriptorHostApi {
    const val READ_RESULT = "READ_RESULT"
    const val WRITE_RESULT = "WRITE_RESULT"

    override fun allocate(id: Long, instanceId: Long) {
        val list = instances.remove(instanceId) as List<Any>
        val descriptor = list[1]
        instances[id] = list
        identifiers[descriptor] = id
    }

    override fun free(id: Long) {
        val list = instances.remove(id) as List<Any>
        val descriptor = list[1]
        identifiers.remove(descriptor)
    }

    override fun read(id: Long, result: Api.Result<ByteArray>) {
        val list = instances[id] as List<Any>
        val gatt = list[0] as BluetoothGatt
        val descriptor = list[1] as BluetoothGattDescriptor
        val succeed = gatt.readDescriptor(descriptor)
        if (succeed) {
            items["${descriptor.hashCode()}/$READ_RESULT"] = result
        } else {
            val error = Throwable("GATT read descriptor failed.")
            result.error(error)
        }
    }

    override fun write(id: Long, value: ByteArray, result: Api.Result<Void>) {
        val list = instances[id] as List<Any>
        val gatt = list[0] as BluetoothGatt
        val descriptor = list[1] as BluetoothGattDescriptor
        descriptor.value = value
        val succeed = gatt.writeDescriptor(descriptor)
        if (succeed) {
            items["${descriptor.hashCode()}/$WRITE_RESULT"] = result
        } else {
            val error = Throwable("GATT write descriptor failed.")
            result.error(error)
        }
    }
}
