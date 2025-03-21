package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothProfile
import android.bluetooth.le.ScanResult
import android.util.SparseArray

val Int.bluetoothLowEnergyStateArgs: BluetoothLowEnergyState
    get() = when (this) {
        BluetoothAdapter.STATE_OFF -> BluetoothLowEnergyState.OFF
        BluetoothAdapter.STATE_TURNING_ON -> BluetoothLowEnergyState.TURNING_ON
        BluetoothAdapter.STATE_ON -> BluetoothLowEnergyState.ON
        BluetoothAdapter.STATE_TURNING_OFF -> BluetoothLowEnergyState.OFF
        else -> throw IllegalArgumentException("Illegal bluetooth low energy state: $this")
    }

val Int.connectionStateArgs: ConnectionState
    get() = when (this) {
        BluetoothProfile.STATE_DISCONNECTED -> ConnectionState.DISCONNECTED
        BluetoothProfile.STATE_CONNECTING -> ConnectionState.CONNECTING
        BluetoothProfile.STATE_CONNECTED -> ConnectionState.CONNECTED
        BluetoothProfile.STATE_DISCONNECTING -> ConnectionState.DISCONNECTING
        else -> throw IllegalArgumentException("Illegal connection state: $this")
    }

val ScanResult.advertisementArgs: Advertisement
    get() {
        val record = scanRecord
        return if (record == null) Advertisement()
        else Advertisement(record)
    }

val SparseArray<ByteArray>.manufacturerSpecificDataArgs: List<ManufacturerSpecificData>
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

val List<GATTPermission>.descriptorObj: Int get() = this.fold(0) { acc, permission -> acc or permission.descriptorObj }

val GATTPermission.descriptorObj: Int
    get() = when (this) {
        GATTPermission.READ -> BluetoothGattDescriptor.PERMISSION_READ
        GATTPermission.READ_ENCRYPTED -> BluetoothGattDescriptor.PERMISSION_READ_ENCRYPTED
        GATTPermission.WRITE -> BluetoothGattDescriptor.PERMISSION_WRITE
        GATTPermission.WRITE_ENCRYPTED -> BluetoothGattDescriptor.PERMISSION_WRITE_ENCRYPTED
    }

val List<GATTPermission>.characteristicObj: Int get() = fold(0) { acc, permission -> acc or permission.characteristicObj }

val GATTPermission.characteristicObj: Int
    get() = when (this) {
        GATTPermission.READ -> BluetoothGattCharacteristic.PERMISSION_READ
        GATTPermission.READ_ENCRYPTED -> BluetoothGattCharacteristic.PERMISSION_READ_ENCRYPTED
        GATTPermission.WRITE -> BluetoothGattCharacteristic.PERMISSION_WRITE
        GATTPermission.WRITE_ENCRYPTED -> BluetoothGattCharacteristic.PERMISSION_WRITE_ENCRYPTED
    }

val List<GATTCharacteristicProperty>.obj: Int get() = fold(0) { acc, property -> acc or property.obj }

val GATTCharacteristicProperty.obj: Int
    get() = when (this) {
        GATTCharacteristicProperty.READ -> BluetoothGattCharacteristic.PROPERTY_READ
        GATTCharacteristicProperty.WRITE -> BluetoothGattCharacteristic.PROPERTY_WRITE
        GATTCharacteristicProperty.WRITE_WITHOUT_RESPONSE -> BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE
        GATTCharacteristicProperty.NOTIFY -> BluetoothGattCharacteristic.PROPERTY_NOTIFY
        GATTCharacteristicProperty.INDICATE -> BluetoothGattCharacteristic.PROPERTY_INDICATE
    }

val BluetoothGattCharacteristic.propertiesArgs: List<GATTCharacteristicProperty>
    get() {
        val propertiesArgs = mutableListOf<GATTCharacteristicProperty>()
        if (properties and BluetoothGattCharacteristic.PROPERTY_READ != 0) {
            propertiesArgs.add(GATTCharacteristicProperty.READ)
        }
        if (properties and BluetoothGattCharacteristic.PROPERTY_WRITE != 0) {
            propertiesArgs.add(GATTCharacteristicProperty.WRITE)
        }
        if (properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0) {
            propertiesArgs.add(GATTCharacteristicProperty.WRITE_WITHOUT_RESPONSE)
        }
        if (properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0) {
            propertiesArgs.add(GATTCharacteristicProperty.NOTIFY)
        }
        if (properties and BluetoothGattCharacteristic.PROPERTY_INDICATE != 0) {
            propertiesArgs.add(GATTCharacteristicProperty.INDICATE)
        }
        return propertiesArgs
    }