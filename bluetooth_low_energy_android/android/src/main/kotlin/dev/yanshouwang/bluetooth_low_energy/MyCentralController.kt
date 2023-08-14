package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattService
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothProfile
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Build
import android.util.SparseArray
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.BinaryMessenger
import java.util.UUID

class MyCentralController(private val context: Context, binaryMessenger: BinaryMessenger) : MyCentralControllerHostApi {
    companion object {
        //        const val DATA_TYPE_MANUFACTURER_SPECIFIC_DATA = 0xff.toByte()
        const val CLIENT_CHARACTERISTIC_CONFIG = "00002902-0000-1000-8000-00805f9b34fb"
    }

    private val manager = ContextCompat.getSystemService(context, BluetoothManager::class.java) as BluetoothManager
    private val adapter = manager.adapter
    private val scanner = adapter.bluetoothLeScanner
    private val executor = ContextCompat.getMainExecutor(context)

    private val myApi = MyCentralControllerFlutterApi(binaryMessenger)
    private val myReceiver = MyBroadcastReceiver(this)
    private val myScanCallback = MyScanCallback(this)
    private val myGattCallback = MyBluetoothGattCallback(this, executor)

    private val devices = mutableMapOf<Int, BluetoothDevice>()
    private val gatts = mutableMapOf<Int, BluetoothGatt>()
    private val services = mutableMapOf<Int, BluetoothGattService>()
    private val characteristics = mutableMapOf<Int, BluetoothGattCharacteristic>()
    private val descriptors = mutableMapOf<Int, BluetoothGattDescriptor>()

    private var isRegisteredReceiver = false
    private var isDiscovering = false

    private var startDiscoveryCallback: ((Result<Unit>) -> Unit)? = null
    private val connectCallbacks = mutableMapOf<Int, (Result<Unit>) -> Unit>()
    private val disconnectCallbacks = mutableMapOf<Int, (Result<Unit>) -> Unit>()
    private val discoverGattCallbacks = mutableMapOf<Int, (Result<Unit>) -> Unit>()
    private val readCharacteristicCallbacks = mutableMapOf<Int, (Result<ByteArray>) -> Unit>()
    private val writeCharacteristicCallbacks = mutableMapOf<Int, (Result<Unit>) -> Unit>()
    private val readDescriptorCallbacks = mutableMapOf<Int, (Result<ByteArray>) -> Unit>()
    private val writeDescriptorCallbacks = mutableMapOf<Int, (Result<Unit>) -> Unit>()

