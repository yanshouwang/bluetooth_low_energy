package dev.yanshouwang.bluetooth_low_energy_android

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattServer
import android.bluetooth.BluetoothGattService
import android.bluetooth.BluetoothStatusCodes
import android.bluetooth.le.AdvertiseSettings
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger

class MyPeripheralManager(private val context: Context, binaryMessenger: BinaryMessenger) : MyBluetoothLowEnergyManager(context), MyPeripheralManagerHostApi {
    private val advertiser get() = adapter.bluetoothLeAdvertiser

    private val api = MyPeripheralManagerFlutterApi(binaryMessenger)
    private val bluetoothGattServerCallback = MyBluetoothGattServerCallback(this, executor)
    private val advertiseCallback = MyAdvertiseCallback(this)

    private val devices = mutableMapOf<Long, BluetoothDevice>()
    private val services = mutableMapOf<Long, BluetoothGattService>()
    private val characteristics = mutableMapOf<Long, BluetoothGattCharacteristic>()
    private val descriptors = mutableMapOf<Long, BluetoothGattDescriptor>()
    private val mtus = mutableMapOf<Long, Int>()
    private val confirms = mutableMapOf<Long, Boolean>()

    private val centralsArgs = mutableMapOf<Int, MyCentralArgs>()
    private val servicesArgs = mutableMapOf<Int, MyGattServiceArgs>()
    private val characteristicsArgs = mutableMapOf<Int, MyGattCharacteristicArgs>()
    private val descriptorsArgs = mutableMapOf<Int, MyGattDescriptorArgs>()

    private lateinit var server: BluetoothGattServer
    private var registered = false
    private var advertising = false

    private var setUpCallback: ((Result<MyPeripheralManagerArgs>) -> Unit)? = null
    private var addServiceCallback: ((Result<Unit>) -> Unit)? = null
    private var startAdvertisingCallback: ((Result<Unit>) -> Unit)? = null
    private val notifyCharacteristicValueChangedCallbacks = mutableMapOf<Long, (Result<Unit>) -> Unit>()

