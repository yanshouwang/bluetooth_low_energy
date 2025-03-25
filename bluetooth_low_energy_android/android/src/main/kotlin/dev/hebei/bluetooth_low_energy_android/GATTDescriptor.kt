package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattDescriptor
import java.util.UUID

class GATTDescriptor : GATTAttribute {
    companion object {
        val CLIENT_CHARACTERISTIC_CONFIG: UUID get() = UUID.fromString("00002902-0000-1000-8000-00805f9b34fb")

        val ENABLE_NOTIFICATION_VALUE: ByteArray get() = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
        val ENABLE_INDICATION_VALUE: ByteArray get() = BluetoothGattDescriptor.ENABLE_INDICATION_VALUE
        val DISABLE_NOTIFICATION_VALUE: ByteArray get() = BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
    }

    internal val obj: BluetoothGattDescriptor

    constructor(uuid: UUID, permissions: List<GATTPermission>) {
        val permissionsObj = permissions.fold(0) { total, next -> total or next.descriptorObj }
        this.obj = BluetoothGattDescriptor(uuid, permissionsObj)
    }

    internal constructor(gatt: BluetoothGatt, obj: BluetoothGattDescriptor) : super(gatt) {
        this.obj = obj
    }

    override val uuid: UUID get() = obj.uuid
    override val instanceId: Int
        get() {
            try {
                val clazz = obj.javaClass
                val method = clazz.getMethod("getInstanceId")
                return method.invoke(obj) as Int
            } catch (e: Exception) {
                return hashCode()
            }
        }

    override fun equals(other: Any?): Boolean {
        if (other === this) return true
        return other is GATTDescriptor && other.obj == obj
    }

    override fun hashCode(): Int {
        return obj.hashCode()
    }
}
