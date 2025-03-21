package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattService
import android.bluetooth.BluetoothProfile
import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.AdvertiseSettings
import android.bluetooth.le.ScanResult
import android.os.Build
import android.os.ParcelUuid
import android.util.SparseArray
import java.util.UUID

//region ToObject
fun MyAdvertiseModeArgs.toAdvertiseMode(): Int {
    return when (this) {
        MyAdvertiseModeArgs.LOW_POWER -> AdvertiseSettings.ADVERTISE_MODE_LOW_POWER
        MyAdvertiseModeArgs.BALANCED -> AdvertiseSettings.ADVERTISE_MODE_BALANCED
        MyAdvertiseModeArgs.LOW_LATENCY -> AdvertiseSettings.ADVERTISE_MODE_LOW_LATENCY
    }
}

fun MyTXPowerLevelArgs.toTXPowerLevel(): Int {
    return when (this) {
        MyTXPowerLevelArgs.ULTRA_LOW -> AdvertiseSettings.ADVERTISE_TX_POWER_ULTRA_LOW
        MyTXPowerLevelArgs.LOW -> AdvertiseSettings.ADVERTISE_TX_POWER_LOW
        MyTXPowerLevelArgs.MEDIUM -> AdvertiseSettings.ADVERTISE_TX_POWER_MEDIUM
        MyTXPowerLevelArgs.HIGH -> AdvertiseSettings.ADVERTISE_TX_POWER_HIGH
    }
}

fun MyGATTCharacteristicWriteTypeArgs.toType(): Int {
    return when (this) {
        MyGATTCharacteristicWriteTypeArgs.WITH_RESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
        MyGATTCharacteristicWriteTypeArgs.WITHOUT_RESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
    }
}

fun MyGATTStatusArgs.toStatus(): Int {
    return when (this) {
        MyGATTStatusArgs.SUCCESS -> BluetoothGatt.GATT_SUCCESS
        MyGATTStatusArgs.READ_NOT_PERMITTED -> BluetoothGatt.GATT_READ_NOT_PERMITTED
        MyGATTStatusArgs.WRITE_NOT_PERMITTED -> BluetoothGatt.GATT_WRITE_NOT_PERMITTED
        MyGATTStatusArgs.INSUFFICIENT_AUTHENTICATION -> BluetoothGatt.GATT_INSUFFICIENT_AUTHENTICATION
        MyGATTStatusArgs.REQUEST_NOT_SUPPORTED -> BluetoothGatt.GATT_REQUEST_NOT_SUPPORTED
        MyGATTStatusArgs.INSUFFICIENT_ENCRYPTION -> BluetoothGatt.GATT_INSUFFICIENT_ENCRYPTION
        MyGATTStatusArgs.INVALID_OFFSET -> BluetoothGatt.GATT_INVALID_OFFSET
        MyGATTStatusArgs.INSUFFICIENT_AUTHORIZATION -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) BluetoothGatt.GATT_INSUFFICIENT_AUTHORIZATION
        else BluetoothGatt.GATT_FAILURE
        MyGATTStatusArgs.INVALID_ATTRIBUTE_LENGTH -> BluetoothGatt.GATT_INVALID_ATTRIBUTE_LENGTH
        MyGATTStatusArgs.CONNECTION_CONGESTED -> BluetoothGatt.GATT_CONNECTION_CONGESTED
        MyGATTStatusArgs.FAILURE -> BluetoothGatt.GATT_FAILURE
    }
}

