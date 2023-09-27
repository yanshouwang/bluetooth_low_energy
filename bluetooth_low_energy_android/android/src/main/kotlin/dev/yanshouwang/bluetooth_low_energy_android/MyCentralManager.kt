package dev.yanshouwang.bluetooth_low_energy_android

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattService
import android.bluetooth.BluetoothProfile
import android.bluetooth.BluetoothStatusCodes
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import io.flutter.plugin.common.BinaryMessenger

class MyCentralManager(private val context: Context, binaryMessenger: BinaryMessenger) : MyBluetoothLowEnergyManager(context), MyCentralManagerHostApi {
    private val scanner get() = adapter.bluetoothLeScanner

    private val myApi = MyCentralManagerFlutterApi(binaryMessenger)
    private val myScanCallback = MyScanCallback(this)
    private val myBluetoothGattCallback = MyBluetoothGattCallback(this, executor)

    // Native cache
    private val devices = mutableMapOf<Long, BluetoothDevice>()
    private val bluetoothGATTs = mutableMapOf<Long, BluetoothGatt>()
    private val services = mutableMapOf<Long, BluetoothGattService>()
    private val characteristics = mutableMapOf<Long, BluetoothGattCharacteristic>()
    private val descriptors = mutableMapOf<Long, BluetoothGattDescriptor>()

    // My cache
    private val myPeripherals = mutableMapOf<Int, MyPeripheralArgs>()
    private val myServicesOfMyPeripherals = mutableMapOf<Long, List<MyGattServiceArgs>>()
    private val myServices = mutableMapOf<Int, MyGattServiceArgs>()
    private val myCharacteristics = mutableMapOf<Int, MyGattCharacteristicArgs>()
    private val myDescriptors = mutableMapOf<Int, MyGattDescriptorArgs>()

    private var registered = false
    private var discovering = false

    private var setUpCallback: ((Result<MyCentralManagerArgs>) -> Unit)? = null
    private var startDiscoveryCallback: ((Result<Unit>) -> Unit)? = null
    private val connectCallbacks = mutableMapOf<Long, (Result<Unit>) -> Unit>()
    private val disconnectCallbacks = mutableMapOf<Long, (Result<Unit>) -> Unit>()
    private val getMaximumWriteLengthCallbacks = mutableMapOf<Long, (Result<Long>) -> Unit>()
    private val readRssiCallbacks = mutableMapOf<Long, (Result<Long>) -> Unit>()
    private val discoverGattCallbacks = mutableMapOf<Long, (Result<List<MyGattServiceArgs>>) -> Unit>()
    private val readCharacteristicCallbacks = mutableMapOf<Long, (Result<ByteArray>) -> Unit>()
    private val writeCharacteristicCallbacks = mutableMapOf<Long, (Result<Unit>) -> Unit>()
    private val readDescriptorCallbacks = mutableMapOf<Long, (Result<ByteArray>) -> Unit>()
    private val writeDescriptorCallbacks = mutableMapOf<Long, (Result<Unit>) -> Unit>()

