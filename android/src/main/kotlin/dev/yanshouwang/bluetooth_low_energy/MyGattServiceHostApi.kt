package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattService
import android.util.Log
import dev.yanshouwang.bluetooth_low_energy.pigeon.Messages as Pigeon
import dev.yanshouwang.bluetooth_low_energy.proto.gattCharacteristic
import dev.yanshouwang.bluetooth_low_energy.proto.uUID

object MyGattServiceHostApi : Pigeon.GattServiceHostApi {
    override fun free(id: String) {
        Log.d(TAG, "free: $id")
        unregister(id)
    }

    override fun discoverCharacteristics(id: String, result: Pigeon.Result<MutableList<ByteArray>>) {
        Log.d(TAG, "discoverCharacteristics: $id")
        val items = instances[id] as MutableMap<String, Any>
        val gatt = items[KEY_GATT] as BluetoothGatt
        val service = items[KEY_SERVICE] as BluetoothGattService
        val characteristicValues = mutableListOf<ByteArray>()
        for (characteristic in service.characteristics) {
            val characteristicValue = registerCharacteristic(gatt, characteristic)
            characteristicValues.add(characteristicValue)
        }
        result.success(characteristicValues)
    }

    private fun registerCharacteristic(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic): ByteArray {
        val id = characteristic.hashCode().toString()
        val items = register(id)
        items[KEY_GATT] = gatt
        items[KEY_CHARACTERISTIC] = characteristic
        return gattCharacteristic {
            this.id = id
            this.uuid = uUID {
                this.value = characteristic.uuid.toString()
            }
            this.canRead = characteristic.properties and BluetoothGattCharacteristic.PROPERTY_READ != 0
            this.canWrite = characteristic.properties and BluetoothGattCharacteristic.PROPERTY_WRITE != 0
            this.canWriteWithoutResponse =
                characteristic.properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0
            this.canNotify = characteristic.properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0
        }.toByteArray()
    }
}
