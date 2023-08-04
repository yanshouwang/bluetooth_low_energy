package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattService
import java.util.UUID

class BluetoothGattServiceApi(private val instanceManager: InstanceManager) : BluetoothGattServiceHostApi {
    override fun getType(hashCode: Long): Long {
        val service = instanceManager.valueOf(hashCode) as BluetoothGattService
        return service.type.toLong()
    }

    override fun getUUID(hashCode: Long): Long {
        val service = instanceManager.valueOf(hashCode) as BluetoothGattService
        val uuid = service.uuid
        return instanceManager.allocate(uuid)
    }

    override fun getIncludedServices(hashCode: Long): List<Long> {
        val service = instanceManager.valueOf(hashCode) as BluetoothGattService
        return service.includedServices.map { includedService -> instanceManager.allocate(includedService) }
    }

    override fun getCharacteristics(hashCode: Long): List<Long> {
        val service = instanceManager.valueOf(hashCode) as BluetoothGattService
        return service.characteristics.map { characteristic -> instanceManager.allocate(characteristic) }
    }

    override fun getInstanceId(hashCode: Long): Long {
        val service = instanceManager.valueOf(hashCode) as BluetoothGattService
        return service.instanceId.toLong()
    }

    override fun getCharacteristic(hashCode: Long, uuidHashCode: Long): Long {
        val service = instanceManager.valueOf(hashCode) as BluetoothGattService
        val uuid = instanceManager.valueOf(uuidHashCode) as UUID
        val characteristic = service.getCharacteristic(uuid)
        return instanceManager.allocate(characteristic)
    }

    override fun addService(hashCode: Long, serviceHashCode: Long): Boolean {
        val service = instanceManager.valueOf(hashCode) as BluetoothGattService
        val includedService = instanceManager.valueOf(serviceHashCode) as BluetoothGattService
        return service.addService(includedService)
    }

    override fun addCharacteristic(hashCode: Long, characteristicHashCode: Long): Boolean {
        val service = instanceManager.valueOf(hashCode) as BluetoothGattService
        val characteristic = instanceManager.valueOf(characteristicHashCode) as BluetoothGattCharacteristic
        return service.addCharacteristic(characteristic)
    }
}