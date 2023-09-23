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

    // My cache
    private val myCentrals = mutableMapOf<Int, MyCentralArgs>()
    private val myServices = mutableMapOf<Int, MyCustomizedGattServiceArgs>()
    private val myCharacteristics = mutableMapOf<Int, MyCustomizedGattCharacteristicArgs>()
    private val myDescriptors = mutableMapOf<Int, MyCustomizedGattDescriptorArgs>()

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

    override fun addService(myServiceArgs: MyCustomizedGattServiceArgs, callback: (Result<Unit>) -> Unit) {
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
                    val myDescriptorKey = myDescriptor.myKey
                    val descriptorKey = descriptor.hashCode()
                    this.myDescriptors[descriptorKey] = myDescriptor
                    this.descriptors[myDescriptorKey] = descriptor
                }
                val characteristicAdded = service.addCharacteristic(characteristic)
                if (!characteristicAdded) {
                    throw IllegalStateException()
                }
                val myCharacteristicKey = myCharacteristic.myKey
                val characteristicKey = characteristic.hashCode()
                this.myCharacteristics[characteristicKey] = myCharacteristic
                this.characteristics[myCharacteristicKey] = characteristic
                // TODO: Notify 可用时是否需要添加 CCCD
            }
            val adding = server.addService(service)
            if (!adding) {
                throw IllegalStateException()
            }
            val myServiceKey = myServiceArgs.myKey
            val serviceKey = service.hashCode()
            this.myServices[serviceKey] = myServiceArgs
            this.services[myServiceKey] = service
            addServiceCallback = callback
        } catch (e: Throwable) {
            freeService(myServiceArgs)
            callback(Result.failure(e))
        }
    }

    override fun removeService(myServiceKey: Long) {
        val service = services[myServiceKey] as BluetoothGattService
        val serviceKey = service.hashCode()
        val myService = myServices[serviceKey] as MyCustomizedGattServiceArgs
        val removed = server.removeService(service)
        if (!removed) {
            throw IllegalStateException()
        }
        freeService(myService)
    }

    private fun freeService(myService: MyCustomizedGattServiceArgs) {
        val myCharacteristics = myService.myCharacteristicArgses.filterNotNull()
        for (myCharacteristic in myCharacteristics) {
            val myDescriptors = myCharacteristic.myDescriptorArgses.filterNotNull()
            for (myDescriptor in myDescriptors) {
                val myDescriptorKey = myDescriptor.myKey
                val descriptor = this.descriptors.remove(myDescriptorKey) ?: continue
                val descriptorKey = descriptor.hashCode()
                this.myDescriptors.remove(descriptorKey)
            }
            val myCharacteristicKey = myCharacteristic.myKey
            val characteristic = this.characteristics.remove(myCharacteristicKey) ?: continue
            val characteristicKey = characteristic.hashCode()
            this.myCharacteristics.remove(characteristicKey)
        }
        val myServiceKey = myService.myKey
        val service = services.remove(myServiceKey) ?: return
        val serviceKey = service.hashCode()
        myServices.remove(serviceKey)
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
                val manufacturerId = (entry.key as Long).toInt()
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

    override fun getMaximumWriteLength(myCentralKey: Long): Long {
        val mtu = mtus[myCentralKey] ?: 20
        return mtu.toLong()
    }

    override fun sendReadCharacteristicReply(myCentralKey: Long, myCharacteristicKey: Long, myStatusNumber: Long, myValue: ByteArray) {
        val sent = server.sendResponse(device, requestId, status, offset, value)
    }

    override fun sendWriteCharacteristicReply(myCentralKey: Long, myCharacteristicKey: Long, myStatusNumber: Long) {
        val sent = server.sendResponse(device, requestId, status, offset, value)
    }

    override fun notifyCharacteristicValueChanged(myCentralKey: Long, myCharacteristicKey: Long, myValue: ByteArray, callback: (Result<Unit>) -> Unit) {
        try {
            val unfinishedCallback = notifyCharacteristicValueChangedCallbacks[myCentralKey]
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val device = devices[myCentralKey] as BluetoothDevice
            val characteristic = characteristics[myCharacteristicKey] as BluetoothGattCharacteristic
            val confirm = // TODO: 获取 confirm
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
            notifyCharacteristicValueChangedCallbacks[myCentralKey] = callback
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
            val key = service.hashCode()
            val myService = myServices[key] as MyCustomizedGattServiceArgs
            freeService(myService)
            val error = IllegalStateException("Read rssi failed with status: $status")
            callback(Result.failure(error))
        }
    }

    fun onMtuChanged(device: BluetoothDevice, mtu: Int) {
        val key = device.hashCode()
        val myCentral = myCentrals.getOrPut(key) { device.toMyCentralArgs() }
        val myKey = myCentral.myKey
        mtus[myKey] = mtu
    }

    fun onCharacteristicReadRequest(device: BluetoothDevice, requestId: Int, offset: Int, characteristic: BluetoothGattCharacteristic) {
        val deviceKey = device.hashCode()
        val myCentral = myCentrals.getOrPut(deviceKey) { device.toMyCentralArgs() }
        val characteristicKey = characteristic.hashCode()
        val myCharacteristic = myCharacteristics[characteristicKey] as MyCustomizedGattCharacteristicArgs
        myApi.onReadCharacteristicCommandReceived(myCentral, myCharacteristic) {}
    }

    fun onCharacteristicWriteRequest(device: BluetoothDevice, requestId: Int, characteristic: BluetoothGattCharacteristic, preparedWrite: Boolean, responseNeeded: Boolean, offset: Int, value: ByteArray) {
        val deviceKey = device.hashCode()
        val myCentral = myCentrals.getOrPut(deviceKey) { device.toMyCentralArgs() }
        val characteristicKey = characteristic.hashCode()
        val myCharacteristic = myCharacteristics[characteristicKey] as MyCustomizedGattCharacteristicArgs
        myApi.onWriteCharacteristicCommandReceived(myCentral, myCharacteristic, value) {}
    }

    fun onNotificationSent(device: BluetoothDevice, status: Int) {
        val key = device.hashCode()
        val myCentral = myCentrals[key] as MyCentralArgs
        val myKey = myCentral.myKey
        val callback = notifyCharacteristicValueChangedCallbacks.remove(myKey) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val error = IllegalStateException("Notify characteristic value changed failed with status: $status")
            callback(Result.failure(error))
        }
    }

    fun onDescriptorReadRequest(device: BluetoothDevice, requestId: Int, offset: Int, descriptor: BluetoothGattDescriptor) {
        val status = BluetoothGatt.GATT_SUCCESS
        val descriptorKey = descriptor.hashCode()
        val myDescriptor = myDescriptors[descriptorKey] as MyCustomizedGattDescriptorArgs
        val value = myDescriptor.myValue
        val sent = server.sendResponse(device, requestId, status, offset, value)
        if (!sent) {
            Log.e(TAG, "onDescriptorReadRequest: send response failed.")
        }
    }

    fun onDescriptorWriteRequest(device: BluetoothDevice, requestId: Int, descriptor: BluetoothGattDescriptor, preparedWrite: Boolean, responseNeeded: Boolean, offset: Int, value: ByteArray) {
        val status = BluetoothGatt.GATT_SUCCESS
        if (descriptor.uuid == CLIENT_CHARACTERISTIC_CONFIG_UUID) {
            val deviceKey = device.hashCode()
            val myCentral = myCentrals.getOrPut(deviceKey) { device.toMyCentralArgs() }
            val characteristic = descriptor.characteristic
            val characteristicKey = characteristic.hashCode()
            val myCharacteristic = myCharacteristics[characteristicKey] as MyCustomizedGattCharacteristicArgs
            // TODO: what is 中缀?
            val state = value contentEquals BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE || value contentEquals BluetoothGattDescriptor.ENABLE_INDICATION_VALUE
            myApi.onNotifyCharacteristicCommandReceived(myCentral, myCharacteristic, state) {}
        }
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