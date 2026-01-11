package dev.zeekr.bluetooth_low_energy_android

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
import androidx.core.util.size

//region ToObject
fun AdvertiseModeArgs.toAdvertiseMode(): Int {
    return when (this) {
        AdvertiseModeArgs.LOW_POWER -> AdvertiseSettings.ADVERTISE_MODE_LOW_POWER
        AdvertiseModeArgs.BALANCED -> AdvertiseSettings.ADVERTISE_MODE_BALANCED
        AdvertiseModeArgs.LOW_LATENCY -> AdvertiseSettings.ADVERTISE_MODE_LOW_LATENCY
    }
}

fun TXPowerLevelArgs.toTXPowerLevel(): Int {
    return when (this) {
        TXPowerLevelArgs.ULTRA_LOW -> AdvertiseSettings.ADVERTISE_TX_POWER_ULTRA_LOW
        TXPowerLevelArgs.LOW -> AdvertiseSettings.ADVERTISE_TX_POWER_LOW
        TXPowerLevelArgs.MEDIUM -> AdvertiseSettings.ADVERTISE_TX_POWER_MEDIUM
        TXPowerLevelArgs.HIGH -> AdvertiseSettings.ADVERTISE_TX_POWER_HIGH
    }
}

fun GATTCharacteristicWriteTypeArgs.toType(): Int {
    return when (this) {
        GATTCharacteristicWriteTypeArgs.WITH_RESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
        GATTCharacteristicWriteTypeArgs.WITHOUT_RESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
    }
}

fun GATTStatusArgs.toStatus(): Int {
    return when (this) {
        GATTStatusArgs.SUCCESS -> BluetoothGatt.GATT_SUCCESS
        GATTStatusArgs.READ_NOT_PERMITTED -> BluetoothGatt.GATT_READ_NOT_PERMITTED
        GATTStatusArgs.WRITE_NOT_PERMITTED -> BluetoothGatt.GATT_WRITE_NOT_PERMITTED
        GATTStatusArgs.INSUFFICIENT_AUTHENTICATION -> BluetoothGatt.GATT_INSUFFICIENT_AUTHENTICATION
        GATTStatusArgs.REQUEST_NOT_SUPPORTED -> BluetoothGatt.GATT_REQUEST_NOT_SUPPORTED
        GATTStatusArgs.INSUFFICIENT_ENCRYPTION -> BluetoothGatt.GATT_INSUFFICIENT_ENCRYPTION
        GATTStatusArgs.INVALID_OFFSET -> BluetoothGatt.GATT_INVALID_OFFSET
        GATTStatusArgs.INSUFFICIENT_AUTHORIZATION -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) BluetoothGatt.GATT_INSUFFICIENT_AUTHORIZATION
        else BluetoothGatt.GATT_FAILURE

        GATTStatusArgs.INVALID_ATTRIBUTE_LENGTH -> BluetoothGatt.GATT_INVALID_ATTRIBUTE_LENGTH
        GATTStatusArgs.CONNECTION_CONGESTED -> BluetoothGatt.GATT_CONNECTION_CONGESTED
        GATTStatusArgs.FAILURE -> BluetoothGatt.GATT_FAILURE
    }
}

fun AdvertiseSettingsArgs.toAdvertiseSettings(): AdvertiseSettings {
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

fun AdvertiseDataArgs.toAdvertiseData(): AdvertiseData {
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
        val itemArgs = args as ManufacturerSpecificDataArgs
        val manufacturerId = itemArgs.idArgs.toInt()
        val manufacturerSpecificData = itemArgs.dataArgs
        builder.addManufacturerData(manufacturerId, manufacturerSpecificData)
    }
    return builder.build()
}

fun MutableGATTDescriptorArgs.toDescriptor(): BluetoothGattDescriptor {
    val uuid = UUID.fromString(uuidArgs)
    val permissions = BluetoothGattDescriptor.PERMISSION_READ or BluetoothGattDescriptor.PERMISSION_WRITE
    return BluetoothGattDescriptor(uuid, permissions)
}

fun MutableGATTCharacteristicArgs.toCharacteristic(): BluetoothGattCharacteristic {
    val uuid = UUID.fromString(uuidArgs)
    val properties = getProperties()
    val permissions = getPermissions()
    return BluetoothGattCharacteristic(uuid, properties, permissions)
}

