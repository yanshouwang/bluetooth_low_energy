package dev.yanshouwang.bluetooth_low_energy_android

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattService
import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.ScanRecord
import android.bluetooth.le.ScanResult
import android.os.ParcelUuid
import android.util.SparseArray
import java.util.UUID

//region ToObject
fun MyGattCharacteristicWriteTypeArgs.toType(): Int {
    return when (this) {
        MyGattCharacteristicWriteTypeArgs.WITH_RESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
        MyGattCharacteristicWriteTypeArgs.WITHOUT_RESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
    }
}

fun MyGattCharacteristicNotifyStateArgs.toValue(): ByteArray {
    return when (this) {
        MyGattCharacteristicNotifyStateArgs.NONE -> BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
        MyGattCharacteristicNotifyStateArgs.NOTIFY -> BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
        MyGattCharacteristicNotifyStateArgs.INDICATE -> BluetoothGattDescriptor.ENABLE_INDICATION_VALUE
    }
}

fun MyAdvertisementArgs.toAdvertiseData(adapter: BluetoothAdapter): AdvertiseData {
    val advertiseDataBuilder = AdvertiseData.Builder()
    if (nameArgs == null) {
        advertiseDataBuilder.setIncludeDeviceName(false)
    } else {
        // TODO: There is an issue that Android will use the cached name before setName takes effect.
        // see https://stackoverflow.com/questions/8377558/change-the-android-bluetooth-device-name
        adapter.name = nameArgs
        advertiseDataBuilder.setIncludeDeviceName(true)
    }
    for (serviceUuidArgs in serviceUUIDsArgs) {
        val serviceUUID = ParcelUuid.fromString(serviceUuidArgs)
        advertiseDataBuilder.addServiceUuid(serviceUUID)
    }
    for (entry in serviceDataArgs) {
        val serviceDataUUID = ParcelUuid.fromString(entry.key as String)
        val serviceData = entry.value as ByteArray
        advertiseDataBuilder.addServiceData(serviceDataUUID, serviceData)
    }
    if (manufacturerSpecificDataArgs != null) {
        val manufacturerId = manufacturerSpecificDataArgs.idArgs.toInt()
        val manufacturerSpecificData = manufacturerSpecificDataArgs.dataArgs
        advertiseDataBuilder.addManufacturerData(manufacturerId, manufacturerSpecificData)
    }
    return advertiseDataBuilder.build()
}

fun MyGattDescriptorArgs.toDescriptor(): BluetoothGattDescriptor {
    val uuid = UUID.fromString(uuidArgs)
    val permissions = BluetoothGattDescriptor.PERMISSION_READ or BluetoothGattDescriptor.PERMISSION_WRITE
    return BluetoothGattDescriptor(uuid, permissions)
}

fun MyGattCharacteristicArgs.toCharacteristic(): BluetoothGattCharacteristic {
    val uuid = UUID.fromString(uuidArgs)
    val properties = getProperties()
    val permissions = getPermissions()
    return BluetoothGattCharacteristic(uuid, properties, permissions)
}

fun MyGattCharacteristicArgs.getProperties(): Int {
    val propertiesArgs = propertyNumbersArgs.filterNotNull().map { args ->
        val raw = args.toInt()
        MyGattCharacteristicPropertyArgs.ofRaw(raw)
    }
    val read = propertiesArgs.contains(MyGattCharacteristicPropertyArgs.READ)
    val write = propertiesArgs.contains(MyGattCharacteristicPropertyArgs.WRITE)
    val writeWithoutResponse = propertiesArgs.contains(MyGattCharacteristicPropertyArgs.WRITE_WITHOUT_RESPONSE)
    val notify = propertiesArgs.contains(MyGattCharacteristicPropertyArgs.NOTIFY)
    val indicate = propertiesArgs.contains(MyGattCharacteristicPropertyArgs.INDICATE)
    var properties = 0
    if (read) properties = properties or BluetoothGattCharacteristic.PROPERTY_READ
    if (write) properties = properties or BluetoothGattCharacteristic.PROPERTY_WRITE
    if (writeWithoutResponse) properties = properties or BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE
    if (notify) properties = properties or BluetoothGattCharacteristic.PROPERTY_NOTIFY
    if (indicate) properties = properties or BluetoothGattCharacteristic.PROPERTY_INDICATE
    return properties
}

fun MyGattCharacteristicArgs.getPermissions(): Int {
    val propertiesArgs = propertyNumbersArgs.filterNotNull().map { args ->
        val raw = args.toInt()
        MyGattCharacteristicPropertyArgs.ofRaw(raw)
    }
    val read = propertiesArgs.contains(MyGattCharacteristicPropertyArgs.READ)
    val write = propertiesArgs.contains(MyGattCharacteristicPropertyArgs.WRITE)
    val writeWithoutResponse = propertiesArgs.contains(MyGattCharacteristicPropertyArgs.WRITE_WITHOUT_RESPONSE)
    var permissions = 0
    if (read) permissions = permissions or BluetoothGattCharacteristic.PERMISSION_READ
    if (write || writeWithoutResponse) permissions = permissions or BluetoothGattCharacteristic.PERMISSION_WRITE
    return permissions
}

