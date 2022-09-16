package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattService
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api
import dev.yanshouwang.bluetooth_low_energy.proto.gattCharacteristic

object GattServiceHostApi : Api.GattServiceHostApi {
    override fun allocate(newId: String, oldId: String) {
        instances[newId] = instances.remove(oldId) as BluetoothGattService
    }

    override fun free(id: String) {
        instances.remove(id)
    }

    override fun discoverCharacteristics(id: String, result: Api.Result<MutableList<ByteArray>>) {
        val service = instances[id] as BluetoothGattService
        val characteristicValues = mutableListOf<ByteArray>()
        for (characteristic in service.characteristics) {
            instances[characteristic.id] = characteristic
            val characteristicValue = gattCharacteristic {
                this.id = characteristic.id
                this.uuid = characteristic.uuid.toString()
                this.canRead =
                    characteristic.properties and BluetoothGattCharacteristic.PROPERTY_READ != 0
                this.canWrite =
                    characteristic.properties and BluetoothGattCharacteristic.PROPERTY_WRITE != 0
                this.canWriteWithoutResponse =
                    characteristic.properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0
                this.canNotify =
                    characteristic.properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0
            }.toByteArray()
            characteristicValues.add(characteristicValue)
        }
        result.success(characteristicValues)
    }
}