    override fun setUp(callback: (Result<MyCentralManagerArgs>) -> Unit) {
        try {
            if (setUpCallback != null) {
                throw IllegalStateException()
            }
            tearDown()
            if (unsupported) {
                val stateNumber = MyBluetoothLowEnergyStateArgs.UNSUPPORTED.raw.toLong()
                val args = MyCentralManagerArgs(stateNumber)
                callback(Result.success(args))
            }
            authorize()
            setUpCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    private fun tearDown() {
        if (registered) {
            unregister()
        }
        if (discovering) {
            stopDiscovery()
        }
        for (gatt in bluetoothGATTs.values) {
            gatt.disconnect()
        }
        devices.clear()
        bluetoothGATTs.clear()
        services.clear()
        characteristics.clear()
        descriptors.clear()
        setUpCallback = null
        startDiscoveryCallback = null
        connectCallbacks.clear()
        disconnectCallbacks.clear()
        getMaximumWriteLengthCallbacks.clear()
        readRssiCallbacks.clear()
        discoverGattCallbacks.clear()
        readCharacteristicCallbacks.clear()
        writeCharacteristicCallbacks.clear()
        readDescriptorCallbacks.clear()
        writeDescriptorCallbacks.clear()
    }

    override fun register() {
        super.register()
        registered = true
    }

    override fun unregister() {
        super.unregister()
        registered = false
    }

    override fun startDiscovery(callback: (Result<Unit>) -> Unit) {
        try {
            if (startDiscoveryCallback != null) {
                throw IllegalStateException()
            }
            val filters = emptyList<ScanFilter>()
            val settings = ScanSettings.Builder().setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY).build()
            scanner.startScan(filters, settings, myScanCallback)
            executor.execute { onScanSucceed() }
            startDiscoveryCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun stopDiscovery() {
        scanner.stopScan(myScanCallback)
        discovering = false
    }

    override fun connect(myPeripheralHashCode: Long, callback: (Result<Unit>) -> Unit) {
        try {
            val unfinishedCallback = connectCallbacks[myPeripheralHashCode]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val device = devices[myPeripheralHashCode] as BluetoothDevice
            val autoConnect = false
            // Add to bluetoothGATTs cache.
            bluetoothGATTs[myPeripheralHashCode] = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val transport = BluetoothDevice.TRANSPORT_LE
                device.connectGatt(context, autoConnect, myBluetoothGattCallback, transport)
            } else {
                device.connectGatt(context, autoConnect, myBluetoothGattCallback)
            }
            connectCallbacks[myPeripheralHashCode] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun disconnect(myPeripheralHashCode: Long, callback: (Result<Unit>) -> Unit) {
        try {
            val unfinishedCallback = disconnectCallbacks[myPeripheralHashCode]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = bluetoothGATTs[myPeripheralHashCode] as BluetoothGatt
            gatt.disconnect()
            disconnectCallbacks[myPeripheralHashCode] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun getMaximumWriteLength(myPeripheralHashCode: Long, callback: (Result<Long>) -> Unit) {
        try {
            val unfinishedCallback = getMaximumWriteLengthCallbacks[myPeripheralHashCode]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = bluetoothGATTs[myPeripheralHashCode] as BluetoothGatt
            val requesting = gatt.requestMtu(512)
            if (!requesting) {
                throw IllegalStateException()
            }
            getMaximumWriteLengthCallbacks[myPeripheralHashCode] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun readRSSI(myPeripheralHashCode: Long, callback: (Result<Long>) -> Unit) {
        try {
            val unfinishedCallback = readRssiCallbacks[myPeripheralHashCode]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = bluetoothGATTs[myPeripheralHashCode] as BluetoothGatt
            val reading = gatt.readRemoteRssi()
            if (!reading) {
                throw IllegalStateException()
            }
            readRssiCallbacks[myPeripheralHashCode] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun discoverGATT(myPeripheralHashCode: Long, callback: (Result<List<MyGattServiceArgs>>) -> Unit) {
        try {
            val unfinishedCallback = discoverGattCallbacks[myPeripheralHashCode]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = bluetoothGATTs[myPeripheralHashCode] as BluetoothGatt
            val discovering = gatt.discoverServices()
            if (!discovering) {
                throw IllegalStateException()
            }
            discoverGattCallbacks[myPeripheralHashCode] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun readCharacteristic(myPeripheralHashCode: Long, myCharacteristicHashCode: Long, callback: (Result<ByteArray>) -> Unit) {
        try {
            val unfinishedCallback = readCharacteristicCallbacks[myCharacteristicHashCode]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = bluetoothGATTs[myPeripheralHashCode] as BluetoothGatt
            val characteristic = characteristics[myCharacteristicHashCode] as BluetoothGattCharacteristic
            val reading = gatt.readCharacteristic(characteristic)
            if (!reading) {
                throw IllegalStateException()
            }
            readCharacteristicCallbacks[myCharacteristicHashCode] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun writeCharacteristic(myPeripheralHashCode: Long, myCharacteristicHashCode: Long, myValue: ByteArray, myTypeNumber: Long, callback: (Result<Unit>) -> Unit) {
        try {
            val unfinishedCallback = writeCharacteristicCallbacks[myCharacteristicHashCode]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = bluetoothGATTs[myPeripheralHashCode] as BluetoothGatt
            val characteristic = characteristics[myCharacteristicHashCode] as BluetoothGattCharacteristic
            val myTypeArgs = myTypeNumber.toMyGattCharacteristicTypeArgs()
            val writeType = myTypeArgs.toType()
            val writing = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val code = gatt.writeCharacteristic(characteristic, myValue, writeType)
                code == BluetoothStatusCodes.SUCCESS
            } else {
                // TODO: remove this when minSdkVersion >= 33
                characteristic.value = myValue
                characteristic.writeType = writeType
                gatt.writeCharacteristic(characteristic)
            }
            if (!writing) {
                throw IllegalStateException()
            }
            writeCharacteristicCallbacks[myCharacteristicHashCode] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun notifyCharacteristic(myPeripheralHashCode: Long, myCharacteristicHashCode: Long, myState: Boolean, callback: (Result<Unit>) -> Unit) {
        try {
            val gatt = bluetoothGATTs[myPeripheralHashCode] as BluetoothGatt
            val characteristic = characteristics[myCharacteristicHashCode] as BluetoothGattCharacteristic
            val notifying = gatt.setCharacteristicNotification(characteristic, myState)
            if (!notifying) {
                throw IllegalStateException()
            }
            // TODO: Seems the docs is not correct, this operation is necessary for all characteristics.
            // https://developer.android.com/guide/topics/connectivity/bluetooth/transfer-ble-data#notification
            // This is specific to Heart Rate Measurement.
//            if (characteristic.uuid == UUID_HEART_RATE_MEASUREMENT) {
            val descriptor = characteristic.getDescriptor(CLIENT_CHARACTERISTIC_CONFIG_UUID)
            val descriptorHashCode = descriptor.hashCode()
            val myDescriptor = myDescriptors[descriptorHashCode] as MyGattDescriptorArgs
            val myDescriptorHashCode = myDescriptor.myHashCode
            val unfinishedCallback = writeDescriptorCallbacks[myDescriptorHashCode]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val value = if (myState) BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
            else BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
            val writing = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val code = gatt.writeDescriptor(descriptor, value)
                code == BluetoothStatusCodes.SUCCESS
            } else {
                // TODO: remove this when minSdkVersion >= 33
                descriptor.value = value
                gatt.writeDescriptor(descriptor)
            }
            if (!writing) {
                throw IllegalStateException()
            }
            writeDescriptorCallbacks[myDescriptorHashCode] = callback
//            } else {
//                callback(Result.success(Unit))
//            }
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun readDescriptor(myPeripheralHashCode: Long, myDescriptorHashCode: Long, callback: (Result<ByteArray>) -> Unit) {
        try {
            val unfinishedCallback = readDescriptorCallbacks[myDescriptorHashCode]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = bluetoothGATTs[myPeripheralHashCode] as BluetoothGatt
            val descriptor = descriptors[myDescriptorHashCode] as BluetoothGattDescriptor
            val reading = gatt.readDescriptor(descriptor)
            if (!reading) {
                throw IllegalStateException()
            }
            readDescriptorCallbacks[myDescriptorHashCode] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun writeDescriptor(myPeripheralHashCode: Long, myDescriptorHashCode: Long, myValue: ByteArray, callback: (Result<Unit>) -> Unit) {
        try {
            val unfinishedCallback = writeDescriptorCallbacks[myDescriptorHashCode]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = bluetoothGATTs[myPeripheralHashCode] as BluetoothGatt
            val descriptor = descriptors[myDescriptorHashCode] as BluetoothGattDescriptor
            val writing = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val code = gatt.writeDescriptor(descriptor, myValue)
                code == BluetoothStatusCodes.SUCCESS
            } else {
                // TODO: remove this when minSdkVersion >= 33
                descriptor.value = myValue
                gatt.writeDescriptor(descriptor)
            }
            if (!writing) {
                throw IllegalStateException()
            }
            writeDescriptorCallbacks[myDescriptorHashCode] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, results: IntArray): Boolean {
        if (requestCode != REQUEST_CODE) {
            return false
        }
        val authorized = results.all { r -> r == PackageManager.PERMISSION_GRANTED }
        val callback = setUpCallback ?: return false
        setUpCallback = null
        val myStateArgs = if (authorized) adapter.myStateArgs
        else MyBluetoothLowEnergyStateArgs.UNAUTHORIZED
        val myStateNumber = myStateArgs.raw.toLong()
        val myArgs = MyCentralManagerArgs(myStateNumber)
        callback(Result.success(myArgs))
        if (authorized) {
            register()
        }
        return true
    }

    override fun onReceive(intent: Intent) {
        val action = intent.action
        if (action != BluetoothAdapter.ACTION_STATE_CHANGED) {
            return
        }
        val state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.STATE_OFF)
        val myStateArgs = state.toMyCentralStateArgs()
        val myStateNumber = myStateArgs.raw.toLong()
        myApi.onStateChanged(myStateNumber) {}
    }

    private fun onScanSucceed() {
        val callback = startDiscoveryCallback ?: return
        startDiscoveryCallback = null
        callback(Result.success(Unit))
    }

    fun onScanFailed(errorCode: Int) {
        val callback = startDiscoveryCallback ?: return
        startDiscoveryCallback = null
        val error = IllegalStateException("Start discovery failed with error code: $errorCode")
        callback(Result.failure(error))
    }

    fun onScanResult(result: ScanResult) {
        val device = result.device
        val myPeripheral = device.toMyPeripheralArgs()
        val hashCode = device.hashCode()
        val myHashCode = myPeripheral.myHashCode
        this.devices[myHashCode] = device
        this.myPeripherals[hashCode] = myPeripheral
        val rssi = result.rssi.toLong()
        val myAdvertisementArgs = result.myAdvertisementArgs
        myApi.onDiscovered(myPeripheral, rssi, myAdvertisementArgs) {}
    }

    fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
        val device = gatt.device
        val deviceHashCode = device.hashCode()
        val myPeripheral = myPeripherals[deviceHashCode] as MyPeripheralArgs
        val myPeripheralHashCode = myPeripheral.myHashCode
        // Check callbacks
        if (newState != BluetoothProfile.STATE_CONNECTED) {
            gatt.close()
            bluetoothGATTs.remove(myPeripheralHashCode)
            val error = IllegalStateException("GATT is disconnected with status: $status")
            val getMaximumWriteLengthCallback = getMaximumWriteLengthCallbacks.remove(myPeripheralHashCode)
            if (getMaximumWriteLengthCallback != null) {
                getMaximumWriteLengthCallback(Result.failure(error))
            }
            val readRssiCallback = readRssiCallbacks.remove(myPeripheralHashCode)
            if (readRssiCallback != null) {
                readRssiCallback(Result.failure(error))
            }
            val discoverGattCallback = discoverGattCallbacks.remove(myPeripheralHashCode)
            if (discoverGattCallback != null) {
                discoverGattCallback(Result.failure(error))
            }
            val myServices = myServicesOfMyPeripherals[myPeripheralHashCode] ?: emptyList()
            for (myService in myServices) {
                val myCharacteristics = myService.myCharacteristicArgses.filterNotNull()
                for (myCharacteristic in myCharacteristics) {
                    val myCharacteristicHashCode = myCharacteristic.myHashCode
                    val readCharacteristicCallback = readCharacteristicCallbacks.remove(myCharacteristicHashCode)
                    val writeCharacteristicCallback = writeCharacteristicCallbacks.remove(myCharacteristicHashCode)
                    if (readCharacteristicCallback != null) {
                        readCharacteristicCallback(Result.failure(error))
                    }
                    if (writeCharacteristicCallback != null) {
                        writeCharacteristicCallback(Result.failure(error))
                    }
                    val myDescriptors = myCharacteristic.myDescriptorArgses.filterNotNull()
                    for (myDescriptor in myDescriptors) {
                        val myDescriptorHashCode = myDescriptor.myHashCode
                        val readDescriptorCallback = readDescriptorCallbacks.remove(myDescriptorHashCode)
                        val writeDescriptorCallback = writeDescriptorCallbacks.remove(myDescriptorHashCode)
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
        // Check state
        val connectCallback = connectCallbacks.remove(myPeripheralHashCode)
        val disconnectCallback = disconnectCallbacks.remove(myPeripheralHashCode)
        if (connectCallback == null && disconnectCallback == null) {
            // State changed.
            val state = newState == BluetoothProfile.STATE_CONNECTED
            myApi.onPeripheralStateChanged(myPeripheral, state) {}
        } else {
            if (connectCallback != null) {
                if (status == BluetoothGatt.GATT_SUCCESS) {
                    // Connect succeed.
                    connectCallback(Result.success(Unit))
                    myApi.onPeripheralStateChanged(myPeripheral, true) {}
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
                    myApi.onPeripheralStateChanged(myPeripheral, false) {}
                } else {
                    // Disconnect failed.
                    val error = IllegalStateException("Connect failed with status: $status")
                    disconnectCallback(Result.failure(error))
                }
            }
        }
    }

    fun onMtuChanged(gatt: BluetoothGatt, mtu: Int, status: Int) {
        val device = gatt.device
        val hashCode = device.hashCode()
        val myPeripheral = myPeripherals[hashCode] as MyPeripheralArgs
        val myHashCode = myPeripheral.myHashCode
        val callback = getMaximumWriteLengthCallbacks.remove(myHashCode) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val myMaximumWriteLength = (mtu - 3).toLong()
            callback(Result.success(myMaximumWriteLength))
        } else {
            val error = IllegalStateException("Get maximum write length failed with status: $status")
            callback(Result.failure(error))
        }
    }

    fun onReadRemoteRssi(gatt: BluetoothGatt, rssi: Int, status: Int) {
        val device = gatt.device
        val hashCode = device.hashCode()
        val myPeripheral = myPeripherals[hashCode] as MyPeripheralArgs
        val myHashCode = myPeripheral.myHashCode
        val callback = readRssiCallbacks.remove(myHashCode) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val myRSSI = rssi.toLong()
            callback(Result.success(myRSSI))
        } else {
            val error = IllegalStateException("Read rssi failed with status: $status")
            callback(Result.failure(error))
        }
    }

    fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
        val device = gatt.device
        val deviceHashCode = device.hashCode()
        val myPeripheral = myPeripherals[deviceHashCode] as MyPeripheralArgs
        val myPeripheralHashCode = myPeripheral.myHashCode
        val callback = discoverGattCallbacks.remove(myPeripheralHashCode) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val services = gatt.services
            val myServices = mutableListOf<MyGattServiceArgs>()
            for (service in services) {
                val characteristics = service.characteristics
                val myCharacteristics = mutableListOf<MyGattCharacteristicArgs>()
                for (characteristic in characteristics) {
                    val descriptors = characteristic.descriptors
                    val myDescriptors = mutableListOf<MyGattDescriptorArgs>()
                    for (descriptor in descriptors) {
                        val myDescriptor = descriptor.toMyArgs()
                        val descriptorHashCode = descriptor.hashCode()
                        val myDescriptorHashCode = myDescriptor.myHashCode
                        this.descriptors[myDescriptorHashCode] = descriptor
                        this.myDescriptors[descriptorHashCode] = myDescriptor
                        myDescriptors.add(myDescriptor)
                    }
                    val myCharacteristic = characteristic.toMyArgs(myDescriptors)
                    val characteristicHashCode = characteristic.hashCode()
                    val myCharacteristicHashCode = myCharacteristic.myHashCode
                    this.characteristics[myCharacteristicHashCode] = characteristic
                    this.myCharacteristics[characteristicHashCode] = myCharacteristic
                    myCharacteristics.add(myCharacteristic)
                }
                val myService = service.toMyArgs(myCharacteristics)
                val serviceHashCode = service.hashCode()
                val myServiceHashCode = myService.myHashCode
                this.services[myServiceHashCode] = service
                this.myServices[serviceHashCode] = myService
                myServices.add(myService)
            }
            myServicesOfMyPeripherals[myPeripheralHashCode] = myServices
            callback(Result.success(myServices))
        } else {
            val error = IllegalStateException("Discover GATT failed with status: $status")
            callback(Result.failure(error))
        }
    }

    fun onCharacteristicRead(characteristic: BluetoothGattCharacteristic, status: Int, value: ByteArray) {
        val hashCode = characteristic.hashCode()
        val myCharacteristic = myCharacteristics[hashCode] as MyGattCharacteristicArgs
        val myHashCode = myCharacteristic.myHashCode
        val callback = readCharacteristicCallbacks.remove(myHashCode) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(value))
        } else {
            val error = IllegalStateException("Read characteristic failed with status: $status.")
            callback(Result.failure(error))
        }
    }

    fun onCharacteristicWrite(characteristic: BluetoothGattCharacteristic, status: Int) {
        val hashCode = characteristic.hashCode()
        val myCharacteristic = myCharacteristics[hashCode] as MyGattCharacteristicArgs
        val myHashCode = myCharacteristic.myHashCode
        val callback = writeCharacteristicCallbacks.remove(myHashCode) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val error = IllegalStateException("Write characteristic failed with status: $status.")
            callback(Result.failure(error))
        }
    }

    fun onCharacteristicChanged(characteristic: BluetoothGattCharacteristic, value: ByteArray) {
        val hashCode = characteristic.hashCode()
        val myCharacteristic = myCharacteristics[hashCode] as MyGattCharacteristicArgs
        myApi.onCharacteristicValueChanged(myCharacteristic, value) {}
    }

    fun onDescriptorRead(descriptor: BluetoothGattDescriptor, status: Int, value: ByteArray) {
        val hashCode = descriptor.hashCode()
        val myDescriptor = myDescriptors[hashCode] as MyGattDescriptorArgs
        val myHashCode = myDescriptor.myHashCode
        val callback = readDescriptorCallbacks.remove(myHashCode) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(value))
        } else {
            val error = IllegalStateException("Read descriptor failed with status: $status.")
            callback(Result.failure(error))
        }
    }

    fun onDescriptorWrite(descriptor: BluetoothGattDescriptor, status: Int) {
        val hashCode = descriptor.hashCode()
        val myDescriptor = myDescriptors[hashCode] as MyGattDescriptorArgs
        val myHashCode = myDescriptor.myHashCode
        val callback = writeDescriptorCallbacks.remove(myHashCode) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val error = IllegalStateException("Write descriptor failed with status: $status.")
            callback(Result.failure(error))
        }
    }
}
