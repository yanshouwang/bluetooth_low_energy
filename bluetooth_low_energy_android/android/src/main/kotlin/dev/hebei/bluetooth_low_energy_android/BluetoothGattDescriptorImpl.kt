package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import java.util.*

class BluetoothGattDescriptorImpl(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiBluetoothGattDescriptor(registrar) {
    override fun pigeon_defaultConstructor(uuid: UUID, permissions: Long): BluetoothGattDescriptor {
        return BluetoothGattDescriptor(uuid, permissions.toInt())
    }

    override fun getCharacteristic(pigeon_instance: BluetoothGattDescriptor): BluetoothGattCharacteristic {
        return pigeon_instance.characteristic
    }

    override fun getPermissions(pigeon_instance: BluetoothGattDescriptor): Long {
        return pigeon_instance.permissions.toLong()
    }

    override fun getUuid(pigeon_instance: BluetoothGattDescriptor): UUID {
        return pigeon_instance.uuid
    }

    override fun disableNotificationValue(): ByteArray {
        return BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
    }

    override fun enableIndicationValue(): ByteArray {
        return BluetoothGattDescriptor.ENABLE_INDICATION_VALUE
    }

    override fun enableNotificationValue(): ByteArray {
        return BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
    }
}