    override fun setUp(callback: (Result<MyPeripheralManagerArgs>) -> Unit) {
        try {
            val unfinishedCallback = setUpCallback
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            tearDown()
            if (unsupported) {
                val stateNumberArgs = MyBluetoothLowEnergyStateArgs.UNSUPPORTED.raw.toLong()
                val args = MyPeripheralManagerArgs(stateNumberArgs)
                callback(Result.success(args))
            }
            val permissions = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                arrayOf(android.Manifest.permission.ACCESS_COARSE_LOCATION, android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.BLUETOOTH_ADVERTISE, android.Manifest.permission.BLUETOOTH_CONNECT)
            } else {
                arrayOf(android.Manifest.permission.ACCESS_COARSE_LOCATION, android.Manifest.permission.ACCESS_FINE_LOCATION)
            }
            authorize(permissions)
            setUpCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    private fun tearDown() {
        if (registered) {
            unregister()
        }
        if (advertising) {
            stopAdvertising()
        }
        devices.clear()
        services.clear()
        characteristics.clear()
        descriptors.clear()
        mtus.clear()
        confirms.clear()
        centralsArgs.clear()
        servicesArgs.clear()
        characteristicsArgs.clear()
        descriptorsArgs.clear()
        setUpCallback = null
        addServiceCallback = null
        startAdvertisingCallback = null
        notifyCharacteristicValueChangedCallbacks.clear()
    }

    override fun register() {
        super.register()
        registered = true
    }

    override fun unregister() {
        super.unregister()
        registered = false
    }

    override fun addService(serviceArgs: MyGattServiceArgs, callback: (Result<Unit>) -> Unit) {
        try {
            val unfinishedCallback = addServiceCallback
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val service = serviceArgs.toService()
            val characteristicsArgs = serviceArgs.characteristicsArgs.filterNotNull()
            for (characteristicArgs in characteristicsArgs) {
                val characteristic = characteristicArgs.toCharacteristic()
                val cccDescriptor = BluetoothGattDescriptor(CLIENT_CHARACTERISTIC_CONFIG_UUID, BluetoothGattDescriptor.PERMISSION_READ or BluetoothGattDescriptor.PERMISSION_WRITE)
                val cccDescriptorAdded = characteristic.addDescriptor(cccDescriptor)
                if (!cccDescriptorAdded) {
                    throw IllegalStateException()
                }
                val descriptorsArgs = characteristicArgs.descriptorsArgs.filterNotNull()
                for (descriptorArgs in descriptorsArgs) {
                    val descriptor = descriptorArgs.toDescriptor()
                    if (descriptor.uuid == CLIENT_CHARACTERISTIC_CONFIG_UUID) {
                        // Already added.
                        continue
                    }
                    val descriptorAdded = characteristic.addDescriptor(descriptor)
                    if (!descriptorAdded) {
                        throw IllegalStateException()
                    }
                    val descriptorHashCodeArgs = descriptorArgs.hashCodeArgs
                    val descriptorHashCode = descriptor.hashCode()
                    this.descriptorsArgs[descriptorHashCode] = descriptorArgs
                    this.descriptors[descriptorHashCodeArgs] = descriptor
                }
                val characteristicAdded = service.addCharacteristic(characteristic)
                if (!characteristicAdded) {
                    throw IllegalStateException()
                }
                val characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
                val characteristicHashCode = characteristic.hashCode()
                this.characteristicsArgs[characteristicHashCode] = characteristicArgs
                this.characteristics[characteristicHashCodeArgs] = characteristic
            }
            val adding = server.addService(service)
            if (!adding) {
                throw IllegalStateException()
            }
            val serviceHashCodeArgs = serviceArgs.hashCodeArgs
            val serviceHashCode = service.hashCode()
            this.servicesArgs[serviceHashCode] = serviceArgs
            this.services[serviceHashCodeArgs] = service
            addServiceCallback = callback
        } catch (e: Throwable) {
            freeService(serviceArgs)
            callback(Result.failure(e))
        }
    }

    override fun removeService(serviceHashCodeArgs: Long) {
        val service = services[serviceHashCodeArgs] as BluetoothGattService
        val serviceHashCode = service.hashCode()
        val serviceArgs = servicesArgs[serviceHashCode] as MyGattServiceArgs
        val removed = server.removeService(service)
        if (!removed) {
            throw IllegalStateException()
        }
        freeService(serviceArgs)
    }

    private fun freeService(serviceArgs: MyGattServiceArgs) {
        val characteristicsArgs = serviceArgs.characteristicsArgs.filterNotNull()
        for (characteristicArgs in characteristicsArgs) {
            val descriptorsArgs = characteristicArgs.descriptorsArgs.filterNotNull()
            for (descriptorArgs in descriptorsArgs) {
                val descriptorHashCodeArgs = descriptorArgs.hashCodeArgs
                val descriptor = this.descriptors.remove(descriptorHashCodeArgs) ?: continue
                val descriptorHashCode = descriptor.hashCode()
                this.descriptorsArgs.remove(descriptorHashCode)
            }
            val characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
            val characteristic = this.characteristics.remove(characteristicHashCodeArgs) ?: continue
            this.confirms.remove(characteristicHashCodeArgs)
            val characteristicHashCode = characteristic.hashCode()
            this.characteristicsArgs.remove(characteristicHashCode)
        }
        val serviceHashCodeArgs = serviceArgs.hashCodeArgs
        val service = services.remove(serviceHashCodeArgs) ?: return
        val serviceHashCode = service.hashCode()
        servicesArgs.remove(serviceHashCode)
    }

    override fun clearServices() {
        server.clearServices()
        val servicesArgs = this.servicesArgs.values
        for (serviceArgs in servicesArgs) {
            freeService(serviceArgs)
        }
    }

    override fun startAdvertising(advertiseDataArgs: MyAdvertiseDataArgs, callback: (Result<Unit>) -> Unit) {
        try {
            if (startAdvertisingCallback != null) {
                throw IllegalStateException()
            }
            val settings = AdvertiseSettings.Builder().setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_BALANCED).setConnectable(true).build()
            val advertiseData = advertiseDataArgs.toAdvertiseData(adapter)
            advertiser.startAdvertising(settings, advertiseData, advertiseCallback)
            startAdvertisingCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun stopAdvertising() {
        advertiser.stopAdvertising(advertiseCallback)
        advertising = false
    }

    override fun getMaximumWriteLength(centralHashCodeArgs: Long): Long {
        val mtu = mtus[centralHashCodeArgs] ?: 23
        return (mtu - 3).toLong()
    }

    override fun sendReadCharacteristicReply(centralHashCodeArgs: Long, characteristicHashCodeArgs: Long, idArgs: Long, offsetArgs: Long, statusArgs: Boolean, valueArgs: ByteArray) {
        val device = devices[centralHashCodeArgs] as BluetoothDevice
        val requestId = idArgs.toInt()
        val status = if (statusArgs) BluetoothGatt.GATT_SUCCESS
        else BluetoothGatt.GATT_FAILURE
        val offset = offsetArgs.toInt()
        val sent = server.sendResponse(device, requestId, status, offset, valueArgs)
        if (!sent) {
            throw IllegalStateException("Send read characteristic reply failed.")
        }
    }

    override fun sendWriteCharacteristicReply(centralHashCodeArgs: Long, characteristicHashCodeArgs: Long, idArgs: Long, offsetArgs: Long, statusArgs: Boolean) {
        val device = devices[centralHashCodeArgs] as BluetoothDevice
        val requestId = idArgs.toInt()
        val status = if (statusArgs) BluetoothGatt.GATT_SUCCESS
        else BluetoothGatt.GATT_FAILURE
        val offset = offsetArgs.toInt()
        val value = null
        val sent = server.sendResponse(device, requestId, status, offset, value)
        if (!sent) {
            throw IllegalStateException("Send write characteristic reply failed.")
        }
    }

    override fun notifyCharacteristicValueChanged(centralHashCodeArgs: Long, characteristicHashCodeArgs: Long, valueArgs: ByteArray, callback: (Result<Unit>) -> Unit) {
        try {
            val unfinishedCallback = notifyCharacteristicValueChangedCallbacks[centralHashCodeArgs]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val device = devices[centralHashCodeArgs] as BluetoothDevice
            val characteristic = characteristics[characteristicHashCodeArgs] as BluetoothGattCharacteristic
            val confirm = confirms[characteristicHashCodeArgs]
                    ?: throw IllegalStateException("The characteristic is not subscribed.")
            val notifying = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val statusCode = server.notifyCharacteristicChanged(device, characteristic, confirm, valueArgs)
                statusCode == BluetoothStatusCodes.SUCCESS
            } else {
                characteristic.value = valueArgs
                server.notifyCharacteristicChanged(device, characteristic, confirm)
            }
            if (!notifying) {
                throw IllegalStateException()
            }
            notifyCharacteristicValueChangedCallbacks[centralHashCodeArgs] = callback
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
        val args = MyPeripheralManagerArgs(stateNumberArgs)
        if (stateArgs == MyBluetoothLowEnergyStateArgs.POWEREDON) {
            server = manager.openGattServer(context, bluetoothGattServerCallback)
        }
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
        if (stateArgs == MyBluetoothLowEnergyStateArgs.POWEREDON) {
            server = manager.openGattServer(context, bluetoothGattServerCallback)
        }
        val stateNumberArgs = stateArgs.raw.toLong()
        api.onStateChanged(stateNumberArgs) {}
    }

    fun onServiceAdded(status: Int, service: BluetoothGattService) {
        val callback = addServiceCallback ?: return
        addServiceCallback = null
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val hashCode = service.hashCode()
            val serviceArgs = servicesArgs[hashCode] as MyGattServiceArgs
            freeService(serviceArgs)
            val error = IllegalStateException("Read rssi failed with status: $status")
            callback(Result.failure(error))
        }
    }

    fun onStartSuccess(settingsInEffect: AdvertiseSettings) {
        advertising = true
        val callback = startAdvertisingCallback ?: return
        startAdvertisingCallback = null
        callback(Result.success(Unit))
    }

    fun onStartFailure(errorCode: Int) {
        val callback = startAdvertisingCallback ?: return
        startAdvertisingCallback = null
        val error = IllegalStateException("Start advertising failed with error code: $errorCode")
        callback(Result.failure(error))
    }

    fun onMtuChanged(device: BluetoothDevice, mtu: Int) {
        val hashCode = device.hashCode()
        val centralArgs = centralsArgs.getOrPut(hashCode) { device.toCentralArgs() }
        val centralHashCodeArgs = centralArgs.hashCodeArgs
        devices[centralHashCodeArgs] = device
        mtus[centralHashCodeArgs] = mtu
    }

    fun onCharacteristicReadRequest(device: BluetoothDevice, requestId: Int, offset: Int, characteristic: BluetoothGattCharacteristic) {
        val deviceHashCode = device.hashCode()
        val centralArgs = centralsArgs.getOrPut(deviceHashCode) { device.toCentralArgs() }
        val centralHashCodeArgs = centralArgs.hashCodeArgs
        devices[centralHashCodeArgs] = device
        val characteristicHashCode = characteristic.hashCode()
        val characteristicArgs = characteristicsArgs[characteristicHashCode] as MyGattCharacteristicArgs
        val idArgs = requestId.toLong()
        val offsetArgs = offset.toLong()
        api.onReadCharacteristicCommandReceived(centralArgs, characteristicArgs, idArgs, offsetArgs) {}
    }

    fun onCharacteristicWriteRequest(device: BluetoothDevice, requestId: Int, characteristic: BluetoothGattCharacteristic, preparedWrite: Boolean, responseNeeded: Boolean, offset: Int, value: ByteArray) {
        val deviceHashCode = device.hashCode()
        val centralArgs = centralsArgs.getOrPut(deviceHashCode) { device.toCentralArgs() }
        val centralHashCodeArgs = centralArgs.hashCodeArgs
        devices[centralHashCodeArgs] = device
        val characteristicHashCode = characteristic.hashCode()
        val characteristicArgs = characteristicsArgs[characteristicHashCode] as MyGattCharacteristicArgs
        val idArgs = requestId.toLong()
        val offsetArgs = offset.toLong()
        api.onWriteCharacteristicCommandReceived(centralArgs, characteristicArgs, idArgs, offsetArgs, value) {}
    }

    fun onDescriptorReadRequest(device: BluetoothDevice, requestId: Int, offset: Int, descriptor: BluetoothGattDescriptor) {
        val status = BluetoothGatt.GATT_SUCCESS
        val descriptorHashCode = descriptor.hashCode()
        val descriptorArgs = descriptorsArgs[descriptorHashCode] as MyGattDescriptorArgs
        val value = descriptorArgs.valueArgs
        val sent = server.sendResponse(device, requestId, status, offset, value)
        if (!sent) {
            Log.e(TAG, "onDescriptorReadRequest: send response failed.")
        }
    }

    fun onDescriptorWriteRequest(device: BluetoothDevice, requestId: Int, descriptor: BluetoothGattDescriptor, preparedWrite: Boolean, responseNeeded: Boolean, offset: Int, value: ByteArray) {
        val status = if (descriptor.uuid == CLIENT_CHARACTERISTIC_CONFIG_UUID) {
            val deviceHashCode = device.hashCode()
            val centralArgs = centralsArgs.getOrPut(deviceHashCode) { device.toCentralArgs() }
            val centralHashCodeArgs = centralArgs.hashCodeArgs
            devices[centralHashCodeArgs] = device
            val characteristic = descriptor.characteristic
            val characteristicHashCode = characteristic.hashCode()
            val characteristicArgs = characteristicsArgs[characteristicHashCode] as MyGattCharacteristicArgs
            val characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
            // TODO: what is 中缀?
            if (value contentEquals BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE) {
                confirms[characteristicHashCodeArgs] = false
                val stateArgs = true
                api.onNotifyCharacteristicCommandReceived(centralArgs, characteristicArgs, stateArgs) {}
                BluetoothGatt.GATT_SUCCESS
            } else if (value contentEquals BluetoothGattDescriptor.ENABLE_INDICATION_VALUE) {
                confirms[characteristicHashCodeArgs] = true
                val stateArgs = true
                api.onNotifyCharacteristicCommandReceived(centralArgs, characteristicArgs, stateArgs) {}
                BluetoothGatt.GATT_SUCCESS
            } else if (value contentEquals BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE) {
                confirms.remove(characteristicHashCodeArgs)
                val stateArgs = false
                api.onNotifyCharacteristicCommandReceived(centralArgs, characteristicArgs, stateArgs) {}
                BluetoothGatt.GATT_SUCCESS
            } else {
                BluetoothGatt.GATT_REQUEST_NOT_SUPPORTED
            }
        } else BluetoothGatt.GATT_SUCCESS
        val sent = server.sendResponse(device, requestId, status, offset, value)
        if (!sent) {
            Log.e(TAG, "onDescriptorReadRequest: send response failed.")
        }
    }

    fun onNotificationSent(device: BluetoothDevice, status: Int) {
        val deviceHashCode = device.hashCode()
        val centralArgs = centralsArgs[deviceHashCode] as MyCentralArgs
        val centralHashCodeArgs = centralArgs.hashCodeArgs
        val callback = notifyCharacteristicValueChangedCallbacks.remove(centralHashCodeArgs)
                ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val error = IllegalStateException("Notify characteristic value changed failed with status: $status")
            callback(Result.failure(error))
        }
    }
}