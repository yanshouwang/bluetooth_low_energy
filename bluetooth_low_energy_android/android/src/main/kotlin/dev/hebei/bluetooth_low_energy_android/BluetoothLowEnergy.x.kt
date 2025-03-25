package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothProfile
import android.bluetooth.le.ScanResult
import android.os.Build
import android.util.SparseArray

val Int.stateWrapper: BluetoothLowEnergyState
    get() = when (this) {
        BluetoothAdapter.STATE_OFF -> BluetoothLowEnergyState.OFF
        BluetoothAdapter.STATE_TURNING_ON -> BluetoothLowEnergyState.TURNING_ON
        BluetoothAdapter.STATE_ON -> BluetoothLowEnergyState.ON
        BluetoothAdapter.STATE_TURNING_OFF -> BluetoothLowEnergyState.OFF
        else -> throw IllegalArgumentException("Illegal bluetooth low energy state: $this")
    }

val Int.connectionStateWrapper: ConnectionState
    get() = when (this) {
        BluetoothProfile.STATE_DISCONNECTED -> ConnectionState.DISCONNECTED
        BluetoothProfile.STATE_CONNECTING -> ConnectionState.CONNECTING
        BluetoothProfile.STATE_CONNECTED -> ConnectionState.CONNECTED
        BluetoothProfile.STATE_DISCONNECTING -> ConnectionState.DISCONNECTING
        else -> throw IllegalArgumentException("Illegal connection state: $this")
    }

val Int.propertiesWrapper: List<GATTCharacteristicProperty>
    get() {
        val properties = mutableListOf<GATTCharacteristicProperty>()
        if (this and BluetoothGattCharacteristic.PROPERTY_READ != 0) {
            properties.add(GATTCharacteristicProperty.READ)
        }
        if (this and BluetoothGattCharacteristic.PROPERTY_WRITE != 0) {
            properties.add(GATTCharacteristicProperty.WRITE)
        }
        if (this and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0) {
            properties.add(GATTCharacteristicProperty.WRITE_WITHOUT_RESPONSE)
        }
        if (this and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0) {
            properties.add(GATTCharacteristicProperty.NOTIFY)
        }
        if (this and BluetoothGattCharacteristic.PROPERTY_INDICATE != 0) {
            properties.add(GATTCharacteristicProperty.INDICATE)
        }
        return properties
    }

val SparseArray<ByteArray>.manufacturerSpecificDataWrapper: List<ManufacturerSpecificData>
    get() {
        var index = 0
        val size = size()
        val items = mutableListOf<ManufacturerSpecificData>()
        while (index < size) {
            val id = keyAt(index)
            val data = valueAt(index)
            val item = ManufacturerSpecificData(id, data)
            items.add(item)
            index++
        }
        return items
    }

val ScanResult.advertisementWrapper: Advertisement
    get() {
        val record = scanRecord
        return if (record == null) Advertisement()
        else Advertisement(record)
    }

val ConnectionPriority.obj: Int
    get() = when (this) {
        ConnectionPriority.BALANCED -> BluetoothGatt.CONNECTION_PRIORITY_BALANCED
        ConnectionPriority.HIGH -> BluetoothGatt.CONNECTION_PRIORITY_HIGH
        ConnectionPriority.LOW_POWER -> BluetoothGatt.CONNECTION_PRIORITY_LOW_POWER
        ConnectionPriority.DCK -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) BluetoothGatt.CONNECTION_PRIORITY_DCK
        else throw IllegalArgumentException("ConnectionPriority.DCK is not available before API 34")
    }

val GATTPermission.descriptorObj: Int
    get() = when (this) {
        GATTPermission.READ -> BluetoothGattDescriptor.PERMISSION_READ
        GATTPermission.READ_ENCRYPTED -> BluetoothGattDescriptor.PERMISSION_READ_ENCRYPTED
        GATTPermission.WRITE -> BluetoothGattDescriptor.PERMISSION_WRITE
        GATTPermission.WRITE_ENCRYPTED -> BluetoothGattDescriptor.PERMISSION_WRITE_ENCRYPTED
    }

val GATTPermission.characteristicObj: Int
    get() = when (this) {
        GATTPermission.READ -> BluetoothGattCharacteristic.PERMISSION_READ
        GATTPermission.READ_ENCRYPTED -> BluetoothGattCharacteristic.PERMISSION_READ_ENCRYPTED
        GATTPermission.WRITE -> BluetoothGattCharacteristic.PERMISSION_WRITE
        GATTPermission.WRITE_ENCRYPTED -> BluetoothGattCharacteristic.PERMISSION_WRITE_ENCRYPTED
    }

val GATTCharacteristicProperty.obj: Int
    get() = when (this) {
        GATTCharacteristicProperty.READ -> BluetoothGattCharacteristic.PROPERTY_READ
        GATTCharacteristicProperty.WRITE -> BluetoothGattCharacteristic.PROPERTY_WRITE
        GATTCharacteristicProperty.WRITE_WITHOUT_RESPONSE -> BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE
        GATTCharacteristicProperty.NOTIFY -> BluetoothGattCharacteristic.PROPERTY_NOTIFY
        GATTCharacteristicProperty.INDICATE -> BluetoothGattCharacteristic.PROPERTY_INDICATE
    }

val GATTCharacteristicWriteType.obj: Int
    get() = when (this) {
        GATTCharacteristicWriteType.WITH_RESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
        GATTCharacteristicWriteType.WITHOUT_RESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
    }