    override fun setUp(): MyCentralControllerArgs {
        val isAvailable = context.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
        val myStateArgs = if (isAvailable) {
            val permissions = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.BLUETOOTH_SCAN, android.Manifest.permission.BLUETOOTH_CONNECT)
            } else {
                arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION)
            }
            val isGranted = permissions.all { permission -> ContextCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED }
            if (isGranted) {
                registerReceiver()
                adapter.myStateArgs
            } else MyCentralStateArgs.UNAUTHORIZED
        } else MyCentralStateArgs.UNSUPPORTED
        val stateNumber = myStateArgs.raw.toLong()
        return MyCentralControllerArgs(stateNumber)
    }

    override fun tearDown() {
        if (isRegisteredReceiver) {
            unregisterReceiver()
        }
        if (isDiscovering) {
            stopDiscovery()
        }
        for (gatt in gatts.values) {
            gatt.disconnect()
            gatt.close()
        }
        devices.clear()
        gatts.clear()
        services.clear()
        characteristics.clear()
        descriptors.clear()
    }

    private fun registerReceiver() {
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        context.registerReceiver(myReceiver, filter)
        isRegisteredReceiver = true
    }

    private fun unregisterReceiver() {
        context.unregisterReceiver(myReceiver)
        isRegisteredReceiver = false
    }

    override fun startDiscovery(callback: (Result<Unit>) -> Unit) {
        try {
            val unfinishedCallback = startDiscoveryCallback
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val filters = emptyList<ScanFilter>()
            val settings = ScanSettings.Builder().setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY).build()
            scanner.startScan(filters, settings, myScanCallback)
            executor.execute {
                val finishedCallback = startDiscoveryCallback ?: return@execute
                startDiscoveryCallback = null
                finishedCallback(Result.success(Unit))
            }
            startDiscoveryCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun stopDiscovery() {
        scanner.stopScan(myScanCallback)
        isDiscovering = false
    }

    override fun connect(myPeripheralKey: Long, callback: (Result<Unit>) -> Unit) {
        try {
            val deviceKey = myPeripheralKey.toInt()
            val unfinishedCallback = connectCallbacks[deviceKey]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val device = devices[deviceKey] as BluetoothDevice
            val autoConnect = false
            gatts[deviceKey] = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val transport = BluetoothDevice.TRANSPORT_LE
                device.connectGatt(context, autoConnect, myGattCallback, transport)
            } else {
                device.connectGatt(context, autoConnect, myGattCallback)
            }
            connectCallbacks[deviceKey] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun disconnect(myPeripheralKey: Long, callback: (Result<Unit>) -> Unit) {
        try {
            val deviceKey = myPeripheralKey.toInt()
            val unfinishedCallback = disconnectCallbacks[deviceKey]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = gatts[deviceKey] as BluetoothGatt
            gatt.disconnect()
            disconnectCallbacks[deviceKey] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun discoverGATT(myPeripheralKey: Long, callback: (Result<Unit>) -> Unit) {
        try {
            val deviceKey = myPeripheralKey.toInt()
            val unfinishedCallback = discoverGattCallbacks[deviceKey]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = gatts[deviceKey] as BluetoothGatt
            val discovering = gatt.discoverServices()
            if (!discovering) {
                throw IllegalStateException()
            }
            discoverGattCallbacks[deviceKey] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun getServices(myPeripheralKey: Long): List<MyGattServiceArgs> {
        val deviceKey = myPeripheralKey.toInt()
        val gatt = gatts[deviceKey] as BluetoothGatt
        val services = gatt.services
        return services.map { service ->
            val serviceKey = service.hashCode()
            if (this.services[serviceKey] == null) {
                this.services[serviceKey] = service
            }
            return@map service.toMyArgs()
        }
    }

    override fun getCharacteristics(myServiceKey: Long): List<MyGattCharacteristicArgs> {
        val serviceKey = myServiceKey.toInt()
        val service = services[serviceKey] as BluetoothGattService
        val characteristics = service.characteristics
        return characteristics.map { characteristic ->
            val characteristicKey = characteristic.hashCode()
            if (this.characteristics[characteristicKey] == null) {
                this.characteristics[characteristicKey] = characteristic
            }
            return@map characteristic.toMyArgs()
        }
    }

    override fun getDescriptors(myCharacteristicKey: Long): List<MyGattDescriptorArgs> {
        val characteristicKey = myCharacteristicKey.toInt()
        val characteristic = characteristics[characteristicKey] as BluetoothGattCharacteristic
        val descriptors = characteristic.descriptors
        return descriptors.map { descriptor ->
            val descriptorKey = descriptor.hashCode()
            if (this.descriptors[descriptorKey] == null) {
                this.descriptors[descriptorKey] = descriptor
            }
            return@map descriptor.toMyArgs()
        }
    }

    override fun readCharacteristic(myPeripheralKey: Long, myCharacteristicKey: Long, callback: (Result<ByteArray>) -> Unit) {
        try {
            val deviceKey = myPeripheralKey.toInt()
            val characteristicKey = myCharacteristicKey.toInt()
            val unfinishedCallback = readCharacteristicCallbacks[characteristicKey]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = gatts[deviceKey] as BluetoothGatt
            val characteristic = characteristics[characteristicKey] as BluetoothGattCharacteristic
            val reading = gatt.readCharacteristic(characteristic)
            if (!reading) {
                throw IllegalStateException()
            }
            readCharacteristicCallbacks[characteristicKey] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun writeCharacteristic(myPeripheralKey: Long, myCharacteristicKey: Long, value: ByteArray, myTypeNumber: Long, callback: (Result<Unit>) -> Unit) {
        try {
            val deviceKey = myPeripheralKey.toInt()
            val characteristicKey = myCharacteristicKey.toInt()
            val unfinishedCallback = writeCharacteristicCallbacks[characteristicKey]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = gatts[deviceKey] as BluetoothGatt
            val characteristic = characteristics[characteristicKey] as BluetoothGattCharacteristic
            val myTypeArgs = myTypeNumber.toMyGattCharacteristicTypeArgs()
            val writeType = myTypeArgs.toType()
            characteristic.value = value
            characteristic.writeType = writeType
            val writing = gatt.writeCharacteristic(characteristic)
            if (!writing) {
                throw IllegalStateException()
            }
            writeCharacteristicCallbacks[characteristicKey] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun notifyCharacteristic(myPeripheralKey: Long, myCharacteristicKey: Long, state: Boolean, callback: (Result<Unit>) -> Unit) {
        try {
            val deviceKey = myPeripheralKey.toInt()
            val characteristicKey = myCharacteristicKey.toInt()
            val gatt = gatts[deviceKey] as BluetoothGatt
            val characteristic = characteristics[characteristicKey] as BluetoothGattCharacteristic
            val notifying = gatt.setCharacteristicNotification(characteristic, state)
            if (!notifying) {
                throw IllegalStateException()
            }
            val descriptorUUID = UUID.fromString(CLIENT_CHARACTERISTIC_CONFIG)
            val descriptor = characteristic.getDescriptor(descriptorUUID)
            val descriptorKey = descriptor.hashCode()
            val unfinishedCallback = writeDescriptorCallbacks[descriptorKey]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val value = if (state) BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
            else BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
            descriptor.value = value
            val writing = gatt.writeDescriptor(descriptor)
            if (!writing) {
                throw IllegalStateException()
            }
            writeDescriptorCallbacks[descriptorKey] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun readDescriptor(myPeripheralKey: Long, myDescriptorKey: Long, callback: (Result<ByteArray>) -> Unit) {
        try {
            val deviceKey = myPeripheralKey.toInt()
            val descriptorKey = myDescriptorKey.toInt()
            val unfinishedCallback = readDescriptorCallbacks[descriptorKey]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = gatts[deviceKey] as BluetoothGatt
            val descriptor = descriptors[descriptorKey] as BluetoothGattDescriptor
            val reading = gatt.readDescriptor(descriptor)
            if (!reading) {
                throw IllegalStateException()
            }
            readDescriptorCallbacks[descriptorKey] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun writeDescriptor(myPeripheralKey: Long, myDescriptorKey: Long, value: ByteArray, callback: (Result<Unit>) -> Unit) {
        try {
            val deviceKey = myPeripheralKey.toInt()
            val descriptorKey = myDescriptorKey.toInt()
            val unfinishedCallback = writeDescriptorCallbacks[descriptorKey]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = gatts[deviceKey] as BluetoothGatt
            val descriptor = descriptors[descriptorKey] as BluetoothGattDescriptor
            descriptor.value = value
            val writing = gatt.writeDescriptor(descriptor)
            if (!writing) {
                throw IllegalStateException()
            }
            writeDescriptorCallbacks[descriptorKey] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    fun onReceive(intent: Intent) {
        val action = intent.action
        if (action != BluetoothAdapter.ACTION_STATE_CHANGED) {
            return
        }
        val state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.STATE_OFF)
        val myStateArgs = state.toMyCentralStateArgs()
        val myStateNumber = myStateArgs.hashCode().toLong()
        myApi.onStateChanged(myStateNumber) {}
    }

    fun onScanFailed(error: Throwable) {
        val callback = startDiscoveryCallback ?: return
        callback(Result.failure(error))
    }

    fun onScanResult(result: ScanResult) {
        val device = result.device
        val deviceKey = device.hashCode()
        if (devices[deviceKey] == null) {
            devices[deviceKey] = device
        }
        val myPeripheralArgs = device.toMyArgs()
        val rssi = result.rssi.toLong()
        val myAdvertisementArgs = result.myAdvertisementArgs
        myApi.onDiscovered(myPeripheralArgs, rssi, myAdvertisementArgs) {}
    }

    fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
        val device = gatt.device
        val key = device.hashCode()
        val myPeripheralKey = key.toLong()
        if (newState != BluetoothProfile.STATE_CONNECTED) {
            gatt.close()
        }
        val connectCallback = connectCallbacks.remove(key)
        val disconnectCallback = disconnectCallbacks.remove(key)
        if (connectCallback == null && disconnectCallback == null) {
            // State changed.
            val state = newState == BluetoothProfile.STATE_CONNECTED
            myApi.onPeripheralStateChanged(myPeripheralKey, state) {}
        } else {
            if (connectCallback != null) {
                if (status == BluetoothGatt.GATT_SUCCESS) {
                    // Connect succeed.
                    connectCallback(Result.success(Unit))
                    myApi.onPeripheralStateChanged(myPeripheralKey, true) {}
                } else {
                    // Connect failed.
                    val exception = IllegalStateException("Connect failed with status: $status")
                    connectCallback(Result.failure(exception))
                }
            }
            if (disconnectCallback != null) {
                if (status == BluetoothGatt.GATT_SUCCESS) {
                    // Disconnect succeed.
                    disconnectCallback(Result.success(Unit))
                    myApi.onPeripheralStateChanged(myPeripheralKey, false) {}
                } else {
                    // Disconnect failed.
                    val exception = IllegalStateException("Connect failed with status: $status")
                    disconnectCallback(Result.failure(exception))
                }
            }
        }
    }

    fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
        val device = gatt.device
        val key = device.hashCode()
        val callback = discoverGattCallbacks.remove(key) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val exception = IllegalStateException("Discover GATT failed with status: $status")
            callback(Result.failure(exception))
        }
    }

    fun onCharacteristicRead(characteristic: BluetoothGattCharacteristic, status: Int) {
        val key = characteristic.hashCode()
        val callback = readCharacteristicCallbacks.remove(key) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val value = characteristic.value
            callback(Result.success(value))
        } else {
            val exception = IllegalStateException("Read characteristic failed with status: $status.")
            callback(Result.failure(exception))
        }
    }

    fun onCharacteristicWrite(characteristic: BluetoothGattCharacteristic, status: Int) {
        val key = characteristic.hashCode()
        val callback = writeCharacteristicCallbacks.remove(key) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val exception = IllegalStateException("Write characteristic failed with status: $status.")
            callback(Result.failure(exception))
        }
    }

    fun onCharacteristicChanged(characteristic: BluetoothGattCharacteristic) {
        val key = characteristic.hashCode()
        val myCharacteristicKey = key.toLong()
        val value = characteristic.value
        myApi.onCharacteristicValueChanged(myCharacteristicKey, value) {}
    }

    fun onDescriptorRead(descriptor: BluetoothGattDescriptor, status: Int) {
        val key = descriptor.hashCode()
        val callback = readDescriptorCallbacks.remove(key) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val value = descriptor.value
            callback(Result.success(value))
        } else {
            val exception = IllegalStateException("Read descriptor failed with status: $status.")
            callback(Result.failure(exception))
        }
    }

    fun onDescriptorWrite(descriptor: BluetoothGattDescriptor, status: Int) {
        val key = descriptor.hashCode()
        val callback = writeDescriptorCallbacks.remove(key) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val exception = IllegalStateException("Write descriptor failed with status: $status.")
            callback(Result.failure(exception))
        }
    }
}

private val BluetoothAdapter.myStateArgs: MyCentralStateArgs
    get() = state.toMyCentralStateArgs()

private fun Int.toMyCentralStateArgs(): MyCentralStateArgs {
    return when (this) {
        BluetoothAdapter.STATE_ON -> MyCentralStateArgs.POWEREDON
        else -> MyCentralStateArgs.POWEREDOFF
    }
}

private fun BluetoothDevice.toMyArgs(): MyPeripheralArgs {
    val key = hashCode().toLong()
    val uuid = this.uuid.toString()
    return MyPeripheralArgs(key, uuid)
}

private val BluetoothDevice.uuid: UUID
    get() {
        val node = address.filter { char -> char != ':' }
        // We don't know the timestamp of the bluetooth device, use nil UUID as prefix.
        return UUID.fromString("00000000-0000-0000-0000-$node")
    }

private val ScanResult.myAdvertisementArgs: MyAdvertisementArgs
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
            val pairs = record.serviceData.entries.map { (uuid, value) ->
                val key = uuid.toString()
                return@map Pair(key, value)
            }.toTypedArray()
            val serviceData = mapOf<String?, ByteArray?>(*pairs)
            MyAdvertisementArgs(name, manufacturerSpecificData, serviceUUIDs, serviceData)
        }
    }

private fun SparseArray<ByteArray>.toMyArgs(): Map<Long?, ByteArray?> {
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

//private val ScanRecord.rawValues: Map<Byte, ByteArray>
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

private fun BluetoothGattService.toMyArgs(): MyGattServiceArgs {
    val key = hashCode().toLong()
    val uuid = this.uuid.toString()
    return MyGattServiceArgs(key, uuid)
}

private fun BluetoothGattCharacteristic.toMyArgs(): MyGattCharacteristicArgs {
    val key = hashCode().toLong()
    val uuid = this.uuid.toString()
    return MyGattCharacteristicArgs(key, uuid, myPropertyNumbers)
}

private val BluetoothGattCharacteristic.myPropertyNumbers: List<Long>
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

private fun BluetoothGattDescriptor.toMyArgs(): MyGattDescriptorArgs {
    val key = hashCode().toLong()
    val uuid = this.uuid.toString()
    return MyGattDescriptorArgs(key, uuid)
}

private fun Long.toMyGattCharacteristicTypeArgs(): MyGattCharacteristicWriteTypeArgs {
    val raw = toInt()
    return MyGattCharacteristicWriteTypeArgs.ofRaw(raw) ?: throw IllegalArgumentException()
}

private fun MyGattCharacteristicWriteTypeArgs.toType(): Int {
    return when (this) {
        MyGattCharacteristicWriteTypeArgs.WITHRESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
        MyGattCharacteristicWriteTypeArgs.WITHOUTRESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
    }
}