fun MutableGATTCharacteristicArgs.getProperties(): Int {
    val propertiesArgs = propertyNumbersArgs.requireNoNulls().map { args ->
        val raw = args.toInt()
        GATTCharacteristicPropertyArgs.ofRaw(raw)
    }
    val read = propertiesArgs.contains(GATTCharacteristicPropertyArgs.READ)
    val write = propertiesArgs.contains(GATTCharacteristicPropertyArgs.WRITE)
    val writeWithoutResponse = propertiesArgs.contains(GATTCharacteristicPropertyArgs.WRITE_WITHOUT_RESPONSE)
    val notify = propertiesArgs.contains(GATTCharacteristicPropertyArgs.NOTIFY)
    val indicate = propertiesArgs.contains(GATTCharacteristicPropertyArgs.INDICATE)
    var properties = 0
    if (read) properties = properties or BluetoothGattCharacteristic.PROPERTY_READ
    if (write) properties = properties or BluetoothGattCharacteristic.PROPERTY_WRITE
    if (writeWithoutResponse) properties = properties or BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE
    if (notify) properties = properties or BluetoothGattCharacteristic.PROPERTY_NOTIFY
    if (indicate) properties = properties or BluetoothGattCharacteristic.PROPERTY_INDICATE
    return properties
}

fun MutableGATTCharacteristicArgs.getPermissions(): Int {
    val propertiesArgs = propertyNumbersArgs.requireNoNulls().map { args ->
        val raw = args.toInt()
        GATTCharacteristicPropertyArgs.ofRaw(raw)
    }
    val read = propertiesArgs.contains(GATTCharacteristicPropertyArgs.READ)
    val write = propertiesArgs.contains(GATTCharacteristicPropertyArgs.WRITE)
    val writeWithoutResponse = propertiesArgs.contains(GATTCharacteristicPropertyArgs.WRITE_WITHOUT_RESPONSE)
    var permissions = 0
    if (read) permissions = permissions or BluetoothGattCharacteristic.PERMISSION_READ
    if (write || writeWithoutResponse) permissions = permissions or BluetoothGattCharacteristic.PERMISSION_WRITE
    return permissions
}

fun MutableGATTServiceArgs.toService(): BluetoothGattService {
    val uuid = UUID.fromString(uuidArgs)
    val serviceType = if (isPrimaryArgs) BluetoothGattService.SERVICE_TYPE_PRIMARY
    else BluetoothGattService.SERVICE_TYPE_SECONDARY
    return BluetoothGattService(uuid, serviceType)
} //endregion

//region ToArgs
fun Int.toBluetoothLowEnergyStateArgs(): BluetoothLowEnergyStateArgs {
    return when (this) {
        BluetoothAdapter.STATE_OFF -> BluetoothLowEnergyStateArgs.OFF
        BluetoothAdapter.STATE_TURNING_ON -> BluetoothLowEnergyStateArgs.TURNING_ON
        BluetoothAdapter.STATE_ON -> BluetoothLowEnergyStateArgs.ON
        BluetoothAdapter.STATE_TURNING_OFF -> BluetoothLowEnergyStateArgs.TURNING_OFF
        else -> BluetoothLowEnergyStateArgs.UNKNOWN
    }
}

fun Int.toConnectionStateArgs(): ConnectionStateArgs {
    return when (this) {
        BluetoothProfile.STATE_DISCONNECTED -> ConnectionStateArgs.DISCONNECTED
        BluetoothProfile.STATE_CONNECTING -> ConnectionStateArgs.CONNECTING
        BluetoothProfile.STATE_CONNECTED -> ConnectionStateArgs.CONNECTED
        BluetoothProfile.STATE_DISCONNECTING -> ConnectionStateArgs.DISCONNECTING
        else -> throw IllegalArgumentException()
    }
}

fun SparseArray<ByteArray>.toManufacturerSpecificDataArgs(): List<ManufacturerSpecificDataArgs> {
    var index = 0
    val size = this.size
    val itemsArgs = mutableListOf<ManufacturerSpecificDataArgs>()
    while (index < size) {
        val idArgs = keyAt(index).toLong()
        val dataArgs = valueAt(index)
        val itemArgs = ManufacturerSpecificDataArgs(idArgs, dataArgs)
        itemsArgs.add(itemArgs)
        index++
    }
    return itemsArgs
}

