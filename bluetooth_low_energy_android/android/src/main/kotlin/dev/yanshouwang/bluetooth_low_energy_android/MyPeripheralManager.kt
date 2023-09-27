package dev.yanshouwang.bluetooth_low_energy_android

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattService
import android.bluetooth.BluetoothStatusCodes
import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.AdvertiseSettings
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.ParcelUuid
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger

class MyPeripheralManager(private val context: Context, binaryMessenger: BinaryMessenger) : MyBluetoothLowEnergyManager(context), MyPeripheralManagerHostApi {
    private val server by lazy { manager.openGattServer(context, myBluetoothGattServerCallback) }
    private val advertiser get() = adapter.bluetoothLeAdvertiser

    private val myApi = MyPeripheralManagerFlutterApi(binaryMessenger)
    private val myBluetoothGattServerCallback = MyBluetoothGattServerCallback(this, executor)
    private val myAdvertiseCallback = MyAdvertiseCallback(this)

    // Native cache
    private val devices = mutableMapOf<Long, BluetoothDevice>()
    private val mtus = mutableMapOf<Long, Int>()
    private val services = mutableMapOf<Long, BluetoothGattService>()
    private val characteristics = mutableMapOf<Long, BluetoothGattCharacteristic>()
    private val descriptors = mutableMapOf<Long, BluetoothGattDescriptor>()
    private val confirms = mutableMapOf<Long, Boolean>()

    // My cache
    private val myCentrals = mutableMapOf<Int, MyCentralArgs>()
    private val myServices = mutableMapOf<Int, MyGattServiceArgs>()
    private val myCharacteristics = mutableMapOf<Int, MyGattCharacteristicArgs>()
    private val myDescriptors = mutableMapOf<Int, MyGattDescriptorArgs>()

    private var registered = false

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
                val stateNumber = MyBluetoothLowEnergyStateArgs.UNSUPPORTED.raw.toLong()
                val args = MyPeripheralManagerArgs(stateNumber)
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

    override fun addService(myServiceArgs: MyGattServiceArgs, callback: (Result<Unit>) -> Unit) {
        try {
            val unfinishedCallback = addServiceCallback
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val service = myServiceArgs.toService()
            val myCharacteristics = myServiceArgs.myCharacteristicArgses.filterNotNull()
            for (myCharacteristic in myCharacteristics) {
                val characteristic = myCharacteristic.toCharacteristic()
                val myDescriptors = myCharacteristic.myDescriptorArgses.filterNotNull()
                for (myDescriptor in myDescriptors) {
                    val descriptor = myDescriptor.toDescriptor()
                    val descriptorAdded = characteristic.addDescriptor(descriptor)
                    if (!descriptorAdded) {
                        throw IllegalStateException()
                    }
                    val myDescriptorHashCode = myDescriptor.myHashCode
                    val descriptorHashCode = descriptor.hashCode()
                    this.myDescriptors[descriptorHashCode] = myDescriptor
                    this.descriptors[myDescriptorHashCode] = descriptor
                }
                val characteristicAdded = service.addCharacteristic(characteristic)
                if (!characteristicAdded) {
                    throw IllegalStateException()
                }
                val myCharacteristicHashCode = myCharacteristic.myHashCode
                val characteristicHashCode = characteristic.hashCode()
                this.myCharacteristics[characteristicHashCode] = myCharacteristic
                this.characteristics[myCharacteristicHashCode] = characteristic
                // TODO: Notify 可用时是否需要添加 CCCD
            }
            val adding = server.addService(service)
            if (!adding) {
                throw IllegalStateException()
            }
            val myServiceHashCode = myServiceArgs.myHashCode
            val serviceHashCode = service.hashCode()
            this.myServices[serviceHashCode] = myServiceArgs
            this.services[myServiceHashCode] = service
            addServiceCallback = callback
        } catch (e: Throwable) {
            freeService(myServiceArgs)
            callback(Result.failure(e))
        }
    }

