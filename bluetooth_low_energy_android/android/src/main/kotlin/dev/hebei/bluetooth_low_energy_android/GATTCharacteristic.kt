package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import java.util.UUID

class GATTCharacteristic : GATTAttribute {
    internal val obj: BluetoothGattCharacteristic

    constructor(
        uuid: UUID,
        properties: List<GATTCharacteristicProperty>,
        permissions: List<GATTPermission>,
        descriptors: List<GATTDescriptor>
    ) {
        val propertiesObj = properties.fold(0) { total, next -> total or next.obj }
        val permissionsObj = permissions.fold(0) { total, next -> total or next.characteristicObj }
        this.obj = BluetoothGattCharacteristic(uuid, propertiesObj, permissionsObj).apply {
            for (descriptor in descriptors) {
                addDescriptor(descriptor.obj)
            }
        }
    }

    internal constructor(gatt: BluetoothGatt, obj: BluetoothGattCharacteristic) : super(gatt) {
        this.obj = obj
    }

    override val uuid: UUID get() = obj.uuid
    override val instanceId: Int get() = obj.instanceId
    val properties: List<GATTCharacteristicProperty> get() = obj.properties.propertiesWrapper
    val descriptors: List<GATTDescriptor> get() = obj.descriptors.map { GATTDescriptor(gattNotNull, it) }

    fun getDescriptor(uuid: UUID): GATTDescriptor {
        val descriptorObj = obj.getDescriptor(uuid)
        return GATTDescriptor(gattNotNull, descriptorObj)
    }

    override fun equals(other: Any?): Boolean {
        if (other === this) return true
        return other is GATTCharacteristic && other.obj == obj
    }

    override fun hashCode(): Int {
        return obj.hashCode()
    }
}
