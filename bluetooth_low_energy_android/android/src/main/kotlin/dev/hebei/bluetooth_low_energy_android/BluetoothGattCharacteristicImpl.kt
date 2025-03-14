package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattService
import java.util.*

class BluetoothGattCharacteristicImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
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

    override fun getInstanceId(pigeon_instance: BluetoothGattCharacteristic): Long {
        return pigeon_instance.instanceId.toLong()
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

    override fun getUuid(pigeon_instance: BluetoothGattCharacteristic): UUID {
        return pigeon_instance.uuid
    }

    override fun getWriteType(pigeon_instance: BluetoothGattCharacteristic): Long {
        return pigeon_instance.writeType.toLong()
    }

    override fun setWriteType(pigeon_instance: BluetoothGattCharacteristic, writeType: Long) {
        pigeon_instance.writeType = writeType.toInt()
    }
}