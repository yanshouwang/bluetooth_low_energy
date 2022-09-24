package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import dev.yanshouwang.bluetooth_low_energy.pigeon.Messages as Pigeon
import dev.yanshouwang.bluetooth_low_energy.proto.gattDescriptor
import dev.yanshouwang.bluetooth_low_energy.proto.uUID
import java.util.UUID

object MyGattCharacteristicHostApi : Pigeon.GattCharacteristicHostApi {
    private const val CLIENT_CHARACTERISTIC_CONFIG = "00002902-0000-1000-8000-00805f9b34fb"

    override fun allocate(id: Long, instanceId: Long) {
        val list = instances.remove(instanceId) as List<Any>
        val characteristic = list[1]
        instances[id] = list
        identifiers[characteristic] = id
    }

    override fun free(id: Long) {
        val list = instances.remove(id) as List<Any>
        val characteristic = list[1]
        identifiers.remove(characteristic)
    }

    override fun discoverDescriptors(id: Long, result: Pigeon.Result<MutableList<ByteArray>>) {
        val list = instances[id] as List<Any>
        val gatt = list[0] as BluetoothGatt
        val characteristic = list[1] as BluetoothGattCharacteristic
        val descriptorValues = mutableListOf<ByteArray>()
        for (descriptor in characteristic.descriptors) {
            val descriptorId = descriptor.hashCode().toLong()
            instances[descriptorId] = listOf(gatt, descriptor)
            val descriptorValue = gattDescriptor {
                this.id = descriptorId
                this.uuid = uUID {
                    this.value = descriptor.uuid.toString()
                }
            }.toByteArray()
            descriptorValues.add(descriptorValue)
        }
        result.success(descriptorValues)
    }

    override fun read(id: Long, result: Pigeon.Result<ByteArray>) {
        val list = instances[id] as List<Any>
        val gatt = list[0] as BluetoothGatt
        val characteristic = list[1] as BluetoothGattCharacteristic
        val succeed = gatt.readCharacteristic(characteristic)
        if (succeed) {
            items["${characteristic.hashCode()}/$KEY_READ_RESULT"] = result
        } else {
            val error = BluetoothLowEnergyException("GATT read characteristic failed.")
            result.error(error)
        }
    }

    override fun write(id: Long, value: ByteArray, withoutResponse: Boolean, result: Pigeon.Result<Void>) {
        val list = instances[id] as List<Any>
        val gatt = list[0] as BluetoothGatt
        val characteristic = list[1] as BluetoothGattCharacteristic
        characteristic.writeType = if (withoutResponse) {
            BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
        } else {
            BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
        }
        characteristic.value = value
        val succeed = gatt.writeCharacteristic(characteristic)
        if (succeed) {
            items["${characteristic.hashCode()}/$KEY_WRITE_RESULT"] = result
        } else {
            val error = BluetoothLowEnergyException("GATT write characteristic failed.")
            result.error(error)
        }
    }

    override fun setNotify(id: Long, value: Boolean, result: Pigeon.Result<Void>) {
        val list = instances[id] as List<Any>
        val gatt = list[0] as BluetoothGatt
        val characteristic = list[1] as BluetoothGattCharacteristic
        val setNotificationSucceed = gatt.setCharacteristicNotification(characteristic, value)
        if (setNotificationSucceed) {
            val uuid = UUID.fromString(CLIENT_CHARACTERISTIC_CONFIG)
            val descriptor = characteristic.getDescriptor(uuid)
            descriptor.value = if (value) {
                BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
            } else {
                BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
            }
            val writeSucceed = gatt.writeDescriptor(descriptor)
            if (writeSucceed) {
                items["${descriptor.hashCode()}/${KEY_WRITE_RESULT}"] = result
            } else {
                val error = BluetoothLowEnergyException("GATT write <client characteristic config> descriptor failed.")
                result.error(error)
            }
        } else {
            val error = BluetoothLowEnergyException("GATT set characteristic notification failed.")
            result.error(error)
        }
    }
}
