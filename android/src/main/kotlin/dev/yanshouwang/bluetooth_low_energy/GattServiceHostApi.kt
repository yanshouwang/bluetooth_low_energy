package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattService
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api
import dev.yanshouwang.bluetooth_low_energy.proto.gattCharacteristic

object GattServiceHostApi : Api.GattServiceHostApi {
    override fun allocate(newId: String, oldId: String) {
        val items = instances.freeNotNull<List<Any>>(oldId)
        val service = items[1]
        instances[newId] = items
        ids[service] = newId
    }

    override fun free(id: String) {
        val items = instances.freeNotNull<List<Any>>(id)
        val service = items[1]
        ids.remove(service)
    }

    override fun discoverCharacteristics(id: String, result: Api.Result<MutableList<ByteArray>>) {
        val items = instances.findNotNull<List<Any>>(id)
        val gatt = items[0] as BluetoothGatt
        val service = items[1] as BluetoothGattService
        val characteristicValues = mutableListOf<ByteArray>()
        for (characteristic in service.characteristics) {
            instances[characteristic.id] = listOf(gatt, characteristic)
            val characteristicValue = gattCharacteristic {
                this.id = characteristic.id
                this.uuid = characteristic.uuid.toString()
                this.canRead = characteristic.properties and BluetoothGattCharacteristic.PROPERTY_READ != 0
                this.canWrite = characteristic.properties and BluetoothGattCharacteristic.PROPERTY_WRITE != 0
                this.canWriteWithoutResponse = characteristic.properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0
                this.canNotify = characteristic.properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0
            }.toByteArray()
            characteristicValues.add(characteristicValue)
        }
        result.success(characteristicValues)
    }
}
