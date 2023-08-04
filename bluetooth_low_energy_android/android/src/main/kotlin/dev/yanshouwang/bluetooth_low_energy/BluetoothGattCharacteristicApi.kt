package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import java.util.UUID

class BluetoothGattCharacteristicApi(private val instanceManager: InstanceManager) : BluetoothGattCharacteristicHostApi {
    override fun getService(hashCode: Long): Long {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        val service = characteristic.service
        return instanceManager.allocate(service)
    }

    override fun getUUID(hashCode: Long): Long {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        val uuid = characteristic.uuid
        return instanceManager.allocate(uuid)
    }

    override fun getInstanceId(hashCode: Long): Long {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        return characteristic.instanceId.toLong()
    }

    override fun getValue(hashCode: Long): ByteArray {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        return characteristic.value
    }

    override fun setValue(hashCode: Long, value: ByteArray): Boolean {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        return characteristic.setValue(value)
    }

    override fun setValue1(hashCode: Long, value: String): Boolean {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        return characteristic.setValue(value)
    }

    override fun setValue2(hashCode: Long, value: Long, formatType: Long, offset: Long): Boolean {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        val value1 = value.toInt()
        val formatType1 = formatType.toInt()
        val offset1 = offset.toInt()
        return characteristic.setValue(value1, formatType1, offset1)
    }

    override fun setValue3(hashCode: Long, mantissa: Long, exponent: Long, formatType: Long, offset: Long): Boolean {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        val mantissa1 = mantissa.toInt()
        val exponent1 = exponent.toInt()
        val formatType1 = formatType.toInt()
        val offset1 = offset.toInt()
        return characteristic.setValue(mantissa1, exponent1, formatType1, offset1)
    }

    override fun getDescriptors(hashCode: Long): List<Long> {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        return characteristic.descriptors.map { descriptor -> instanceManager.allocate(descriptor) }
    }

    override fun getDescriptor(hashCode: Long, uuidHashCode: Long): Long {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        val uuid = instanceManager.valueOf(hashCode) as UUID
        val descriptor = characteristic.getDescriptor(uuid)
        return instanceManager.allocate(descriptor)
    }

    override fun getPermissions(hashCode: Long): Long {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        return characteristic.permissions.toLong()
    }

    override fun getProperties(hashCode: Long): Long {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        return characteristic.properties.toLong()
    }

    override fun getWriteType(hashCode: Long): Long {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        return characteristic.writeType.toLong()
    }

    override fun setWriteType(hashCode: Long, writeType: Long) {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        characteristic.writeType = writeType.toInt()
    }

    override fun getFloatValue(hashCode: Long, formatType: Long, offset: Long): Double {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        val formatType1 = formatType.toInt()
        val offset1 = offset.toInt()
        return characteristic.getFloatValue(formatType1, offset1).toDouble()
    }

    override fun getIntValue(hashCode: Long, formatType: Long, offset: Long): Long {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        val formatType1 = formatType.toInt()
        val offset1 = offset.toInt()
        return characteristic.getIntValue(formatType1, offset1).toLong()
    }

    override fun getStringValue(hashCode: Long, offset: Long): String {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        val offset1 = offset.toInt()
        return characteristic.getStringValue(offset1)
    }

    override fun addDescriptor(hashCode: Long, descriptorHashCode: Long): Boolean {
        val characteristic = instanceManager.valueOf(hashCode) as BluetoothGattCharacteristic
        val descriptor = instanceManager.valueOf(descriptorHashCode) as BluetoothGattDescriptor
        return characteristic.addDescriptor(descriptor)
    }
}