package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.util.Log
import dev.yanshouwang.bluetooth_low_energy.pigeon.Messages as Pigeon
import dev.yanshouwang.bluetooth_low_energy.proto.gattDescriptor
import dev.yanshouwang.bluetooth_low_energy.proto.uUID
import java.util.UUID

object MyGattCharacteristicHostApi : Pigeon.GattCharacteristicHostApi {
    private const val CLIENT_CHARACTERISTIC_CONFIG = "00002902-0000-1000-8000-00805f9b34fb"

    override fun free(id: String) {
        Log.d(TAG, "free: $id")
        unregister(id)
    }

    override fun discoverDescriptors(id: String, result: Pigeon.Result<MutableList<ByteArray>>) {
        Log.d(TAG, "discoverDescriptors: $id")
        val items = instances[id] as MutableMap<String, Any>
        val gatt = items[KEY_GATT] as BluetoothGatt
        val characteristic = items[KEY_CHARACTERISTIC] as BluetoothGattCharacteristic
        val descriptorValues = mutableListOf<ByteArray>()
        for (descriptor in characteristic.descriptors) {
            val descriptorValue = registerDescriptor(gatt, descriptor)
            descriptorValues.add(descriptorValue)
        }
        result.success(descriptorValues)
    }

    private fun registerDescriptor(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor): ByteArray {
        val id = descriptor.hashCode().toString()
        val items = register(id)
        items[KEY_GATT] = gatt
        items[KEY_DESCRIPTOR] = descriptor
        return gattDescriptor {
            this.id = id
            this.uuid = uUID {
                this.value = descriptor.uuid.toString()
            }
        }.toByteArray()
    }

    override fun read(id: String, result: Pigeon.Result<ByteArray>) {
        Log.d(TAG, "read: $id")
        val items = instances[id] as MutableMap<String, Any>
        val gatt = items[KEY_GATT] as BluetoothGatt
        val characteristic = items[KEY_CHARACTERISTIC] as BluetoothGattCharacteristic
        val succeed = gatt.readCharacteristic(characteristic)
        if (succeed) {
            instances["$id/$KEY_READ_RESULT"] = result
        } else {
            val error = BluetoothLowEnergyException("GATT read characteristic failed.")
            result.error(error)
        }
    }

    override fun write(id: String, value: ByteArray, withoutResponse: Boolean, result: Pigeon.Result<Void>) {
        Log.d(TAG, "write: $id, $value")
        val items = instances[id] as MutableMap<String, Any>
        val gatt = items[KEY_GATT] as BluetoothGatt
        val characteristic = items[KEY_CHARACTERISTIC] as BluetoothGattCharacteristic
        characteristic.writeType = if (withoutResponse) {
            BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
        } else {
            BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
        }
        characteristic.value = value
        val succeed = gatt.writeCharacteristic(characteristic)
        if (succeed) {
            instances["$id/$KEY_WRITE_RESULT"] = result
        } else {
            val error = BluetoothLowEnergyException("GATT write characteristic failed.")
            result.error(error)
        }
    }

    override fun setNotify(id: String, value: Boolean, result: Pigeon.Result<Void>) {
        Log.d(TAG, "setNotify: $id, $value")
        val items = instances[id] as MutableMap<String, Any>
        val gatt = items[KEY_GATT] as BluetoothGatt
        val characteristic = items[KEY_CHARACTERISTIC] as BluetoothGattCharacteristic
        val succeed = gatt.setCharacteristicNotification(characteristic, value)
        if (succeed) {
            writeClientCharacteristicConfig(gatt, characteristic, value, result)
        } else {
            val error = BluetoothLowEnergyException("GATT set characteristic notification failed.")
            result.error(error)
        }
    }

    private fun writeClientCharacteristicConfig(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, value: Boolean, result: Pigeon.Result<Void>) {
        val uuid = UUID.fromString(CLIENT_CHARACTERISTIC_CONFIG)
        val descriptor = characteristic.getDescriptor(uuid)
        descriptor.value = if (value) {
            BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
        } else {
            BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
        }
        val succeed = gatt.writeDescriptor(descriptor)
        if (succeed) {
            val id = descriptor.hashCode().toString()
            instances["$id/$KEY_WRITE_RESULT"] = result
        } else {
            val error = BluetoothLowEnergyException("GATT write client characteristic config failed.")
            result.error(error)
        }
    }
}
