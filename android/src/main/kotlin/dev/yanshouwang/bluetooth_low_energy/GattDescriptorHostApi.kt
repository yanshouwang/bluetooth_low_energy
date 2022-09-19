package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattDescriptor
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api

object GattDescriptorHostApi : Api.GattDescriptorHostApi {
    const val READ_RESULT = "READ_RESULT"
    const val WRITE_RESULT = "WRITE_RESULT"

    override fun allocate(newId: String, oldId: String) {
        val items = instances.freeNotNull<List<Any>>(oldId)
        val descriptor = items[1]
        instances[newId] = items
        ids[descriptor] = newId
    }

    override fun free(id: String) {
        val items = instances.freeNotNull<List<Any>>(id)
        val descriptor = items[1]
        ids.remove(descriptor)
    }

    override fun read(id: String, result: Api.Result<ByteArray>) {
        val items = instances.findNotNull<List<Any>>(id)
        val gatt = items[0] as BluetoothGatt
        val descriptor = items[1] as BluetoothGattDescriptor
        val succeed = gatt.readDescriptor(descriptor)
        if (succeed) {
            instances["${descriptor.id}/$READ_RESULT"] = result
        } else {
            val error = Throwable("GATT read descriptor failed.")
            result.error(error)
        }
    }

    override fun write(id: String, value: ByteArray, result: Api.Result<Void>) {
        val items = instances.findNotNull<List<Any>>(id)
        val gatt = items[0] as BluetoothGatt
        val descriptor = items[1] as BluetoothGattDescriptor
        descriptor.value = value
        val succeed = gatt.writeDescriptor(descriptor)
        if (succeed) {
            instances["${descriptor.id}/$WRITE_RESULT"] = result
        } else {
            val error = Throwable("GATT write descriptor failed.")
            result.error(error)
        }
    }
}
