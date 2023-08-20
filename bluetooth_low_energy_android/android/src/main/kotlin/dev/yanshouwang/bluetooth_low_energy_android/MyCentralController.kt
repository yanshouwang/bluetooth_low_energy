package dev.yanshouwang.bluetooth_low_energy_android

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
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import java.util.UUID

class MyCentralController(private val context: Context, binaryMessenger: BinaryMessenger) : MyCentralControllerHostApi {
    companion object {
        //        const val DATA_TYPE_MANUFACTURER_SPECIFIC_DATA = 0xff.toByte()
        private const val REQUEST_CODE = 443

        //        private val UUID_HEART_RATE_MEASUREMENT = UUID.fromString("00002a37-0000-1000-8000-00805f9b34fb")
        private val UUID_CLIENT_CHARACTERISTIC_CONFIG = UUID.fromString("00002902-0000-1000-8000-00805f9b34fb")
    }

    private lateinit var binding: ActivityPluginBinding

    private val manager = ContextCompat.getSystemService(context, BluetoothManager::class.java) as BluetoothManager
    private val adapter = manager.adapter
    private val scanner = adapter.bluetoothLeScanner
    private val executor = ContextCompat.getMainExecutor(context)

    private val myApi = MyCentralControllerFlutterApi(binaryMessenger)
    private val myRequestPermissionResultListener = MyRequestPermissionResultListener(this)
    private val myReceiver = MyBroadcastReceiver(this)
    private val myScanCallback = MyScanCallback(this)
    private val myGattCallback = MyBluetoothGattCallback(this, executor)

    private val cachedDevices = mutableMapOf<Int, BluetoothDevice>()
    private val cachedGATTs = mutableMapOf<Int, BluetoothGatt>()
    private val cachedServices = mutableMapOf<Int, Map<Int, BluetoothGattService>>()
    private val cachedCharacteristics = mutableMapOf<Int, Map<Int, BluetoothGattCharacteristic>>()
    private val cachedDescriptors = mutableMapOf<Int, Map<Int, BluetoothGattDescriptor>>()

    private var registered = false
    private var discovering = false

    private var setUpCallback: ((Result<MyCentralControllerArgs>) -> Unit)? = null
    private var startDiscoveryCallback: ((Result<Unit>) -> Unit)? = null
    private val connectCallbacks = mutableMapOf<Int, (Result<Unit>) -> Unit>()
    private val disconnectCallbacks = mutableMapOf<Int, (Result<Unit>) -> Unit>()
    private val discoverGattCallbacks = mutableMapOf<Int, (Result<Unit>) -> Unit>()
    private val readCharacteristicCallbacks = mutableMapOf<Int, (Result<ByteArray>) -> Unit>()
    private val writeCharacteristicCallbacks = mutableMapOf<Int, (Result<Unit>) -> Unit>()
    private val readDescriptorCallbacks = mutableMapOf<Int, (Result<ByteArray>) -> Unit>()
    private val writeDescriptorCallbacks = mutableMapOf<Int, (Result<Unit>) -> Unit>()