fun ScanResult.toAdvertisementArgs(): AdvertisementArgs {
    val record = scanRecord
    return if (record == null) {
        val nameArgs = null
        val serviceUUIDsArgs = emptyList<String?>()
        val serviceDataArgs = emptyMap<String?, ByteArray>()
        val manufacturerSpecificDataArgs = emptyList<ManufacturerSpecificDataArgs>()
        AdvertisementArgs(nameArgs, serviceUUIDsArgs, serviceDataArgs, manufacturerSpecificDataArgs)
    } else {
        val nameArgs = record.deviceName
        val serviceUUIDsArgs = record.serviceUuids?.map { uuid -> uuid.toString() } ?: emptyList()
        val pairs = record.serviceData?.map { (uuid, value) ->
            val key = uuid.toString()
            return@map Pair(key, value)
        }?.toTypedArray() ?: emptyArray()
        val serviceDataArgs = mapOf<String?, ByteArray?>(*pairs)
        val manufacturerSpecificDataArgs =
            record.manufacturerSpecificData?.toManufacturerSpecificDataArgs() ?: emptyList()
        AdvertisementArgs(nameArgs, serviceUUIDsArgs, serviceDataArgs, manufacturerSpecificDataArgs)
    }
}

fun BluetoothDevice.toCentralArgs(): CentralArgs {
    val addressArgs = address
    return CentralArgs(addressArgs)
}

fun BluetoothDevice.toPeripheralArgs(): PeripheralArgs {
    val addressArgs = address
    return PeripheralArgs(addressArgs)
}

fun BluetoothGattDescriptor.toArgs(): GATTDescriptorArgs {
    val hashCodeArgs = hashCode().toLong()
    val uuidArgs = this.uuid.toString()
    return GATTDescriptorArgs(hashCodeArgs, uuidArgs)
}

fun BluetoothGattCharacteristic.getPropertyNumbersArgs(): List<Long> {
    val numbersArgs = mutableListOf<Long>()
    if (properties and BluetoothGattCharacteristic.PROPERTY_READ != 0) {
        val number = GATTCharacteristicPropertyArgs.READ.raw.toLong()
        numbersArgs.add(number)
    }
    if (properties and BluetoothGattCharacteristic.PROPERTY_WRITE != 0) {
        val number = GATTCharacteristicPropertyArgs.WRITE.raw.toLong()
        numbersArgs.add(number)
    }
    if (properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0) {
        val number = GATTCharacteristicPropertyArgs.WRITE_WITHOUT_RESPONSE.raw.toLong()
        numbersArgs.add(number)
    }
    if (properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0) {
        val number = GATTCharacteristicPropertyArgs.NOTIFY.raw.toLong()
        numbersArgs.add(number)
    }
    if (properties and BluetoothGattCharacteristic.PROPERTY_INDICATE != 0) {
        val number = GATTCharacteristicPropertyArgs.INDICATE.raw.toLong()
        numbersArgs.add(number)
    }
    return numbersArgs
}

fun BluetoothGattCharacteristic.toArgs(): GATTCharacteristicArgs {
    val hashCodeArgs = hashCode().toLong()
    val uuidArgs = this.uuid.toString()
    val propertyNumbersArgs = getPropertyNumbersArgs()
    val descriptorsArgs = descriptors.map { it.toArgs() }
    return GATTCharacteristicArgs(hashCodeArgs, uuidArgs, propertyNumbersArgs, descriptorsArgs)
}

fun BluetoothGattService.toArgs(): GATTServiceArgs {
    val hashCodeArgs = hashCode().toLong()
    val uuidArgs = uuid.toString()
    val isPrimaryArgs = type == BluetoothGattService.SERVICE_TYPE_PRIMARY
    val includedServicesArgs = includedServices.map { it.toArgs() }
    val characteristicsArgs = characteristics.map { it.toArgs() }
    return GATTServiceArgs(hashCodeArgs, uuidArgs, isPrimaryArgs, includedServicesArgs, characteristicsArgs)
} //endregion

val Any.hashCode get() = this.hashCode()
val Int.args get() = this.toLong()

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