fun MyAdvertiseSettingsArgs.toAdvertiseSettings(): AdvertiseSettings {
    val builder = AdvertiseSettings.Builder()
    val modeArgs = this.modeArgs
    if (modeArgs != null) {
        val mode = modeArgs.toAdvertiseMode()
        builder.setAdvertiseMode(mode)
    }
    val connectableArgs = this.connectableArgs
    if (connectableArgs != null) {
        builder.setConnectable(connectableArgs)
    }
    val timeoutArgs = this.timeoutArgs
    if (timeoutArgs != null) {
        val timeout = timeoutArgs.toInt()
        builder.setTimeout(timeout)
    }
    val txPowerLevelArgs = this.txPowerLevelArgs
    if (txPowerLevelArgs != null) {
        val txPowerLevel = txPowerLevelArgs.toTXPowerLevel()
        builder.setTxPowerLevel(txPowerLevel)
    }
    return builder.build()
}

fun MyAdvertiseDataArgs.toAdvertiseData(): AdvertiseData {
    val builder = AdvertiseData.Builder()
    val includeDeviceNameArgs = this.includeDeviceNameArgs
    if (includeDeviceNameArgs != null) {
        builder.setIncludeDeviceName(includeDeviceNameArgs)
    }
    val includeTXPowerLevelArgs = this.includeTXPowerLevelArgs
    if (includeTXPowerLevelArgs != null) {
        builder.setIncludeTxPowerLevel(includeTXPowerLevelArgs)
    }
    for (serviceUuidArgs in serviceUUIDsArgs) {
        val serviceUUID = ParcelUuid.fromString(serviceUuidArgs)
        builder.addServiceUuid(serviceUUID)
    }
    for (entry in serviceDataArgs) {
        val serviceDataUUID = ParcelUuid.fromString(entry.key as String)
        val serviceData = entry.value as ByteArray
        builder.addServiceData(serviceDataUUID, serviceData)
    }
    for (args in manufacturerSpecificDataArgs) {
        val itemArgs = args as MyManufacturerSpecificDataArgs
        val manufacturerId = itemArgs.idArgs.toInt()
        val manufacturerSpecificData = itemArgs.dataArgs
        builder.addManufacturerData(manufacturerId, manufacturerSpecificData)
    }
    return builder.build()
}

fun MyMutableGATTDescriptorArgs.toDescriptor(): BluetoothGattDescriptor {
    val uuid = UUID.fromString(uuidArgs)
    val permissions = BluetoothGattDescriptor.PERMISSION_READ or BluetoothGattDescriptor.PERMISSION_WRITE
    return BluetoothGattDescriptor(uuid, permissions)
}

fun MyMutableGATTCharacteristicArgs.toCharacteristic(): BluetoothGattCharacteristic {
    val uuid = UUID.fromString(uuidArgs)
    val properties = getProperties()
    val permissions = getPermissions()
    return BluetoothGattCharacteristic(uuid, properties, permissions)
}

fun MyMutableGATTCharacteristicArgs.getProperties(): Int {
    val propertiesArgs = propertyNumbersArgs.requireNoNulls().map { args ->
        val raw = args.toInt()
        MyGATTCharacteristicPropertyArgs.ofRaw(raw)
    }
    val read = propertiesArgs.contains(MyGATTCharacteristicPropertyArgs.READ)
    val write = propertiesArgs.contains(MyGATTCharacteristicPropertyArgs.WRITE)
    val writeWithoutResponse = propertiesArgs.contains(MyGATTCharacteristicPropertyArgs.WRITE_WITHOUT_RESPONSE)
    val notify = propertiesArgs.contains(MyGATTCharacteristicPropertyArgs.NOTIFY)
    val indicate = propertiesArgs.contains(MyGATTCharacteristicPropertyArgs.INDICATE)
    var properties = 0
    if (read) properties = properties or BluetoothGattCharacteristic.PROPERTY_READ
    if (write) properties = properties or BluetoothGattCharacteristic.PROPERTY_WRITE
    if (writeWithoutResponse) properties = properties or BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE
    if (notify) properties = properties or BluetoothGattCharacteristic.PROPERTY_NOTIFY
    if (indicate) properties = properties or BluetoothGattCharacteristic.PROPERTY_INDICATE
    return properties
}