    override fun removeService(myServiceHashCode: Long) {
        val service = services[myServiceHashCode] as BluetoothGattService
        val serviceHashCode = service.hashCode()
        val myService = myServices[serviceHashCode] as MyGattServiceArgs
        val removed = server.removeService(service)
        if (!removed) {
            throw IllegalStateException()
        }
        freeService(myService)
    }

    private fun freeService(myService: MyGattServiceArgs) {
        val myCharacteristics = myService.myCharacteristicArgses.filterNotNull()
        for (myCharacteristic in myCharacteristics) {
            val myDescriptors = myCharacteristic.myDescriptorArgses.filterNotNull()
            for (myDescriptor in myDescriptors) {
                val myDescriptorHashCode = myDescriptor.myHashCode
                val descriptor = this.descriptors.remove(myDescriptorHashCode) ?: continue
                val descriptorHashCode = descriptor.hashCode()
                this.myDescriptors.remove(descriptorHashCode)
            }
            val myCharacteristicHashCode = myCharacteristic.myHashCode
            val characteristic = this.characteristics.remove(myCharacteristicHashCode) ?: continue
            this.confirms.remove(myCharacteristicHashCode)
            val characteristicHashCode = characteristic.hashCode()
            this.myCharacteristics.remove(characteristicHashCode)
        }
        val myServiceHashCode = myService.myHashCode
        val service = services.remove(myServiceHashCode) ?: return
        val serviceHashCode = service.hashCode()
        myServices.remove(serviceHashCode)
    }

    override fun clearServices() {
        server.clearServices()
        val myServices = this.myServices.values
        for (myService in myServices) {
            freeService(myService)
        }
    }

