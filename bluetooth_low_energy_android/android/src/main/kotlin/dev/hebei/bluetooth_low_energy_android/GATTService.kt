package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattService
import java.util.UUID

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
    override val instanceId: Int get() = obj.instanceId
    val isPrimary: Boolean get() = obj.type == BluetoothGattService.SERVICE_TYPE_PRIMARY
    val includedServices: List<GATTService> get() = obj.includedServices.map { GATTService(gattNotNull, it) }
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