    override fun setUp(callback: (Result<MyCentralControllerArgs>) -> Unit) {
        try {
            val available = context.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
            if (!available) {
                val stateNumber = MyCentralStateArgs.UNSUPPORTED.raw.toLong()
                val args = MyCentralControllerArgs(stateNumber)
                callback(Result.success(args))
            }
            val unfinishedCallback = setUpCallback
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val permissions = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.BLUETOOTH_SCAN, android.Manifest.permission.BLUETOOTH_CONNECT)
            } else {
                arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION)
            }
            val activity = binding.activity
            ActivityCompat.requestPermissions(activity, permissions, REQUEST_CODE)
            setUpCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun tearDown() {
        if (registered) {
            unregister()
        }
        if (discovering) {
            stopDiscovery()
        }
        for (gatt in cachedGATTs.values) {
            gatt.disconnect()
        }
        cachedDevices.clear()
        cachedGATTs.clear()
        cachedServices.clear()
        cachedCharacteristics.clear()
        cachedDescriptors.clear()
    }

    private fun register() {
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        context.registerReceiver(myReceiver, filter)
        registered = true
    }

    private fun unregister() {
        context.unregisterReceiver(myReceiver)
        registered = false
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
        discovering = false
    }

    override fun connect(myPeripheralKey: Long, callback: (Result<Unit>) -> Unit) {
        try {
            val deviceKey = myPeripheralKey.toInt()
            val unfinishedCallback = connectCallbacks[deviceKey]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val device = cachedDevices[deviceKey] as BluetoothDevice
            val autoConnect = false
            cachedGATTs[deviceKey] = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
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
            val gatt = cachedGATTs[deviceKey] as BluetoothGatt
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
            val gatt = cachedGATTs[deviceKey] as BluetoothGatt
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
        val services = cachedServices[deviceKey] ?: throw IllegalStateException()
        return services.values.map { service -> service.toMyArgs() }
    }

    override fun getCharacteristics(myServiceKey: Long): List<MyGattCharacteristicArgs> {
        val serviceKey = myServiceKey.toInt()
        val characteristics = cachedCharacteristics[serviceKey] ?: throw IllegalStateException()
        return characteristics.values.map { characteristic -> characteristic.toMyArgs() }
    }

    override fun getDescriptors(myCharacteristicKey: Long): List<MyGattDescriptorArgs> {
        val characteristicKey = myCharacteristicKey.toInt()
        val descriptors = cachedDescriptors[characteristicKey] ?: throw IllegalStateException()
        return descriptors.values.map { descriptor -> descriptor.toMyArgs() }
    }

    override fun readCharacteristic(myPeripheralKey: Long, myServiceKey: Long, myCharacteristicKey: Long, callback: (Result<ByteArray>) -> Unit) {
        try {
            val deviceKey = myPeripheralKey.toInt()
            val gatt = cachedGATTs[deviceKey] as BluetoothGatt
            val serviceKey = myServiceKey.toInt()
            val characteristics = cachedCharacteristics[serviceKey]
                    ?: throw IllegalArgumentException()
            val characteristicKey = myCharacteristicKey.toInt()
            val characteristic = characteristics[characteristicKey] as BluetoothGattCharacteristic
            val unfinishedCallback = readCharacteristicCallbacks[characteristicKey]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val reading = gatt.readCharacteristic(characteristic)
            if (!reading) {
                throw IllegalStateException()
            }
            readCharacteristicCallbacks[characteristicKey] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun writeCharacteristic(myPeripheralKey: Long, myServiceKey: Long, myCharacteristicKey: Long, value: ByteArray, myTypeNumber: Long, callback: (Result<Unit>) -> Unit) {
        try {
            val deviceKey = myPeripheralKey.toInt()
            val gatt = cachedGATTs[deviceKey] as BluetoothGatt
            val serviceKey = myServiceKey.toInt()
            val characteristics = cachedCharacteristics[serviceKey]
                    ?: throw IllegalArgumentException()
            val characteristicKey = myCharacteristicKey.toInt()
            val characteristic = characteristics[characteristicKey] as BluetoothGattCharacteristic
            val unfinishedCallback = writeCharacteristicCallbacks[characteristicKey]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
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

    override fun notifyCharacteristic(myPeripheralKey: Long, myServiceKey: Long, myCharacteristicKey: Long, state: Boolean, callback: (Result<Unit>) -> Unit) {
        try {
            val deviceKey = myPeripheralKey.toInt()
            val gatt = cachedGATTs[deviceKey] as BluetoothGatt
            val serviceKey = myServiceKey.toInt()
            val characteristics = cachedCharacteristics[serviceKey]
                    ?: throw IllegalArgumentException()
            val characteristicKey = myCharacteristicKey.toInt()
            val characteristic = characteristics[characteristicKey] as BluetoothGattCharacteristic
            val notifying = gatt.setCharacteristicNotification(characteristic, state)
            if (!notifying) {
                throw IllegalStateException()
            }
            // TODO: Seems the docs is not correct, this operation is necessary for all characteristics.
            // https://developer.android.com/guide/topics/connectivity/bluetooth/transfer-ble-data#notification
            // This is specific to Heart Rate Measurement.
//            if (characteristic.uuid == UUID_HEART_RATE_MEASUREMENT) {
            val descriptor = characteristic.getDescriptor(UUID_CLIENT_CHARACTERISTIC_CONFIG)
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
//            } else {
//                callback(Result.success(Unit))
//            }
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun readDescriptor(myPeripheralKey: Long, myCharacteristicKey: Long, myDescriptorKey: Long, callback: (Result<ByteArray>) -> Unit) {
        try {
            val deviceKey = myPeripheralKey.toInt()
            val gatt = cachedGATTs[deviceKey] as BluetoothGatt
            val characteristicKey = myCharacteristicKey.toInt()
            val descriptors = cachedDescriptors[characteristicKey]
                    ?: throw IllegalArgumentException()
            val descriptorKey = myDescriptorKey.toInt()
            val descriptor = descriptors[descriptorKey] as BluetoothGattDescriptor
            val unfinishedCallback = readDescriptorCallbacks[descriptorKey]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val reading = gatt.readDescriptor(descriptor)
            if (!reading) {
                throw IllegalStateException()
            }
            readDescriptorCallbacks[descriptorKey] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun writeDescriptor(myPeripheralKey: Long, myCharacteristicKey: Long, myDescriptorKey: Long, value: ByteArray, callback: (Result<Unit>) -> Unit) {
        try {
            val deviceKey = myPeripheralKey.toInt()
            val gatt = cachedGATTs[deviceKey] as BluetoothGatt
            val characteristicKey = myCharacteristicKey.toInt()
            val descriptors = cachedDescriptors[characteristicKey]
                    ?: throw IllegalArgumentException()
            val descriptorKey = myDescriptorKey.toInt()
            val descriptor = descriptors[descriptorKey] as BluetoothGattDescriptor
            val unfinishedCallback = writeDescriptorCallbacks[descriptorKey]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
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

    fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addRequestPermissionsResultListener(myRequestPermissionResultListener)
        this.binding = binding
    }

    fun onDetachedFromActivity() {
        binding.removeRequestPermissionsResultListener(myRequestPermissionResultListener)
    }

    fun onRequestPermissionsResult(requestCode: Int, results: IntArray): Boolean {
        if (requestCode != REQUEST_CODE) {
            return false
        }
        val callback = setUpCallback ?: return false
        val isGranted = results.all { r -> r == PackageManager.PERMISSION_GRANTED }
        if (isGranted) {
            register()
        }
        val myStateArgs = if (isGranted) adapter.myStateArgs
        else MyCentralStateArgs.UNAUTHORIZED
        val myStateNumber = myStateArgs.raw.toLong()
        val myArgs = MyCentralControllerArgs(myStateNumber)
        callback(Result.success(myArgs))
        return true
    }

    fun onReceive(intent: Intent) {
        val action = intent.action
        if (action != BluetoothAdapter.ACTION_STATE_CHANGED) {
            return
        }
//        val previousState = intent.getIntExtra(BluetoothAdapter.EXTRA_PREVIOUS_STATE, BluetoothAdapter.STATE_OFF)
        val state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.STATE_OFF)
//        val myPreviousStateArgs = previousState.toMyCentralStateArgs()
        val myStateArgs = state.toMyCentralStateArgs()
//        if (myStateArgs == myPreviousStateArgs) {
//            return
//        }
        val myStateNumber = myStateArgs.raw.toLong()
        myApi.onStateChanged(myStateNumber) {}
    }

    fun onScanFailed(errorCode: Int) {
        val callback = startDiscoveryCallback ?: return
        startDiscoveryCallback = null
        val error = IllegalStateException("Start discovery failed with error code: $errorCode")
        callback(Result.failure(error))
    }

    fun onScanResult(result: ScanResult) {
        val device = result.device
        val deviceKey = device.hashCode()
        cachedDevices[deviceKey] = device
        val myPeripheralArgs = device.toMyArgs()
        val rssi = result.rssi.toLong()
        val myAdvertisementArgs = result.myAdvertisementArgs
        myApi.onDiscovered(myPeripheralArgs, rssi, myAdvertisementArgs) {}
    }

    fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
        val device = gatt.device
        val deviceKey = device.hashCode()
        val myPeripheralKey = deviceKey.toLong()
        if (newState != BluetoothProfile.STATE_CONNECTED) {
            gatt.close()
            cachedGATTs.remove(deviceKey)
            val error = IllegalStateException("GATT is disconnected with status: $status")
            val discoverGattCallback = discoverGattCallbacks.remove(deviceKey)
            if (discoverGattCallback != null) {
                discoverGattCallback(Result.failure(error))
            }
            val services = cachedServices[deviceKey] ?: emptyMap()
            for (service in services) {
                val characteristics = cachedCharacteristics[service.key] ?: emptyMap()
                for (characteristic in characteristics) {
                    val readCharacteristicCallback = readCharacteristicCallbacks.remove(characteristic.key)
                    val writeCharacteristicCallback = writeCharacteristicCallbacks.remove(characteristic.key)
                    if (readCharacteristicCallback != null) {
                        readCharacteristicCallback(Result.failure(error))
                    }
                    if (writeCharacteristicCallback != null) {
                        writeCharacteristicCallback(Result.failure(error))
                    }
                    val descriptors = cachedDescriptors[characteristic.key] ?: emptyMap()
                    for (descriptor in descriptors) {
                        val readDescriptorCallback = readDescriptorCallbacks.remove(descriptor.key)
                        val writeDescriptorCallback = writeDescriptorCallbacks.remove(descriptor.key)
                        if (readDescriptorCallback != null) {
                            readDescriptorCallback(Result.failure(error))
                        }
                        if (writeDescriptorCallback != null) {
                            writeDescriptorCallback(Result.failure(error))
                        }
                    }
                }
            }
        }
        val connectCallback = connectCallbacks.remove(deviceKey)
        val disconnectCallback = disconnectCallbacks.remove(deviceKey)
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
                    val error = IllegalStateException("Connect failed with status: $status")
                    connectCallback(Result.failure(error))
                }
            }
            if (disconnectCallback != null) {
                if (status == BluetoothGatt.GATT_SUCCESS) {
                    // Disconnect succeed.
                    disconnectCallback(Result.success(Unit))
                    myApi.onPeripheralStateChanged(myPeripheralKey, false) {}
                } else {
                    // Disconnect failed.
                    val error = IllegalStateException("Connect failed with status: $status")
                    disconnectCallback(Result.failure(error))
                }
            }
        }
    }

    fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
        val device = gatt.device
        val deviceKey = device.hashCode()
        val callback = discoverGattCallbacks.remove(deviceKey) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val cachedServices = mutableMapOf<Int, BluetoothGattService>()
            for (service in gatt.services) {
                val serviceKey = service.hashCode()
                cachedServices[serviceKey] = service
                val cachedCharacteristics = mutableMapOf<Int, BluetoothGattCharacteristic>()
                for (characteristic in service.characteristics) {
                    val characteristicKey = characteristic.hashCode()
                    cachedCharacteristics[characteristicKey] = characteristic
                    val cachedDescriptors = mutableMapOf<Int, BluetoothGattDescriptor>()
                    for (descriptor in characteristic.descriptors) {
                        val descriptorKey = descriptor.hashCode()
                        cachedDescriptors[descriptorKey] = descriptor
                    }
                    this.cachedDescriptors[characteristicKey] = cachedDescriptors
                }
                this.cachedCharacteristics[serviceKey] = cachedCharacteristics
            }
            this.cachedServices[deviceKey] = cachedServices
            callback(Result.success(Unit))
        } else {
            val error = IllegalStateException("Discover GATT failed with status: $status")
            callback(Result.failure(error))
        }
    }

    fun onCharacteristicRead(characteristic: BluetoothGattCharacteristic, status: Int) {
        val characteristicKey = characteristic.hashCode()
        val callback = readCharacteristicCallbacks.remove(characteristicKey) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val value = characteristic.value
            callback(Result.success(value))
        } else {
            val error = IllegalStateException("Read characteristic failed with status: $status.")
            callback(Result.failure(error))
        }
    }

    fun onCharacteristicWrite(characteristic: BluetoothGattCharacteristic, status: Int) {
        val characteristicKey = characteristic.hashCode()
        val callback = writeCharacteristicCallbacks.remove(characteristicKey) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val error = IllegalStateException("Write characteristic failed with status: $status.")
            callback(Result.failure(error))
        }
    }

    fun onCharacteristicChanged(characteristic: BluetoothGattCharacteristic) {
        val characteristicKey = characteristic.hashCode()
        val myCharacteristicKey = characteristicKey.toLong()
        val value = characteristic.value
        myApi.onCharacteristicValueChanged(myCharacteristicKey, value) {}
    }

    fun onDescriptorRead(descriptor: BluetoothGattDescriptor, status: Int) {
        val descriptorKey = descriptor.hashCode()
        val callback = readDescriptorCallbacks.remove(descriptorKey) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val value = descriptor.value
            callback(Result.success(value))
        } else {
            val error = IllegalStateException("Read descriptor failed with status: $status.")
            callback(Result.failure(error))
        }
    }

    fun onDescriptorWrite(descriptor: BluetoothGattDescriptor, status: Int) {
        val descriptorKey = descriptor.hashCode()
        val callback = writeDescriptorCallbacks.remove(descriptorKey) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val error = IllegalStateException("Write descriptor failed with status: $status.")
            callback(Result.failure(error))
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