    override fun startAdvertising(myAdvertisementArgs: MyAdvertisementArgs, callback: (Result<Unit>) -> Unit) {
        try {
            if (startAdvertisingCallback != null) {
                throw IllegalStateException()
            }
            val settings = AdvertiseSettings.Builder().setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_BALANCED).setConnectable(true).build()
            val advertiseDataBuilder = AdvertiseData.Builder()
            val myName = myAdvertisementArgs.myName
            if (myName == null) {
                advertiseDataBuilder.setIncludeDeviceName(false)
            } else {
                adapter.name = myName
                advertiseDataBuilder.setIncludeDeviceName(true)
            }
            val myServiceUUIDs = myAdvertisementArgs.myServiceUUIDs.filterNotNull()
            for (myServiceUUID in myServiceUUIDs) {
                val serviceUUID = ParcelUuid.fromString(myServiceUUID)
                advertiseDataBuilder.addServiceUuid(serviceUUID)
            }
            val myServiceData = myAdvertisementArgs.myServiceData
            for (entry in myServiceData) {
                val serviceDataUUID = ParcelUuid.fromString(entry.key as String)
                val serviceData = entry.value as ByteArray
                advertiseDataBuilder.addServiceData(serviceDataUUID, serviceData)
            }
            val myManufacturerSpecificData = myAdvertisementArgs.myManufacturerSpecificData
            for (entry in myManufacturerSpecificData) {
//                val manufacturerId = (entry.key as Long).toInt()
                // TODO: Wrong type cast:  java.lang.Integer cannot be cast to java.lang.Long
                val manufacturerId = entry.key?.toInt() ?: throw IllegalArgumentException()
                val manufacturerSpecificData = entry.value as ByteArray
                advertiseDataBuilder.addManufacturerData(manufacturerId, manufacturerSpecificData)
            }
            val advertiseData = advertiseDataBuilder.build()
            advertiser.startAdvertising(settings, advertiseData, myAdvertiseCallback)
            startAdvertisingCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun stopAdvertising() {
        advertiser.stopAdvertising(myAdvertiseCallback)
    }

    override fun getMaximumWriteLength(myCentralHashCode: Long): Long {
        val mtu = mtus[myCentralHashCode] ?: 20
        return mtu.toLong()
    }

    override fun sendReadCharacteristicReply(myCentralHashCode: Long, myCharacteristicHashCode: Long, myId: Long, myOffset: Long, myStatus: Boolean, myValue: ByteArray) {
        val device = devices[myCentralHashCode] as BluetoothDevice
        val requestId = myId.toInt()
        val status = if (myStatus) BluetoothGatt.GATT_SUCCESS
        else BluetoothGatt.GATT_FAILURE
        val offset = myOffset.toInt()
        val sent = server.sendResponse(device, requestId, status, offset, myValue)
        if (!sent) {
            throw IllegalStateException("Send read characteristic reply failed.")
        }
    }

    override fun sendWriteCharacteristicReply(myCentralHashCode: Long, myCharacteristicHashCode: Long, myId: Long, myOffset: Long, myStatus: Boolean) {
        val device = devices[myCentralHashCode] as BluetoothDevice
        val requestId = myId.toInt()
        val status = if (myStatus) BluetoothGatt.GATT_SUCCESS
        else BluetoothGatt.GATT_FAILURE
        val offset = myOffset.toInt()
        val value = null
        val sent = server.sendResponse(device, requestId, status, offset, value)
        if (!sent) {
            throw IllegalStateException("Send write characteristic reply failed.")
        }
    }

    override fun notifyCharacteristicValueChanged(myCentralHashCode: Long, myCharacteristicHashCode: Long, myValue: ByteArray, callback: (Result<Unit>) -> Unit) {
        try {
            val unfinishedCallback = notifyCharacteristicValueChangedCallbacks[myCentralHashCode]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val device = devices[myCentralHashCode] as BluetoothDevice
            val characteristic = characteristics[myCharacteristicHashCode] as BluetoothGattCharacteristic
            val confirm = confirms[myCharacteristicHashCode]
                    ?: throw IllegalStateException("The characteristic is not subscribed.")
            val notifying = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val statusCode = server.notifyCharacteristicChanged(device, characteristic, confirm, myValue)
                statusCode == BluetoothStatusCodes.SUCCESS
            } else {
                characteristic.value = myValue
                server.notifyCharacteristicChanged(device, characteristic, confirm)
            }
            if (!notifying) {
                throw IllegalStateException()
            }
            notifyCharacteristicValueChangedCallbacks[myCentralHashCode] = callback
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
        val myArgs = MyPeripheralManagerArgs(myStateNumber)
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

    fun onServiceAdded(status: Int, service: BluetoothGattService) {
        val callback = addServiceCallback ?: return
        addServiceCallback = null
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val hashCode = service.hashCode()
            val myService = myServices[hashCode] as MyGattServiceArgs
            freeService(myService)
            val error = IllegalStateException("Read rssi failed with status: $status")
            callback(Result.failure(error))
        }
    }

    fun onMtuChanged(device: BluetoothDevice, mtu: Int) {
        val hashCode = device.hashCode()
        val myCentral = myCentrals.getOrPut(hashCode) { device.toMyCentralArgs() }
        val myHashCode = myCentral.myHashCode
        mtus[myHashCode] = mtu
    }

    fun onCharacteristicReadRequest(device: BluetoothDevice, requestId: Int, offset: Int, characteristic: BluetoothGattCharacteristic) {
        val deviceHashCode = device.hashCode()
        val myCentral = myCentrals.getOrPut(deviceHashCode) { device.toMyCentralArgs() }
        val characteristicHashCode = characteristic.hashCode()
        val myCharacteristic = myCharacteristics[characteristicHashCode] as MyGattCharacteristicArgs
        val myId = requestId.toLong()
        val myOffset = offset.toLong()
        myApi.onReadCharacteristicCommandReceived(myCentral, myCharacteristic, myId, myOffset) {}
    }

    fun onCharacteristicWriteRequest(device: BluetoothDevice, requestId: Int, characteristic: BluetoothGattCharacteristic, preparedWrite: Boolean, responseNeeded: Boolean, offset: Int, value: ByteArray) {
        val deviceHashCode = device.hashCode()
        val myCentral = myCentrals.getOrPut(deviceHashCode) { device.toMyCentralArgs() }
        val characteristicHashCode = characteristic.hashCode()
        val myCharacteristic = myCharacteristics[characteristicHashCode] as MyGattCharacteristicArgs
        val myId = requestId.toLong()
        val myOffset = offset.toLong()
        myApi.onWriteCharacteristicCommandReceived(myCentral, myCharacteristic, myId, myOffset, value) {}
    }

    fun onNotificationSent(device: BluetoothDevice, status: Int) {
        val hashCode = device.hashCode()
        val myCentral = myCentrals[hashCode] as MyCentralArgs
        val myHashCode = myCentral.myHashCode
        val callback = notifyCharacteristicValueChangedCallbacks.remove(myHashCode) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val error = IllegalStateException("Notify characteristic value changed failed with status: $status")
            callback(Result.failure(error))
        }
    }

