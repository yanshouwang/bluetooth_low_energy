package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattDescriptor
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api

object GattDescriptorHostApi : Api.GattDescriptorHostApi {
    const val READ_RESULT = "READ_RESULT"
    const val WRITE_RESULT = "WRITE_RESULT"

    override fun allocate(newId: String, oldId: String) {
        InstanceManager[newId] = InstanceManager.freeNotNull(oldId)
    }

    override fun free(id: String) {
        InstanceManager.remove(id)
    }

    override fun read(id: String, result: Api.Result<ByteArray>) {
        val items = InstanceManager.findNotNull<List<Any>>(id)
        val gatt = items[0] as BluetoothGatt
        val descriptor = items[1] as BluetoothGattDescriptor
        val succeed = gatt.readDescriptor(descriptor)
        if (succeed) {
            InstanceManager["${descriptor.id}/$READ_RESULT"] = result
        } else {
            val error = Throwable("GATT read descriptor failed.")
            result.error(error)
        }
    }

    override fun write(id: String, value: ByteArray, result: Api.Result<Void>) {
        val items = InstanceManager.findNotNull<List<Any>>(id)
        val gatt = items[0] as BluetoothGatt
        val descriptor = items[1] as BluetoothGattDescriptor
        descriptor.value = value
        val succeed = gatt.writeDescriptor(descriptor)
        if (succeed) {
            InstanceManager["${descriptor.id}/$WRITE_RESULT"] = result
        } else {
            val error = Throwable("GATT write descriptor failed.")
            result.error(error)
        }
    }
}