fun MyMutableGATTCharacteristicArgs.getPermissions(): Int {
    val propertiesArgs = propertyNumbersArgs.requireNoNulls().map { args ->
        val raw = args.toInt()
        MyGATTCharacteristicPropertyArgs.ofRaw(raw)
    }
    val read = propertiesArgs.contains(MyGATTCharacteristicPropertyArgs.READ)
    val write = propertiesArgs.contains(MyGATTCharacteristicPropertyArgs.WRITE)
    val writeWithoutResponse = propertiesArgs.contains(MyGATTCharacteristicPropertyArgs.WRITE_WITHOUT_RESPONSE)
    var permissions = 0
    if (read) permissions = permissions or BluetoothGattCharacteristic.PERMISSION_READ
    if (write || writeWithoutResponse) permissions = permissions or BluetoothGattCharacteristic.PERMISSION_WRITE
    return permissions
}

fun MyMutableGATTServiceArgs.toService(): BluetoothGattService {
    val uuid = UUID.fromString(uuidArgs)
    val serviceType = if (isPrimaryArgs) BluetoothGattService.SERVICE_TYPE_PRIMARY
    else BluetoothGattService.SERVICE_TYPE_SECONDARY
    return BluetoothGattService(uuid, serviceType)
} //endregion

//region ToArgs
fun Int.toBluetoothLowEnergyStateArgs(): MyBluetoothLowEnergyStateArgs {
    return when (this) {
        BluetoothAdapter.STATE_OFF -> MyBluetoothLowEnergyStateArgs.OFF
        BluetoothAdapter.STATE_TURNING_ON -> MyBluetoothLowEnergyStateArgs.TURNING_ON
        BluetoothAdapter.STATE_ON -> MyBluetoothLowEnergyStateArgs.ON
        BluetoothAdapter.STATE_TURNING_OFF -> MyBluetoothLowEnergyStateArgs.TURNING_OFF
        else -> MyBluetoothLowEnergyStateArgs.UNKNOWN
    }
}

fun Int.toConnectionStateArgs(): MyConnectionStateArgs {
    return when (this) {
        BluetoothProfile.STATE_DISCONNECTED -> MyConnectionStateArgs.DISCONNECTED
        BluetoothProfile.STATE_CONNECTING -> MyConnectionStateArgs.CONNECTING
        BluetoothProfile.STATE_CONNECTED -> MyConnectionStateArgs.CONNECTED
        BluetoothProfile.STATE_DISCONNECTING -> MyConnectionStateArgs.DISCONNECTING
        else -> throw IllegalArgumentException()
    }
}

fun SparseArray<ByteArray>.toManufacturerSpecificDataArgs(): List<MyManufacturerSpecificDataArgs> {
    var index = 0
    val size = size()
    val itemsArgs = mutableListOf<MyManufacturerSpecificDataArgs>()
    while (index < size) {
        val idArgs = keyAt(index).toLong()
        val dataArgs = valueAt(index)
        val itemArgs = MyManufacturerSpecificDataArgs(idArgs, dataArgs)
        itemsArgs.add(itemArgs)
        index++
    }
    return itemsArgs
}

fun ScanResult.toAdvertisementArgs(): MyAdvertisementArgs {
    val record = scanRecord
    return if (record == null) {
        val nameArgs = null
        val serviceUUIDsArgs = emptyList<String?>()
        val serviceDataArgs = emptyMap<String?, ByteArray>()
        val manufacturerSpecificDataArgs = emptyList<MyManufacturerSpecificDataArgs>()
        MyAdvertisementArgs(nameArgs, serviceUUIDsArgs, serviceDataArgs, manufacturerSpecificDataArgs)
    } else {
        val nameArgs = record.deviceName
        val serviceUUIDsArgs = record.serviceUuids?.map { uuid -> uuid.toString() } ?: emptyList()
        val pairs = record.serviceData?.map { (uuid, value) ->
            val key = uuid.toString()
            return@map Pair(key, value)
        }?.toTypedArray() ?: emptyArray()
        val serviceDataArgs = mapOf<String?, ByteArray?>(*pairs)
        val manufacturerSpecificDataArgs = record.manufacturerSpecificData?.toManufacturerSpecificDataArgs() ?: emptyList()
        MyAdvertisementArgs(nameArgs, serviceUUIDsArgs, serviceDataArgs, manufacturerSpecificDataArgs)
    }
}

