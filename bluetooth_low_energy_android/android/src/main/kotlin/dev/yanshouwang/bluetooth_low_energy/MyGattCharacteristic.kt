package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic

class MyGattCharacteristic(val gatt: BluetoothGatt, val characteristic: BluetoothGattCharacteristic, private val instanceManager: MyInstanceManager) : MyObject(characteristic) {
    fun toArgs(): MyGattCharacteristicArgs {
        val key = hashCode()
        instanceManager.allocate(key, this)
        val hashCode = key.toLong()
        val uuidValue = characteristic.uuid.toString()
        val propertyNumbers = characteristic.propertyNumbers
        return MyGattCharacteristicArgs(hashCode, uuidValue, propertyNumbers)
    }
}

private val BluetoothGattCharacteristic.propertyNumbers: List<Long>
    get() {
        val numbers = mutableListOf<Long>()
        if (properties and BluetoothGattCharacteristic.PROPERTY_READ != 0) {
            val number = MyGattCharacteristicPropertyArgs.READ.raw.toLong()
            numbers.add(number)
        }
        if (properties and BluetoothGattCharacteristic.PROPERTY_WRITE != 0) {
            val number = MyGattCharacteristicPropertyArgs.WRITE.raw.toLong()
            numbers.add(number)
        }
        if (properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0) {
            val number = MyGattCharacteristicPropertyArgs.WRITEWITHOUTRESPONSE.raw.toLong()
            numbers.add(number)
        }
        if (properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0) {
            val number = MyGattCharacteristicPropertyArgs.NOTIFY.raw.toLong()
            numbers.add(number)
        }
        if (properties and BluetoothGattCharacteristic.PROPERTY_INDICATE != 0) {
            val number = MyGattCharacteristicPropertyArgs.INDICATE.raw.toLong()
            numbers.add(number)
        }
        return numbers
    }