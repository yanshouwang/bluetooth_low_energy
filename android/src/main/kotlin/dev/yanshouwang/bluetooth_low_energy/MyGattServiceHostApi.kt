package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattService
import dev.yanshouwang.bluetooth_low_energy.pigeon.Messages as Pigeon
import dev.yanshouwang.bluetooth_low_energy.proto.gattCharacteristic
import dev.yanshouwang.bluetooth_low_energy.proto.uUID

object MyGattServiceHostApi : Pigeon.GattServiceHostApi {
    override fun allocate(id: Long, instanceId: Long) {
        val list = instances.remove(instanceId) as List<Any>
        val service = list[1]
        instances[id] = list
        identifiers[service] = id
    }

    override fun free(id: Long) {
        val list = instances.remove(id) as List<Any>
        val service = list[1]
        identifiers.remove(service)
    }

    override fun discoverCharacteristics(id: Long, result: Pigeon.Result<MutableList<ByteArray>>) {
        val list = instances[id] as List<Any>
        val gatt = list[0] as BluetoothGatt
        val service = list[1] as BluetoothGattService
        val characteristicValues = mutableListOf<ByteArray>()
        for (characteristic in service.characteristics) {
            val characteristicId = characteristic.hashCode().toLong()
            instances[characteristicId] = listOf(gatt, characteristic)
            val characteristicValue = gattCharacteristic {
                this.id = characteristicId
                this.uuid = uUID {
                    this.value = characteristic.uuid.toString()
                }
                this.canRead = characteristic.properties and BluetoothGattCharacteristic.PROPERTY_READ != 0
                this.canWrite = characteristic.properties and BluetoothGattCharacteristic.PROPERTY_WRITE != 0
                this.canWriteWithoutResponse =
                    characteristic.properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0
                this.canNotify = characteristic.properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0
            }.toByteArray()
            characteristicValues.add(characteristicValue)
        }
        result.success(characteristicValues)
    }
}
