package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api
import dev.yanshouwang.bluetooth_low_energy.proto.gattDescriptor
import java.util.UUID

object GattCharacteristicHostApi : Api.GattCharacteristicHostApi {
    private const val CLIENT_CHARACTERISTIC_CONFIG = "00002902-0000-1000-8000-00805f9b34fb"

    const val READ_RESULT = "READ_RESULT"
    const val WRITE_RESULT = "WRITE_RESULT"

    override fun allocate(newId: String, oldId: String) {
        InstanceManager[newId] = InstanceManager.freeNotNull(oldId)
    }

    override fun free(id: String) {
        InstanceManager.remove(id)
    }

    override fun discoverDescriptors(id: String, result: Api.Result<MutableList<ByteArray>>) {
        val items = InstanceManager.freeNotNull<List<Any>>(id)
        val gatt = items[0] as BluetoothGatt
        val characteristic = items[1] as BluetoothGattCharacteristic
        val descriptorValues = mutableListOf<ByteArray>()
        for (descriptor in characteristic.descriptors) {
            InstanceManager[descriptor.id] = listOf(gatt, descriptor)
            val descriptorValue = gattDescriptor {
                this.id = descriptor.id
                this.uuid = descriptor.uuid.toString()
            }.toByteArray()
            descriptorValues.add(descriptorValue)
        }
        result.success(descriptorValues)
    }

    override fun read(id: String, result: Api.Result<ByteArray>) {
        val items = InstanceManager.freeNotNull<List<Any>>(id)
        val gatt = items[0] as BluetoothGatt
        val characteristic = items[1] as BluetoothGattCharacteristic
        val succeed = gatt.readCharacteristic(characteristic)
        if (succeed) {
            InstanceManager["${characteristic.id}/$READ_RESULT"] = result
        } else {
            val error = Throwable("GATT read characteristic failed.")
            result.error(error)
        }
    }

    override fun write(id: String, value: ByteArray, withoutResponse: Boolean, result: Api.Result<Void>) {
        val items = InstanceManager.freeNotNull<List<Any>>(id)
        val gatt = items[0] as BluetoothGatt
        val characteristic = items[1] as BluetoothGattCharacteristic
        characteristic.writeType = if (withoutResponse) {
            BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
        } else {
            BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
        }
        characteristic.value = value
        val succeed = gatt.writeCharacteristic(characteristic)
        if (succeed) {
            InstanceManager["${characteristic.id}/$WRITE_RESULT"] = result
        } else {
            val error = Throwable("GATT write characteristic failed.")
            result.error(error)
        }
    }

    override fun setNotify(id: String, value: Boolean, result: Api.Result<Void>) {
        val items = InstanceManager.freeNotNull<List<Any>>(id)
        val gatt = items[0] as BluetoothGatt
        val characteristic = items[1] as BluetoothGattCharacteristic
        val setSucceed = gatt.setCharacteristicNotification(characteristic, value)
        if (setSucceed) {
            val uuid = UUID.fromString(CLIENT_CHARACTERISTIC_CONFIG)
            val descriptor = characteristic.getDescriptor(uuid)
            descriptor.value = if (value) {
                BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
            } else {
                BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
            }
            val writeSucceed = gatt.writeDescriptor(descriptor)
            if (writeSucceed) {
                InstanceManager["${descriptor.id}/${GattDescriptorHostApi.WRITE_RESULT}"] = result
            } else {
                val error = Throwable("GATT write <client characteristic config> descriptor failed.")
                result.error(error)
            }
        } else {
            val error = Throwable("GATT set characteristic notification failed.")
            result.error(error)
        }
    }
}