    fun onDescriptorReadRequest(device: BluetoothDevice, requestId: Int, offset: Int, descriptor: BluetoothGattDescriptor) {
        val status = BluetoothGatt.GATT_SUCCESS
        val hashCode = descriptor.hashCode()
        val myDescriptor = myDescriptors[hashCode] as MyGattDescriptorArgs
        val value = myDescriptor.myValue
        val sent = server.sendResponse(device, requestId, status, offset, value)
        if (!sent) {
            Log.e(TAG, "onDescriptorReadRequest: send response failed.")
        }
    }

    fun onDescriptorWriteRequest(device: BluetoothDevice, requestId: Int, descriptor: BluetoothGattDescriptor, preparedWrite: Boolean, responseNeeded: Boolean, offset: Int, value: ByteArray) {
        val status = if (descriptor.uuid == CLIENT_CHARACTERISTIC_CONFIG_UUID) {
            val deviceHashCode = device.hashCode()
            val myCentral = myCentrals.getOrPut(deviceHashCode) { device.toMyCentralArgs() }
            val characteristic = descriptor.characteristic
            val characteristicHashCode = characteristic.hashCode()
            val myCharacteristic = myCharacteristics[characteristicHashCode] as MyGattCharacteristicArgs
            val myCharacteristicHashCode = myCharacteristic.myHashCode
            // TODO: what is 中缀?
//            if (value contentEquals BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE) {
//            } else if (value contentEquals BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE) {
//            } else if (value contentEquals BluetoothGattDescriptor.ENABLE_INDICATION_VALUE) {
//            } else {
//            }
            when (value) {
                BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE -> {
                    confirms[myCharacteristicHashCode] = false
                    val myState = true
                    myApi.onNotifyCharacteristicCommandReceived(myCentral, myCharacteristic, myState) {}
                    BluetoothGatt.GATT_SUCCESS
                }

                BluetoothGattDescriptor.ENABLE_INDICATION_VALUE -> {
                    confirms[myCharacteristicHashCode] = true
                    val myState = true
                    myApi.onNotifyCharacteristicCommandReceived(myCentral, myCharacteristic, myState) {}
                    BluetoothGatt.GATT_SUCCESS
                }

                BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE -> {
                    confirms.remove(myCharacteristicHashCode)
                    val myState = false
                    myApi.onNotifyCharacteristicCommandReceived(myCentral, myCharacteristic, myState) {}
                    BluetoothGatt.GATT_SUCCESS
                }

                else -> BluetoothGatt.GATT_REQUEST_NOT_SUPPORTED
            }
        } else BluetoothGatt.GATT_REQUEST_NOT_SUPPORTED
        val sent = server.sendResponse(device, requestId, status, offset, value)
        if (!sent) {
            Log.e(TAG, "onDescriptorReadRequest: send response failed.")
        }
    }

    fun onStartSuccess(settingsInEffect: AdvertiseSettings) {
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
}