fun BluetoothDevice.toCentralArgs(): MyCentralArgs {
    val addressArgs = address
    return MyCentralArgs(addressArgs)
}

fun BluetoothDevice.toPeripheralArgs(): MyPeripheralArgs {
    val addressArgs = address
    return MyPeripheralArgs(addressArgs)
}

fun BluetoothGattDescriptor.toArgs(): MyGATTDescriptorArgs {
    val hashCodeArgs = hashCode().toLong()
    val uuidArgs = this.uuid.toString()
    return MyGATTDescriptorArgs(hashCodeArgs, uuidArgs)
}

fun BluetoothGattCharacteristic.getPropertyNumbersArgs(): List<Long> {
    val numbersArgs = mutableListOf<Long>()
    if (properties and BluetoothGattCharacteristic.PROPERTY_READ != 0) {
        val number = MyGATTCharacteristicPropertyArgs.READ.raw.toLong()
        numbersArgs.add(number)
    }
    if (properties and BluetoothGattCharacteristic.PROPERTY_WRITE != 0) {
        val number = MyGATTCharacteristicPropertyArgs.WRITE.raw.toLong()
        numbersArgs.add(number)
    }
    if (properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0) {
        val number = MyGATTCharacteristicPropertyArgs.WRITE_WITHOUT_RESPONSE.raw.toLong()
        numbersArgs.add(number)
    }
    if (properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0) {
        val number = MyGATTCharacteristicPropertyArgs.NOTIFY.raw.toLong()
        numbersArgs.add(number)
    }
    if (properties and BluetoothGattCharacteristic.PROPERTY_INDICATE != 0) {
        val number = MyGATTCharacteristicPropertyArgs.INDICATE.raw.toLong()
        numbersArgs.add(number)
    }
    return numbersArgs
}

fun BluetoothGattCharacteristic.toArgs(): MyGATTCharacteristicArgs {
    val hashCodeArgs = hashCode().toLong()
    val uuidArgs = this.uuid.toString()
    val propertyNumbersArgs = getPropertyNumbersArgs()
    val descriptorsArgs = descriptors.map { it.toArgs() }
    return MyGATTCharacteristicArgs(hashCodeArgs, uuidArgs, propertyNumbersArgs, descriptorsArgs)
}

fun BluetoothGattService.toArgs(): MyGATTServiceArgs {
    val hashCodeArgs = hashCode().toLong()
    val uuidArgs = uuid.toString()
    val isPrimaryArgs = type == BluetoothGattService.SERVICE_TYPE_PRIMARY
    val includedServicesArgs = includedServices.map { it.toArgs() }
    val characteristicsArgs = characteristics.map { it.toArgs() }
    return MyGATTServiceArgs(hashCodeArgs, uuidArgs, isPrimaryArgs, includedServicesArgs, characteristicsArgs)
} //endregion

//val Any.TAG get() = this::class.java.simpleName as String
//
//val ScanRecord.rawValues: Map<Byte, ByteArray>
//    get() {
//        val rawValues = mutableMapOf<Byte, ByteArray>()
//        var index = 0
//        val size = bytes.size
//        while (index < size) {
//            val length = bytes[index++].toInt() and 0xff
//            if (length == 0) {
//                break
//            }
//            val end = index + length
//            val type = bytes[index++]
//            val value = bytes.slice(index until end).toByteArray()
//            rawValues[type] = value
//            index = end
//        }
//        return rawValues.toMap()
//    }
