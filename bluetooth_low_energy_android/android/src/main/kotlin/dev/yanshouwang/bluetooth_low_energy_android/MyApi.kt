package dev.yanshouwang.bluetooth_low_energy_android

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattService
import android.bluetooth.le.ScanRecord
import android.bluetooth.le.ScanResult
import android.util.SparseArray
import java.util.UUID

val Any.TAG get() = this::class.java.simpleName as String

val BluetoothAdapter.myStateArgs: MyBluetoothLowEnergyStateArgs
    get() = state.toMyCentralStateArgs()

fun Int.toMyCentralStateArgs(): MyBluetoothLowEnergyStateArgs {
    return when (this) {
        BluetoothAdapter.STATE_ON -> MyBluetoothLowEnergyStateArgs.POWEREDON
        else -> MyBluetoothLowEnergyStateArgs.POWEREDOFF
    }
}

fun BluetoothDevice.toMyPeripheralArgs(): MyPeripheralArgs {
    val key = hashCode().toLong()
    val uuid = this.uuid.toString()
    return MyPeripheralArgs(key, uuid)
}

fun BluetoothDevice.toMyCentralArgs(): MyCentralArgs {
    val key = hashCode().toLong()
    val uuid = this.uuid.toString()
    return MyCentralArgs(key, uuid)
}

val BluetoothDevice.uuid: UUID
    get() {
        val node = address.filter { char -> char != ':' }
        // We don't know the timestamp of the bluetooth device, use nil UUID as prefix.
        return UUID.fromString("00000000-0000-0000-0000-$node")
    }

val ScanResult.myAdvertisementArgs: MyAdvertisementArgs
    get() {
        val record = scanRecord
        return if (record == null) {
            val name = null
            val manufacturerSpecificData = emptyMap<Long?, ByteArray?>()
            val serviceUUIDs = emptyList<String?>()
            val serviceData = emptyMap<String?, ByteArray>()
            MyAdvertisementArgs(name, manufacturerSpecificData, serviceUUIDs, serviceData)
        } else {
            val name = record.deviceName
            val manufacturerSpecificData = record.manufacturerSpecificData.toMyArgs()
            val serviceUUIDs = record.serviceUuids?.map { uuid -> uuid.toString() } ?: emptyList()
            val pairs = record.serviceData.map { (uuid, value) ->
                val key = uuid.toString()
                return@map Pair(key, value)
            }.toTypedArray()
            val serviceData = mapOf<String?, ByteArray?>(*pairs)
            MyAdvertisementArgs(name, manufacturerSpecificData, serviceUUIDs, serviceData)
        }
    }

