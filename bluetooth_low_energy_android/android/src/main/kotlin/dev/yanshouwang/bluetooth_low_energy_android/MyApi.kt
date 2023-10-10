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

val Any.TAG get() = this::class.java.simpleName as String

val BluetoothAdapter.stateArgs: MyBluetoothLowEnergyStateArgs
    get() = state.toBluetoothLowEnergyStateArgs()

fun Int.toBluetoothLowEnergyStateArgs(): MyBluetoothLowEnergyStateArgs {
    return when (this) {
        BluetoothAdapter.STATE_ON -> MyBluetoothLowEnergyStateArgs.POWEREDON
        else -> MyBluetoothLowEnergyStateArgs.POWEREDOFF
    }
}

fun BluetoothDevice.toPeripheralArgs(): MyPeripheralArgs {
    val hashCodeArgs = hashCode().toLong()
    val uuid = this.uuid.toString()
    return MyPeripheralArgs(hashCodeArgs, uuid)
}

fun BluetoothDevice.toCentralArgs(): MyCentralArgs {
    val hashCodeArgs = hashCode().toLong()
    val uuid = this.uuid.toString()
    return MyCentralArgs(hashCodeArgs, uuid)
}

val BluetoothDevice.uuid: UUID
    get() {
        val node = address.filter { char -> char != ':' }
        // We don't know the timestamp of the bluetooth device, use nil UUID as prefix.
        return UUID.fromString("00000000-0000-0000-0000-$node")
    }

val ScanResult.advertiseDataArgs: MyAdvertiseDataArgs
    get() {
        val record = scanRecord
        return if (record == null) {
            val nameArgs = null
            val serviceUUIDsArgs = emptyList<String?>()
            val serviceDataArgs = emptyMap<String?, ByteArray>()
            val manufacturerSpecificDataArgs = null
            MyAdvertiseDataArgs(nameArgs, serviceUUIDsArgs, serviceDataArgs, manufacturerSpecificDataArgs)
        } else {
            val nameArgs = record.deviceName
            val serviceUUIDsArgs = record.serviceUuids?.map { uuid -> uuid.toString() }
                    ?: emptyList()
            val pairs = record.serviceData.map { (uuid, value) ->
                val key = uuid.toString()
                return@map Pair(key, value)
            }.toTypedArray()
            val serviceDataArgs = mapOf<String?, ByteArray?>(*pairs)
            val manufacturerSpecificDataArgs = record.manufacturerSpecificData.toManufacturerSpecificDataArgs()
            MyAdvertiseDataArgs(nameArgs, serviceUUIDsArgs, serviceDataArgs, manufacturerSpecificDataArgs)
        }
    }

fun SparseArray<ByteArray>.toManufacturerSpecificDataArgs(): MyManufacturerSpecificDataArgs {
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
    return itemsArgs.last()
}

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

fun MyAdvertiseDataArgs.toAdvertiseData(adapter: BluetoothAdapter): AdvertiseData {
    val advertiseDataBuilder = AdvertiseData.Builder()
    if (nameArgs == null) {
        advertiseDataBuilder.setIncludeDeviceName(false)
    } else {
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

fun BluetoothGattService.toManufacturerSpecificDataArgs(characteristicsArgs: List<MyGattCharacteristicArgs>): MyGattServiceArgs {
    val hashCodeArgs = hashCode().toLong()
    val uuidArgs = this.uuid.toString()
    return MyGattServiceArgs(hashCodeArgs, uuidArgs, characteristicsArgs)
}

fun BluetoothGattCharacteristic.toManufacturerSpecificDataArgs(descriptorsArgs: List<MyGattDescriptorArgs>): MyGattCharacteristicArgs {
    val hashCodeArgs = hashCode().toLong()
    val uuidArgs = this.uuid.toString()
    return MyGattCharacteristicArgs(hashCodeArgs, uuidArgs, propertyNumbersArgs, descriptorsArgs)
}

val BluetoothGattCharacteristic.propertyNumbersArgs: List<Long>
    get() {
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
            val number = MyGattCharacteristicPropertyArgs.WRITEWITHOUTRESPONSE.raw.toLong()
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

fun BluetoothGattDescriptor.toManufacturerSpecificDataArgs(): MyGattDescriptorArgs {
    val hashCodeArgs = hashCode().toLong()
    val uuidArgs = this.uuid.toString()
    return MyGattDescriptorArgs(hashCodeArgs, uuidArgs, null)
}

fun MyGattServiceArgs.toService(): BluetoothGattService {
    val uuid = UUID.fromString(uuidArgs)
    val serviceType = BluetoothGattService.SERVICE_TYPE_PRIMARY
    return BluetoothGattService(uuid, serviceType)
}

fun MyGattCharacteristicArgs.toCharacteristic(): BluetoothGattCharacteristic {
    val uuid = UUID.fromString(uuidArgs)
    return BluetoothGattCharacteristic(uuid, properties, permissions)
}

val MyGattCharacteristicArgs.properties: Int
    get() {
        val propertiesArgs = propertyNumbersArgs.filterNotNull().map { args ->
            val raw = args.toInt()
            MyGattCharacteristicPropertyArgs.ofRaw(raw)
        }
        val read = propertiesArgs.contains(MyGattCharacteristicPropertyArgs.READ)
        val write = propertiesArgs.contains(MyGattCharacteristicPropertyArgs.WRITE)
        val writeWithoutResponse = propertiesArgs.contains(MyGattCharacteristicPropertyArgs.WRITEWITHOUTRESPONSE)
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

val MyGattCharacteristicArgs.permissions: Int
    get() {
        val propertiesArgs = propertyNumbersArgs.filterNotNull().map { args ->
            val raw = args.toInt()
            MyGattCharacteristicPropertyArgs.ofRaw(raw)
        }
        val read = propertiesArgs.contains(MyGattCharacteristicPropertyArgs.READ)
        val write = propertiesArgs.contains(MyGattCharacteristicPropertyArgs.WRITE)
        val writeWithoutResponse = propertiesArgs.contains(MyGattCharacteristicPropertyArgs.WRITEWITHOUTRESPONSE)
        var permissions = 0
        if (read) permissions = permissions or BluetoothGattCharacteristic.PERMISSION_READ
        if (write || writeWithoutResponse) permissions = permissions or BluetoothGattCharacteristic.PERMISSION_WRITE
        return permissions
    }

fun MyGattDescriptorArgs.toDescriptor(): BluetoothGattDescriptor {
    val uuid = UUID.fromString(uuidArgs)
    val permissions = BluetoothGattDescriptor.PERMISSION_READ or BluetoothGattDescriptor.PERMISSION_WRITE
    return BluetoothGattDescriptor(uuid, permissions)
}

fun Long.toWriteTypeArgs(): MyGattCharacteristicWriteTypeArgs {
    val raw = toInt()
    return MyGattCharacteristicWriteTypeArgs.ofRaw(raw) ?: throw IllegalArgumentException()
}

fun MyGattCharacteristicWriteTypeArgs.toType(): Int {
    return when (this) {
        MyGattCharacteristicWriteTypeArgs.WITHRESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
        MyGattCharacteristicWriteTypeArgs.WITHOUTRESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
    }
}