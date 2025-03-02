package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattService
import java.util.*

class BluetoothGattServiceImpl(registrar: BluetoothLowEnergyPigeonProxyApiRegistrar) :
    PigeonApiBluetoothGattService(registrar) {
    override fun pigeon_defaultConstructor(uuid: UUID, serviceType: Long): BluetoothGattService {
        return BluetoothGattService(uuid, serviceType.toInt())
    }

    override fun addCharacteristic(
        pigeon_instance: BluetoothGattService, characteristic: BluetoothGattCharacteristic
    ): Boolean {
        return pigeon_instance.addCharacteristic(characteristic)
    }

    override fun addService(pigeon_instance: BluetoothGattService, service: BluetoothGattService): Boolean {
        return pigeon_instance.addService(service)
    }

    override fun getCharacteristic(pigeon_instance: BluetoothGattService, uuid: UUID): BluetoothGattCharacteristic? {
        return pigeon_instance.getCharacteristic(uuid)
    }

    override fun getCharacteristics(pigeon_instance: BluetoothGattService): List<BluetoothGattCharacteristic> {
        return pigeon_instance.characteristics
    }

    override fun getIncludedServices(pigeon_instance: BluetoothGattService): List<BluetoothGattService> {
        return pigeon_instance.includedServices
    }

    override fun getInstanceId(pigeon_instance: BluetoothGattService): Long {
        return pigeon_instance.instanceId.toLong()
    }

    override fun getType(pigeon_instance: BluetoothGattService): Long {
        return pigeon_instance.type.toLong()
    }

    override fun getUuid(pigeon_instance: BluetoothGattService): UUID {
        return pigeon_instance.uuid
    }
}