fun SparseArray<ByteArray>.toMyArgs(): Map<Long?, ByteArray?> {
    var index = 0
    val size = size()
    val values = mutableMapOf<Long?, ByteArray>()
    while (index < size) {
        val key = keyAt(index).toLong()
        val value = valueAt(index)
        values[key] = value
        index++
    }
    return values
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

fun BluetoothGattService.toMyArgs(myCharacteristicArgses: List<MyGattCharacteristicArgs>): MyGattServiceArgs {
    val key = hashCode().toLong()
    val uuidValue = this.uuid.toString()
    return MyGattServiceArgs(key, uuidValue, myCharacteristicArgses)
}

fun BluetoothGattCharacteristic.toMyArgs(myDescriptorArgses: List<MyGattDescriptorArgs>): MyGattCharacteristicArgs {
    val key = hashCode().toLong()
    val uuidValue = this.uuid.toString()
    return MyGattCharacteristicArgs(key, uuidValue, myDescriptorArgses, myPropertyNumbers)
}

val BluetoothGattCharacteristic.myPropertyNumbers: List<Long>
    get() {
        val numbers = mutableListOf<Long>()
        if (properties and BluetoothGattCharacteristic.PROPERTY_READ != 0) {
            val number = MyGattCharacteristicPropertyArgs.READ.raw.toLong()
            numbers.add(number)
        }
        if (properties and BluetoothGattCharacteristic.PROPERTY_WRITE != 0) {
            val number = MyGattCharacteristicPropertyArgs.WRITE.raw.toLong()
            numbers.add(number)
        }
        if (properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0) {
            val number = MyGattCharacteristicPropertyArgs.WRITEWITHOUTRESPONSE.raw.toLong()
            numbers.add(number)
        }
        if (properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0) {
            val number = MyGattCharacteristicPropertyArgs.NOTIFY.raw.toLong()
            numbers.add(number)
        }
        if (properties and BluetoothGattCharacteristic.PROPERTY_INDICATE != 0) {
            val number = MyGattCharacteristicPropertyArgs.INDICATE.raw.toLong()
            numbers.add(number)
        }
        return numbers
    }

fun BluetoothGattDescriptor.toMyArgs(): MyGattDescriptorArgs {
    val key = hashCode().toLong()
    val uuid = this.uuid.toString()
    return MyGattDescriptorArgs(key, uuid)
}

fun MyCustomizedGattServiceArgs.toService(): BluetoothGattService {
    val uuid = UUID.fromString(myUUID)
    val serviceType = BluetoothGattService.SERVICE_TYPE_PRIMARY
    return BluetoothGattService(uuid, serviceType)
}

fun MyCustomizedGattCharacteristicArgs.toCharacteristic(): BluetoothGattCharacteristic {
    val uuid = UUID.fromString(myUUID)
    return BluetoothGattCharacteristic(uuid, properties, permissions)
}

val MyCustomizedGattCharacteristicArgs.properties: Int
    get() {
        val myProperties = myPropertyNumbers.filterNotNull().map { number ->
            val raw = number.toInt()
            MyGattCharacteristicPropertyArgs.ofRaw(raw)
        }
        val read = myProperties.contains(MyGattCharacteristicPropertyArgs.READ)
        val write = myProperties.contains(MyGattCharacteristicPropertyArgs.WRITE)
        val writeWithoutResponse = myProperties.contains(MyGattCharacteristicPropertyArgs.WRITEWITHOUTRESPONSE)
        val notify = myProperties.contains(MyGattCharacteristicPropertyArgs.NOTIFY)
        val indicate = myProperties.contains(MyGattCharacteristicPropertyArgs.INDICATE)
        var value = 0
        if (read) value = value or BluetoothGattCharacteristic.PROPERTY_READ
        if (write) value = value or BluetoothGattCharacteristic.PROPERTY_WRITE
        if (writeWithoutResponse) value = value or BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE
        if (notify) value = value or BluetoothGattCharacteristic.PROPERTY_NOTIFY
        if (indicate) value = value or BluetoothGattCharacteristic.PROPERTY_INDICATE
        return value
    }

val MyCustomizedGattCharacteristicArgs.permissions: Int
    get() {
        val myProperties = myPropertyNumbers.filterNotNull().map { number ->
            val raw = number.toInt()
            MyGattCharacteristicPropertyArgs.ofRaw(raw)
        }
        val read = myProperties.contains(MyGattCharacteristicPropertyArgs.READ)
        val write = myProperties.contains(MyGattCharacteristicPropertyArgs.WRITE)
        val writeWithoutResponse = myProperties.contains(MyGattCharacteristicPropertyArgs.WRITEWITHOUTRESPONSE)
        var value = 0
        if (read) value = value or BluetoothGattCharacteristic.PERMISSION_READ
        if (write || writeWithoutResponse) value = value or BluetoothGattCharacteristic.PERMISSION_WRITE
        return value
    }

fun MyCustomizedGattDescriptorArgs.toDescriptor(): BluetoothGattDescriptor {
    val uuid = UUID.fromString(myUUID)
    val permissions = BluetoothGattDescriptor.PERMISSION_READ or BluetoothGattDescriptor.PERMISSION_WRITE
    return BluetoothGattDescriptor(uuid, permissions)
}

fun Long.toMyGattCharacteristicTypeArgs(): MyGattCharacteristicWriteTypeArgs {
    val raw = toInt()
    return MyGattCharacteristicWriteTypeArgs.ofRaw(raw) ?: throw IllegalArgumentException()
}

fun MyGattCharacteristicWriteTypeArgs.toType(): Int {
    return when (this) {
        MyGattCharacteristicWriteTypeArgs.WITHRESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
        MyGattCharacteristicWriteTypeArgs.WITHOUTRESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
    }
}