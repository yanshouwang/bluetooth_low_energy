package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothProfile
import android.bluetooth.le.ScanResult
import android.os.Build
import android.util.SparseArray
import com.google.protobuf.kotlin.toByteString
import java.util.UUID

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

val ConnectionPriority.obj: Int
    get() = when (this) {
        ConnectionPriority.BALANCED -> BluetoothGatt.CONNECTION_PRIORITY_BALANCED
        ConnectionPriority.HIGH -> BluetoothGatt.CONNECTION_PRIORITY_HIGH
        ConnectionPriority.LOW_POWER -> BluetoothGatt.CONNECTION_PRIORITY_LOW_POWER
        ConnectionPriority.DCK -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) BluetoothGatt.CONNECTION_PRIORITY_DCK
        else throw IllegalArgumentException("ConnectionPriority.DCK is not available before API 34")
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

val GATTCharacteristicWriteType.obj: Int
    get() = when (this) {
        GATTCharacteristicWriteType.WITH_RESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
        GATTCharacteristicWriteType.WITHOUT_RESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
    }

val ConnectionPriorityApi.obj: ConnectionPriority
    get() = when (this) {
        ConnectionPriorityApi.BALANCED -> ConnectionPriority.BALANCED
        ConnectionPriorityApi.HIGH -> ConnectionPriority.HIGH
        ConnectionPriorityApi.LOW_POWER -> ConnectionPriority.LOW_POWER
        ConnectionPriorityApi.DCK -> ConnectionPriority.DCK
    }

val GATTCharacteristicWriteTypeApi.obj: GATTCharacteristicWriteType
    get() = when (this) {
        GATTCharacteristicWriteTypeApi.WITH_RESPONSE -> GATTCharacteristicWriteType.WITH_RESPONSE
        GATTCharacteristicWriteTypeApi.WITHOUT_RESPONSE -> GATTCharacteristicWriteType.WITHOUT_RESPONSE
    }

val BluetoothLowEnergyState.api: BluetoothLowEnergyStateApi
    get() = when (this) {
        BluetoothLowEnergyState.UNKNOWN -> BluetoothLowEnergyStateApi.UNKNOWN
        BluetoothLowEnergyState.UNSUPPORTED -> BluetoothLowEnergyStateApi.UNSUPPORTED
        BluetoothLowEnergyState.UNAUTHORIZED -> BluetoothLowEnergyStateApi.UNAUTHORIZED
        BluetoothLowEnergyState.OFF -> BluetoothLowEnergyStateApi.OFF
        BluetoothLowEnergyState.TURNING_ON -> BluetoothLowEnergyStateApi.TURNING_ON
        BluetoothLowEnergyState.ON -> BluetoothLowEnergyStateApi.ON
        BluetoothLowEnergyState.TURNING_OFF -> BluetoothLowEnergyStateApi.TURNING_OFF
    }

val Advertisement.api: AdvertisementApi
    get() = advertisementApi {
        if (this@api.name != null) {
            this.name = this@api.name
        }
        this.serviceUuids.addAll(this@api.serviceUUIDs.map { it.toString() })
        this.serviceData.putAll(this@api.serviceData.map { it.key.toString() to it.value.toByteString() }.toMap())
        this.manufacturerSpecificData.addAll(this@api.manufacturerSpecificData.map { it.api })
    }

val ManufacturerSpecificData.api: ManufacturerSpecificDataApi
    get() = manufacturerSpecificDataApi {
        this.id = this@api.id
        this.data = this@api.data.toByteString()
    }

val ConnectionState.api: ConnectionStateApi
    get() = when (this) {
        ConnectionState.DISCONNECTED -> ConnectionStateApi.DISCONNECTED
        ConnectionState.CONNECTING -> ConnectionStateApi.CONNECTING
        ConnectionState.CONNECTED -> ConnectionStateApi.CONNECTED
        ConnectionState.DISCONNECTING -> ConnectionStateApi.DISCONNECTING
    }

val GATTCharacteristicProperty.api: GATTCharacteristicPropertyApi
    get() = when (this) {
        GATTCharacteristicProperty.READ -> GATTCharacteristicPropertyApi.READ
        GATTCharacteristicProperty.WRITE -> GATTCharacteristicPropertyApi.WRITE
        GATTCharacteristicProperty.WRITE_WITHOUT_RESPONSE -> GATTCharacteristicPropertyApi.WRITE_WITHOUT_RESPONSE
        GATTCharacteristicProperty.NOTIFY -> GATTCharacteristicPropertyApi.NOTIFY
        GATTCharacteristicProperty.INDICATE -> GATTCharacteristicPropertyApi.INDICATE
    }