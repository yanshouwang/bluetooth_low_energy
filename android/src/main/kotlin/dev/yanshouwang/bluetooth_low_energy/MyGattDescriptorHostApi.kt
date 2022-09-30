package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattDescriptor
import android.util.Log
import dev.yanshouwang.bluetooth_low_energy.pigeon.Messages as Pigeon

object MyGattDescriptorHostApi : Pigeon.GattDescriptorHostApi {
    override fun free(id: String) {
        Log.d(TAG, "free: $id")
        unregister(id)
    }

    override fun read(id: String, result: Pigeon.Result<ByteArray>) {
        Log.d(TAG, "read: $id")
        val items = instances[id] as MutableMap<String, Any>
        val gatt = items[KEY_GATT] as BluetoothGatt
        val descriptor = items[KEY_DESCRIPTOR] as BluetoothGattDescriptor
        val succeed = gatt.readDescriptor(descriptor)
        if (succeed) {
            instances["$id/$KEY_READ_RESULT"] = result
        } else {
            val error = BluetoothLowEnergyException("GATT read descriptor failed.")
            result.error(error)
        }
    }

    override fun write(id: String, value: ByteArray, result: Pigeon.Result<Void>) {
        Log.d(TAG, "write: $id, $value")
        val items = instances[id] as MutableMap<String, Any>
        val gatt = items[KEY_GATT] as BluetoothGatt
        val descriptor = items[KEY_DESCRIPTOR] as BluetoothGattDescriptor
        descriptor.value = value
        val succeed = gatt.writeDescriptor(descriptor)
        if (succeed) {
            instances["$id/$KEY_WRITE_RESULT"] = result
        } else {
            val error = BluetoothLowEnergyException("GATT write descriptor failed.")
            result.error(error)
        }
    }
}
