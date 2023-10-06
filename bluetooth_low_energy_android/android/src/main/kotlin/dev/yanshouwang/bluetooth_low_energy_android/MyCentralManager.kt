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

    private val api = MyCentralManagerFlutterApi(binaryMessenger)
    private val scanCallback = MyScanCallback(this)
    private val bluetoothGattCallback = MyBluetoothGattCallback(this, executor)

    private val devices = mutableMapOf<Long, BluetoothDevice>()
    private val bluetoothGATTs = mutableMapOf<Long, BluetoothGatt>()
    private val services = mutableMapOf<Long, BluetoothGattService>()
    private val characteristics = mutableMapOf<Long, BluetoothGattCharacteristic>()
    private val descriptors = mutableMapOf<Long, BluetoothGattDescriptor>()

    private val peripheralsArgs = mutableMapOf<Int, MyPeripheralArgs>()
    private val servicesArgsOfPeripherals = mutableMapOf<Long, List<MyGattServiceArgs>>()
    private val servicesArgs = mutableMapOf<Int, MyGattServiceArgs>()
    private val characteristicsArgs = mutableMapOf<Int, MyGattCharacteristicArgs>()
    private val descriptorsArgs = mutableMapOf<Int, MyGattDescriptorArgs>()

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
                val stateNumberArgs = MyBluetoothLowEnergyStateArgs.UNSUPPORTED.raw.toLong()
                val args = MyCentralManagerArgs(stateNumberArgs)
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
            scanner.startScan(filters, settings, scanCallback)
            executor.execute { onScanSucceed() }
            startDiscoveryCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun stopDiscovery() {
        scanner.stopScan(scanCallback)
        discovering = false
    }

    override fun connect(peripheralHashCodeArgs: Long, callback: (Result<Unit>) -> Unit) {
        try {
            val unfinishedCallback = connectCallbacks[peripheralHashCodeArgs]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val device = devices[peripheralHashCodeArgs] as BluetoothDevice
            val autoConnect = false
            // Add to bluetoothGATTs cache.
            bluetoothGATTs[peripheralHashCodeArgs] = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val transport = BluetoothDevice.TRANSPORT_LE
                device.connectGatt(context, autoConnect, bluetoothGattCallback, transport)
            } else {
                device.connectGatt(context, autoConnect, bluetoothGattCallback)
            }
            connectCallbacks[peripheralHashCodeArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun disconnect(peripheralHashCodeArgs: Long, callback: (Result<Unit>) -> Unit) {
        try {
            val unfinishedCallback = disconnectCallbacks[peripheralHashCodeArgs]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = bluetoothGATTs[peripheralHashCodeArgs] as BluetoothGatt
            gatt.disconnect()
            disconnectCallbacks[peripheralHashCodeArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun getMaximumWriteLength(peripheralHashCodeArgs: Long, callback: (Result<Long>) -> Unit) {
        try {
            val unfinishedCallback = getMaximumWriteLengthCallbacks[peripheralHashCodeArgs]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = bluetoothGATTs[peripheralHashCodeArgs] as BluetoothGatt
            val requesting = gatt.requestMtu(512)
            if (!requesting) {
                throw IllegalStateException()
            }
            getMaximumWriteLengthCallbacks[peripheralHashCodeArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun readRSSI(peripheralHashCodeArgs: Long, callback: (Result<Long>) -> Unit) {
        try {
            val unfinishedCallback = readRssiCallbacks[peripheralHashCodeArgs]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = bluetoothGATTs[peripheralHashCodeArgs] as BluetoothGatt
            val reading = gatt.readRemoteRssi()
            if (!reading) {
                throw IllegalStateException()
            }
            readRssiCallbacks[peripheralHashCodeArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun discoverGATT(peripheralHashCodeArgs: Long, callback: (Result<List<MyGattServiceArgs>>) -> Unit) {
        try {
            val unfinishedCallback = discoverGattCallbacks[peripheralHashCodeArgs]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = bluetoothGATTs[peripheralHashCodeArgs] as BluetoothGatt
            val discovering = gatt.discoverServices()
            if (!discovering) {
                throw IllegalStateException()
            }
            discoverGattCallbacks[peripheralHashCodeArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun readCharacteristic(peripheralHashCodeArgs: Long, characteristicHashCodeArgs: Long, callback: (Result<ByteArray>) -> Unit) {
        try {
            val unfinishedCallback = readCharacteristicCallbacks[characteristicHashCodeArgs]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = bluetoothGATTs[peripheralHashCodeArgs] as BluetoothGatt
            val characteristic = characteristics[characteristicHashCodeArgs] as BluetoothGattCharacteristic
            val reading = gatt.readCharacteristic(characteristic)
            if (!reading) {
                throw IllegalStateException()
            }
            readCharacteristicCallbacks[characteristicHashCodeArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun writeCharacteristic(peripheralHashCodeArgs: Long, characteristicHashCodeArgs: Long, valueArgs: ByteArray, typeNumberArgs: Long, callback: (Result<Unit>) -> Unit) {
        try {
            val unfinishedCallback = writeCharacteristicCallbacks[characteristicHashCodeArgs]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = bluetoothGATTs[peripheralHashCodeArgs] as BluetoothGatt
            val characteristic = characteristics[characteristicHashCodeArgs] as BluetoothGattCharacteristic
            val typeArgs = typeNumberArgs.toWriteTypeArgs()
            val type = typeArgs.toType()
            val writing = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val code = gatt.writeCharacteristic(characteristic, valueArgs, type)
                code == BluetoothStatusCodes.SUCCESS
            } else {
                // TODO: remove this when minSdkVersion >= 33
                characteristic.value = valueArgs
                characteristic.writeType = type
                gatt.writeCharacteristic(characteristic)
            }
            if (!writing) {
                throw IllegalStateException()
            }
            writeCharacteristicCallbacks[characteristicHashCodeArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun notifyCharacteristic(peripheralHashCodeArgs: Long, characteristicHashCodeArgs: Long, stateArgs: Boolean, callback: (Result<Unit>) -> Unit) {
        try {
            val gatt = bluetoothGATTs[peripheralHashCodeArgs] as BluetoothGatt
            val characteristic = characteristics[characteristicHashCodeArgs] as BluetoothGattCharacteristic
            val notifying = gatt.setCharacteristicNotification(characteristic, stateArgs)
            if (!notifying) {
                throw IllegalStateException()
            }
            // TODO: Seems the docs is not correct, this operation is necessary for all characteristics.
            // https://developer.android.com/guide/topics/connectivity/bluetooth/transfer-ble-data#notification
            // This is specific to Heart Rate Measurement.
//            if (characteristic.uuid == UUID_HEART_RATE_MEASUREMENT) {
            val descriptor = characteristic.getDescriptor(CLIENT_CHARACTERISTIC_CONFIG_UUID)
            val descriptorHashCode = descriptor.hashCode()
            val descriptorArgs = descriptorsArgs[descriptorHashCode] as MyGattDescriptorArgs
            val descriptorHashCodeArgs = descriptorArgs.hashCodeArgs
            val unfinishedCallback = writeDescriptorCallbacks[descriptorHashCodeArgs]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val value = if (stateArgs) BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
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
            writeDescriptorCallbacks[descriptorHashCodeArgs] = callback
//            } else {
//                callback(Result.success(Unit))
//            }
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun readDescriptor(peripheralHashCodeArgs: Long, descriptorHashCodeArgs: Long, callback: (Result<ByteArray>) -> Unit) {
        try {
            val unfinishedCallback = readDescriptorCallbacks[descriptorHashCodeArgs]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = bluetoothGATTs[peripheralHashCodeArgs] as BluetoothGatt
            val descriptor = descriptors[descriptorHashCodeArgs] as BluetoothGattDescriptor
            val reading = gatt.readDescriptor(descriptor)
            if (!reading) {
                throw IllegalStateException()
            }
            readDescriptorCallbacks[descriptorHashCodeArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun writeDescriptor(peripheralHashCodeArgs: Long, descriptorHashCodeArgs: Long, valueArgs: ByteArray, callback: (Result<Unit>) -> Unit) {
        try {
            val unfinishedCallback = writeDescriptorCallbacks[descriptorHashCodeArgs]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val gatt = bluetoothGATTs[peripheralHashCodeArgs] as BluetoothGatt
            val descriptor = descriptors[descriptorHashCodeArgs] as BluetoothGattDescriptor
            val writing = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val code = gatt.writeDescriptor(descriptor, valueArgs)
                code == BluetoothStatusCodes.SUCCESS
            } else {
                // TODO: remove this when minSdkVersion >= 33
                descriptor.value = valueArgs
                gatt.writeDescriptor(descriptor)
            }
            if (!writing) {
                throw IllegalStateException()
            }
            writeDescriptorCallbacks[descriptorHashCodeArgs] = callback
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
        val stateArgs = if (authorized) adapter.stateArgs
        else MyBluetoothLowEnergyStateArgs.UNAUTHORIZED
        val stateNumberArgs = stateArgs.raw.toLong()
        val args = MyCentralManagerArgs(stateNumberArgs)
        callback(Result.success(args))
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
        val stateArgs = state.toBluetoothLowEnergyStateArgs()
        val stateNumberArgs = stateArgs.raw.toLong()
        api.onStateChanged(stateNumberArgs) {}
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
        val peripheralArgs = device.toPeripheralArgs()
        val hashCode = device.hashCode()
        val hashCodeArgs = peripheralArgs.hashCodeArgs
        this.devices[hashCodeArgs] = device
        this.peripheralsArgs[hashCode] = peripheralArgs
        val rssiArgs = result.rssi.toLong()
        val advertisementArgs = result.advertisementArgs
        api.onDiscovered(peripheralArgs, rssiArgs, advertisementArgs) {}
    }

    fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
        val device = gatt.device
        val deviceHashCode = device.hashCode()
        val peripheralArgs = peripheralsArgs[deviceHashCode] as MyPeripheralArgs
        val peripheralHashCodeArgs = peripheralArgs.hashCodeArgs
        // Check callbacks
        if (newState != BluetoothProfile.STATE_CONNECTED) {
            gatt.close()
            bluetoothGATTs.remove(peripheralHashCodeArgs)
            val error = IllegalStateException("GATT is disconnected with status: $status")
            val getMaximumWriteLengthCallback = getMaximumWriteLengthCallbacks.remove(peripheralHashCodeArgs)
            if (getMaximumWriteLengthCallback != null) {
                getMaximumWriteLengthCallback(Result.failure(error))
            }
            val readRssiCallback = readRssiCallbacks.remove(peripheralHashCodeArgs)
            if (readRssiCallback != null) {
                readRssiCallback(Result.failure(error))
            }
            val discoverGattCallback = discoverGattCallbacks.remove(peripheralHashCodeArgs)
            if (discoverGattCallback != null) {
                discoverGattCallback(Result.failure(error))
            }
            val servicesArgs = servicesArgsOfPeripherals[peripheralHashCodeArgs] ?: emptyList()
            for (serviceArgs in servicesArgs) {
                val characteristicsArgs = serviceArgs.characteristicsArgs.filterNotNull()
                for (characteristicArgs in characteristicsArgs) {
                    val characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
                    val readCharacteristicCallback = readCharacteristicCallbacks.remove(characteristicHashCodeArgs)
                    val writeCharacteristicCallback = writeCharacteristicCallbacks.remove(characteristicHashCodeArgs)
                    if (readCharacteristicCallback != null) {
                        readCharacteristicCallback(Result.failure(error))
                    }
                    if (writeCharacteristicCallback != null) {
                        writeCharacteristicCallback(Result.failure(error))
                    }
                    val descriptorsArgs = characteristicArgs.descriptorsArgs.filterNotNull()
                    for (descriptorArgs in descriptorsArgs) {
                        val descriptorHashCodeArgs = descriptorArgs.hashCodeArgs
                        val readDescriptorCallback = readDescriptorCallbacks.remove(descriptorHashCodeArgs)
                        val writeDescriptorCallback = writeDescriptorCallbacks.remove(descriptorHashCodeArgs)
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
        val connectCallback = connectCallbacks.remove(peripheralHashCodeArgs)
        val disconnectCallback = disconnectCallbacks.remove(peripheralHashCodeArgs)
        if (connectCallback == null && disconnectCallback == null) {
            // State changed.
            val stateArgs = newState == BluetoothProfile.STATE_CONNECTED
            api.onPeripheralStateChanged(peripheralArgs, stateArgs) {}
        } else {
            if (connectCallback != null) {
                if (status == BluetoothGatt.GATT_SUCCESS) {
                    // Connect succeed.
                    connectCallback(Result.success(Unit))
                    api.onPeripheralStateChanged(peripheralArgs, true) {}
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
                    api.onPeripheralStateChanged(peripheralArgs, false) {}
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
        val peripheralArgs = peripheralsArgs[hashCode] as MyPeripheralArgs
        val peripheralHashCodeArgs = peripheralArgs.hashCodeArgs
        val callback = getMaximumWriteLengthCallbacks.remove(peripheralHashCodeArgs) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val maximumWriteLengthArgs = (mtu - 3).toLong()
            callback(Result.success(maximumWriteLengthArgs))
        } else {
            val error = IllegalStateException("Get maximum write length failed with status: $status")
            callback(Result.failure(error))
        }
    }

    fun onReadRemoteRssi(gatt: BluetoothGatt, rssi: Int, status: Int) {
        val device = gatt.device
        val hashCode = device.hashCode()
        val peripheralArgs = peripheralsArgs[hashCode] as MyPeripheralArgs
        val peripheralHashCodeArgs = peripheralArgs.hashCodeArgs
        val callback = readRssiCallbacks.remove(peripheralHashCodeArgs) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val rssiArgs = rssi.toLong()
            callback(Result.success(rssiArgs))
        } else {
            val error = IllegalStateException("Read rssi failed with status: $status")
            callback(Result.failure(error))
        }
    }

    fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
        val device = gatt.device
        val deviceHashCode = device.hashCode()
        val peripheralArgs = peripheralsArgs[deviceHashCode] as MyPeripheralArgs
        val peripheralHashCodeArgs = peripheralArgs.hashCodeArgs
        val callback = discoverGattCallbacks.remove(peripheralHashCodeArgs) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val services = gatt.services
            val servicesArgs = mutableListOf<MyGattServiceArgs>()
            for (service in services) {
                val characteristics = service.characteristics
                val characteristicsArgs = mutableListOf<MyGattCharacteristicArgs>()
                for (characteristic in characteristics) {
                    val descriptors = characteristic.descriptors
                    val descriptorsArgs = mutableListOf<MyGattDescriptorArgs>()
                    for (descriptor in descriptors) {
                        val descriptorArgs = descriptor.toArgs()
                        val descriptorHashCode = descriptor.hashCode()
                        val descriptorHashCodeArgs = descriptorArgs.hashCodeArgs
                        this.descriptors[descriptorHashCodeArgs] = descriptor
                        this.descriptorsArgs[descriptorHashCode] = descriptorArgs
                        descriptorsArgs.add(descriptorArgs)
                    }
                    val characteristicArgs = characteristic.toArgs(descriptorsArgs)
                    val characteristicHashCode = characteristic.hashCode()
                    val characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
                    this.characteristics[characteristicHashCodeArgs] = characteristic
                    this.characteristicsArgs[characteristicHashCode] = characteristicArgs
                    characteristicsArgs.add(characteristicArgs)
                }
                val serviceArgs = service.toArgs(characteristicsArgs)
                val serviceHashCode = service.hashCode()
                val serviceHashCodeArgs = serviceArgs.hashCodeArgs
                this.services[serviceHashCodeArgs] = service
                this.servicesArgs[serviceHashCode] = serviceArgs
                servicesArgs.add(serviceArgs)
            }
            servicesArgsOfPeripherals[peripheralHashCodeArgs] = servicesArgs
            callback(Result.success(servicesArgs))
        } else {
            val error = IllegalStateException("Discover GATT failed with status: $status")
            callback(Result.failure(error))
        }
    }

    fun onCharacteristicRead(characteristic: BluetoothGattCharacteristic, status: Int, value: ByteArray) {
        val hashCode = characteristic.hashCode()
        val characteristicArgs = characteristicsArgs[hashCode] as MyGattCharacteristicArgs
        val characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
        val callback = readCharacteristicCallbacks.remove(characteristicHashCodeArgs) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(value))
        } else {
            val error = IllegalStateException("Read characteristic failed with status: $status.")
            callback(Result.failure(error))
        }
    }

    fun onCharacteristicWrite(characteristic: BluetoothGattCharacteristic, status: Int) {
        val hashCode = characteristic.hashCode()
        val characteristicArgs = characteristicsArgs[hashCode] as MyGattCharacteristicArgs
        val characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
        val callback = writeCharacteristicCallbacks.remove(characteristicHashCodeArgs) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val error = IllegalStateException("Write characteristic failed with status: $status.")
            callback(Result.failure(error))
        }
    }

    fun onCharacteristicChanged(characteristic: BluetoothGattCharacteristic, value: ByteArray) {
        val hashCode = characteristic.hashCode()
        val characteristicArgs = characteristicsArgs[hashCode] as MyGattCharacteristicArgs
        api.onCharacteristicValueChanged(characteristicArgs, value) {}
    }

    fun onDescriptorRead(descriptor: BluetoothGattDescriptor, status: Int, value: ByteArray) {
        val hashCode = descriptor.hashCode()
        val descriptorArgs = descriptorsArgs[hashCode] as MyGattDescriptorArgs
        val descriptorHashCodeArgs = descriptorArgs.hashCodeArgs
        val callback = readDescriptorCallbacks.remove(descriptorHashCodeArgs) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(value))
        } else {
            val error = IllegalStateException("Read descriptor failed with status: $status.")
            callback(Result.failure(error))
        }
    }

    fun onDescriptorWrite(descriptor: BluetoothGattDescriptor, status: Int) {
        val hashCode = descriptor.hashCode()
        val descriptorArgs = descriptorsArgs[hashCode] as MyGattDescriptorArgs
        val descriptorHashCodeArgs = descriptorArgs.hashCodeArgs
        val callback = writeDescriptorCallbacks.remove(descriptorHashCodeArgs) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val error = IllegalStateException("Write descriptor failed with status: $status.")
            callback(Result.failure(error))
        }
    }
}
