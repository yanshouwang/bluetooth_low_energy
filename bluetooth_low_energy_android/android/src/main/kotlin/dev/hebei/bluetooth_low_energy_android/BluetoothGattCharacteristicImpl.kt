package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattService
import java.util.*

class BluetoothGattCharacteristicImpl(registrar: BluetoothLowEnergyPigeonProxyApiRegistrar) :
    PigeonApiBluetoothGattCharacteristic(registrar) {
    override fun pigeon_defaultConstructor(
        uuid: UUID, properties: Long, permissions: Long
    ): BluetoothGattCharacteristic {
        return BluetoothGattCharacteristic(uuid, properties.toInt(), permissions.toInt())
    }

    override fun addDescriptor(
        pigeon_instance: BluetoothGattCharacteristic, descriptor: BluetoothGattDescriptor
    ): Boolean {
        return pigeon_instance.addDescriptor(descriptor)
    }

    override fun getDescriptor(pigeon_instance: BluetoothGattCharacteristic, uuid: UUID): BluetoothGattDescriptor? {
        return pigeon_instance.getDescriptor(uuid)
    }

    override fun getDescriptors(pigeon_instance: BluetoothGattCharacteristic): List<BluetoothGattDescriptor> {
        return pigeon_instance.descriptors
    }

    override fun getFloatValue(pigeon_instance: BluetoothGattCharacteristic, formatType: Long, offset: Long): Double {
        return pigeon_instance.getFloatValue(formatType.toInt(), offset.toInt()).toDouble()
    }

    override fun getInstanceId(pigeon_instance: BluetoothGattCharacteristic): Long {
        return pigeon_instance.instanceId.toLong()
    }

    override fun getIntValue(pigeon_instance: BluetoothGattCharacteristic, formatType: Long, offset: Long): Long {
        return pigeon_instance.getIntValue(formatType.toInt(), offset.toInt()).toLong()
    }

    override fun getPermissions(pigeon_instance: BluetoothGattCharacteristic): Long {
        return pigeon_instance.permissions.toLong()
    }

    override fun getProperties(pigeon_instance: BluetoothGattCharacteristic): Long {
        return pigeon_instance.properties.toLong()
    }

    override fun getService(pigeon_instance: BluetoothGattCharacteristic): BluetoothGattService {
        return pigeon_instance.service
    }

    override fun getStringValue(pigeon_instance: BluetoothGattCharacteristic, offset: Long): String {
        return pigeon_instance.getStringValue(offset.toInt())
    }

    override fun getUuid(pigeon_instance: BluetoothGattCharacteristic): UUID {
        return pigeon_instance.uuid
    }

    override fun getValue(pigeon_instance: BluetoothGattCharacteristic): ByteArray {
        return pigeon_instance.value
    }

    override fun getWriteType(pigeon_instance: BluetoothGattCharacteristic): Long {
        return pigeon_instance.writeType.toLong()
    }

    override fun setValue1(pigeon_instance: BluetoothGattCharacteristic, value: ByteArray): Boolean {
        return pigeon_instance.setValue(value)
    }

    override fun setValue2(
        pigeon_instance: BluetoothGattCharacteristic, value: Long, formatType: Long, offset: Long
    ): Boolean {
        return pigeon_instance.setValue(value.toInt(), formatType.toInt(), offset.toInt())
    }

    override fun setValue3(
        pigeon_instance: BluetoothGattCharacteristic, mantissa: Long, exponent: Long, formatType: Long, offset: Long
    ): Boolean {
        return pigeon_instance.setValue(mantissa.toInt(), exponent.toInt(), formatType.toInt(), offset.toInt())
    }

    override fun setValue4(pigeon_instance: BluetoothGattCharacteristic, value: String): Boolean {
        return pigeon_instance.setValue(value)
    }

    override fun setWriteType(pigeon_instance: BluetoothGattCharacteristic, writeType: Long) {
        pigeon_instance.writeType = writeType.toInt()
    }
}