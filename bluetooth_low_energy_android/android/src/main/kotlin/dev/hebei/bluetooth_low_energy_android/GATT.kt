package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattService
import java.util.UUID

abstract class GATTAttribute {
    private val gatt: BluetoothGatt?
    abstract val uuid: UUID

    internal val gattNotNull get() = gatt ?: throw NullPointerException("gatt is null")

    constructor() {
        this.gatt = null
    }

    internal constructor(gatt: BluetoothGatt) {
        this.gatt = gatt
    }
}

class GATTDescriptor : GATTAttribute {
    internal val obj: BluetoothGattDescriptor

    constructor(uuid: UUID, permissions: List<GATTPermission>) {
        this.obj = BluetoothGattDescriptor(uuid, permissions.descriptorObj)
    }

    internal constructor(gatt: BluetoothGatt, obj: BluetoothGattDescriptor) : super(gatt) {
        this.obj = obj
    }

    override val uuid: UUID get() = obj.uuid

    override fun equals(other: Any?): Boolean {
        if (other === this) return true
        return other is GATTDescriptor && other.obj == obj
    }

    override fun hashCode(): Int {
        return obj.hashCode()
    }
}

class GATTCharacteristic : GATTAttribute {
    internal val obj: BluetoothGattCharacteristic

    constructor(
        uuid: UUID,
        properties: List<GATTCharacteristicProperty>,
        permissions: List<GATTPermission>,
        descriptors: List<GATTDescriptor>
    ) {
        this.obj = BluetoothGattCharacteristic(uuid, properties.obj, permissions.characteristicObj).apply {
            for (descriptor in descriptors) {
                addDescriptor(descriptor.obj)
            }
        }
    }

    internal constructor(gatt: BluetoothGatt, obj: BluetoothGattCharacteristic) : super(gatt) {
        this.obj = obj
    }

    override val uuid: UUID get() = obj.uuid
    val properties: List<GATTCharacteristicProperty> get() = obj.propertiesArgs
    val descriptors: List<GATTDescriptor> get() = obj.descriptors.map { GATTDescriptor(gattNotNull, it) }

    override fun equals(other: Any?): Boolean {
        if (other === this) return true
        return other is GATTCharacteristic && other.obj == obj
    }

    override fun hashCode(): Int {
        return obj.hashCode()
    }
}

class GATTService : GATTAttribute {
    internal val obj: BluetoothGattService

    constructor(
        uuid: UUID, isPrimary: Boolean, includedServices: List<GATTService>, characteristics: List<GATTCharacteristic>
    ) {
        val serviceType = if (isPrimary) BluetoothGattService.SERVICE_TYPE_PRIMARY
        else BluetoothGattService.SERVICE_TYPE_SECONDARY
        this.obj = BluetoothGattService(uuid, serviceType).apply {
            for (includedService in includedServices) {
                addService(includedService.obj)
            }
            for (characteristic in characteristics) {
                addCharacteristic(characteristic.obj)
            }
        }
    }

    internal constructor(gatt: BluetoothGatt, obj: BluetoothGattService) : super(gatt) {
        this.obj = obj
    }

    override val uuid: UUID get() = obj.uuid
    val isPrimary: Boolean get() = obj.type == BluetoothGattService.SERVICE_TYPE_PRIMARY
    val includedService: List<GATTService> get() = obj.includedServices.map { GATTService(gattNotNull, it) }
    val characteristics: List<GATTCharacteristic>
        get() = obj.characteristics.map { GATTCharacteristic(gattNotNull, it) }

    override fun equals(other: Any?): Boolean {
        if (other === this) return true
        return other is GATTService && other.obj == obj
    }

    override fun hashCode(): Int {
        return obj.hashCode()
    }
}

enum class GATTPermission {
    READ, READ_ENCRYPTED, WRITE, WRITE_ENCRYPTED,
}

enum class GATTCharacteristicProperty {
    READ, WRITE, WRITE_WITHOUT_RESPONSE, NOTIFY, INDICATE,
}

enum class GATTCharacteristicWriteType {
    WITH_RESPONSE, WITHOUT_RESPONSE,
}