fun MyGattServiceArgs.toService(): BluetoothGattService {
    val uuid = UUID.fromString(uuidArgs)
    val serviceType = BluetoothGattService.SERVICE_TYPE_PRIMARY
    return BluetoothGattService(uuid, serviceType)
}
//endregion

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

fun SparseArray<ByteArray>.toManufacturerSpecificDataArgs(): MyManufacturerSpecificDataArgs? {
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
    return itemsArgs.lastOrNull()
}

fun ScanResult.toAdvertisementArgs(): MyAdvertisementArgs {
    val record = scanRecord
    return if (record == null) {
        val nameArgs = null
        val serviceUUIDsArgs = emptyList<String?>()
        val serviceDataArgs = emptyMap<String?, ByteArray>()
        val manufacturerSpecificDataArgs = null
        MyAdvertisementArgs(nameArgs, serviceUUIDsArgs, serviceDataArgs, manufacturerSpecificDataArgs)
    } else {
        val nameArgs = record.deviceName
        val serviceUUIDsArgs = record.serviceUuids?.map { uuid -> uuid.toString() } ?: emptyList()
        val pairs = record.serviceData?.map { (uuid, value) ->
            val key = uuid.toString()
            return@map Pair(key, value)
        }?.toTypedArray() ?: emptyArray()
        val serviceDataArgs = mapOf<String?, ByteArray?>(*pairs)
        val manufacturerSpecificDataArgs = record.manufacturerSpecificData?.toManufacturerSpecificDataArgs()
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

fun BluetoothGattService.toArgs(): MyGattServiceArgs {
    val hashCodeArgs = hashCode().toLong()
    val uuidArgs = this.uuid.toString()
    val characteristicsArgs = characteristics.map { it.toArgs() }
    return MyGattServiceArgs(hashCodeArgs, uuidArgs, characteristicsArgs)
}

fun BluetoothGattCharacteristic.toArgs(): MyGattCharacteristicArgs {
    val hashCodeArgs = hashCode().toLong()
    val uuidArgs = this.uuid.toString()
    val propertyNumbersArgs = getPropertyNumbersArgs()
    val descriptorsArgs = descriptors.map { it.toArgs() }
    return MyGattCharacteristicArgs(hashCodeArgs, uuidArgs, propertyNumbersArgs, descriptorsArgs)
}

fun BluetoothGattCharacteristic.getPropertyNumbersArgs(): List<Long> {
    val numbersArgs = mutableListOf<Long>()
    if (properties and BluetoothGattCharacteristic.PROPERTY_READ != 0) {
        val number = MyGattCharacteristicPropertyArgs.READ.raw.toLong()
        numbersArgs.add(number)
    }
    if (properties and BluetoothGattCharacteristic.PROPERTY_WRITE != 0) {
        val number = MyGattCharacteristicPropertyArgs.WRITE.raw.toLong()
        numbersArgs.add(number)
    }
    if (properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0) {
        val number = MyGattCharacteristicPropertyArgs.WRITE_WITHOUT_RESPONSE.raw.toLong()
        numbersArgs.add(number)
    }
    if (properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0) {
        val number = MyGattCharacteristicPropertyArgs.NOTIFY.raw.toLong()
        numbersArgs.add(number)
    }
    if (properties and BluetoothGattCharacteristic.PROPERTY_INDICATE != 0) {
        val number = MyGattCharacteristicPropertyArgs.INDICATE.raw.toLong()
        numbersArgs.add(number)
    }
    return numbersArgs
}

fun BluetoothGattDescriptor.toArgs(): MyGattDescriptorArgs {
    val hashCodeArgs = hashCode().toLong()
    val uuidArgs = this.uuid.toString()
    return MyGattDescriptorArgs(hashCodeArgs, uuidArgs, null)
}

fun ByteArray.toNotifyStateArgs(): MyGattCharacteristicNotifyStateArgs {
    return if (this contentEquals BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE) {
        MyGattCharacteristicNotifyStateArgs.NOTIFY
    } else if (this contentEquals BluetoothGattDescriptor.ENABLE_INDICATION_VALUE) {
        MyGattCharacteristicNotifyStateArgs.INDICATE
    } else if (this contentEquals BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE) {
        MyGattCharacteristicNotifyStateArgs.NONE
    } else {
        throw IllegalArgumentException()
    }
}
//endregion

val Any.TAG get() = this::class.java.simpleName as String

val ScanRecord.rawValues: Map<Byte, ByteArray>
    get() {
        val rawValues = mutableMapOf<Byte, ByteArray>()
        var index = 0
        val size = bytes.size
        while (index < size) {
            val length = bytes[index++].toInt() and 0xff
            if (length == 0) {
                break
            }
            val end = index + length
            val type = bytes[index++]
            val value = bytes.slice(index until end).toByteArray()
            rawValues[type] = value
            index = end
        }
        return rawValues.toMap()
    }
