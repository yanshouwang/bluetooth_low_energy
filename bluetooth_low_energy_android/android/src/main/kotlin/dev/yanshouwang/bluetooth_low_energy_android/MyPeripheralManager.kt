package dev.yanshouwang.bluetooth_low_energy_android

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattServer
import android.bluetooth.BluetoothGattServerCallback
import android.bluetooth.BluetoothGattService
import android.bluetooth.BluetoothProfile
import android.bluetooth.BluetoothStatusCodes
import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseSettings
import android.content.Context
import android.os.Build
import io.flutter.plugin.common.BinaryMessenger

class MyPeripheralManager(context: Context, binaryMessenger: BinaryMessenger) : MyBluetoothLowEnergyManager(context), MyPeripheralManagerHostAPI {
    companion object {
        const val REQUEST_CODE = 445
    }

    private val advertiser get() = adapter.bluetoothLeAdvertiser

    private val mContext: Context
    private val mAPI: MyPeripheralManagerFlutterAPI

    private val bluetoothGattServerCallback: BluetoothGattServerCallback by lazy {
        MyBluetoothGattServerCallback(this, executor)
    }
    private val advertiseCallback: AdvertiseCallback by lazy {
        MyAdvertiseCallback(this)
    }

    private lateinit var mServer: BluetoothGattServer
    private var mOpening = false
    private var mAdvertising = false

    private val mServicesArgs: MutableMap<Int, MyGattServiceArgs>
    private val mCharacteristicsArgs: MutableMap<Int, MyGattCharacteristicArgs>
    private val mDescriptorsArgs: MutableMap<Int, MyGattDescriptorArgs>

    private val mDevices: MutableMap<String, BluetoothDevice>
    private val mServices: MutableMap<Long, BluetoothGattService>
    private val mCharacteristics: MutableMap<Long, BluetoothGattCharacteristic>
    private val mDescriptors: MutableMap<Long, BluetoothGattDescriptor>

    private var mAddServiceCallback: ((Result<Unit>) -> Unit)?
    private var mStartAdvertisingCallback: ((Result<Unit>) -> Unit)?
    private val mNotifyCharacteristicValueChangedCallbacks: MutableMap<String, (Result<Unit>) -> Unit>

    init {
        mContext = context
        mAPI = MyPeripheralManagerFlutterAPI(binaryMessenger)

        mServicesArgs = mutableMapOf()
        mCharacteristicsArgs = mutableMapOf()
        mDescriptorsArgs = mutableMapOf()

        mDevices = mutableMapOf()
        mServices = mutableMapOf()
        mCharacteristics = mutableMapOf()
        mDescriptors = mutableMapOf()

        mAddServiceCallback = null
        mStartAdvertisingCallback = null
        mNotifyCharacteristicValueChangedCallbacks = mutableMapOf()
    }

    override val permissions: Array<String>
        get() = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            arrayOf(android.Manifest.permission.ACCESS_COARSE_LOCATION, android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.BLUETOOTH_ADVERTISE, android.Manifest.permission.BLUETOOTH_CONNECT)
        } else {
            arrayOf(android.Manifest.permission.ACCESS_COARSE_LOCATION, android.Manifest.permission.ACCESS_FINE_LOCATION)
        }

    override val requestCode: Int
        get() = REQUEST_CODE

    override fun initialize() {
        if (mAdvertising) {
            stopAdvertising()
        }

        mServicesArgs.clear()
        mCharacteristicsArgs.clear()
        mDescriptorsArgs.clear()

        mDevices.clear()
        mServices.clear()
        mCharacteristics.clear()
        mDescriptors.clear()

        mAddServiceCallback = null
        mStartAdvertisingCallback = null
        mNotifyCharacteristicValueChangedCallbacks.clear()

        if (hasFeature) {
            requestPermissions()
        } else {
            val stateArgs = MyBluetoothLowEnergyStateArgs.UNSUPPORTED
            mOnStateChanged(stateArgs)
        }
    }

    override fun addService(serviceArgs: MyGattServiceArgs, callback: (Result<Unit>) -> Unit) {
        try {
            val service = serviceArgs.toService()
            val characteristicsArgs = serviceArgs.characteristicsArgs.filterNotNull()
            for (characteristicArgs in characteristicsArgs) {
                val characteristic = characteristicArgs.toCharacteristic()
                val descriptorsArgs = characteristicArgs.descriptorsArgs.filterNotNull()
                for (descriptorArgs in descriptorsArgs) {
                    val descriptor = descriptorArgs.toDescriptor()
                    val descriptorHashCodeArgs = descriptorArgs.hashCodeArgs
                    val descriptorHashCode = descriptor.hashCode()
                    this.mDescriptorsArgs[descriptorHashCode] = descriptorArgs
                    this.mDescriptors[descriptorHashCodeArgs] = descriptor
                    val descriptorAdded = characteristic.addDescriptor(descriptor)
                    if (!descriptorAdded) {
                        throw IllegalStateException()
                    }
                }
                val characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
                val characteristicHashCode = characteristic.hashCode()
                this.mCharacteristicsArgs[characteristicHashCode] = characteristicArgs
                this.mCharacteristics[characteristicHashCodeArgs] = characteristic
                val characteristicAdded = service.addCharacteristic(characteristic)
                if (!characteristicAdded) {
                    throw IllegalStateException()
                }
            }
            val serviceHashCodeArgs = serviceArgs.hashCodeArgs
            val serviceHashCode = service.hashCode()
            this.mServicesArgs[serviceHashCode] = serviceArgs
            this.mServices[serviceHashCodeArgs] = service
            val adding = mServer.addService(service)
            if (!adding) {
                throw IllegalStateException()
            }
            mAddServiceCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun removeService(hashCodeArgs: Long) {
        val service = mServices.remove(hashCodeArgs) as BluetoothGattService
        val removed = mServer.removeService(service)
        if (!removed) {
            throw IllegalStateException()
        }
        val hashCode = service.hashCode()
        val serviceArgs = mServicesArgs.remove(hashCode) as MyGattServiceArgs
        val characteristicsArgs = serviceArgs.characteristicsArgs.filterNotNull()
        for (characteristicArgs in characteristicsArgs) {
            val characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
            val characteristic = mCharacteristics.remove(characteristicHashCodeArgs) as BluetoothGattCharacteristic
            val characteristicHashCode = characteristic.hashCode()
            mCharacteristicsArgs.remove(characteristicHashCode)
            val descriptorsArgs = characteristicArgs.descriptorsArgs.filterNotNull()
            for (descriptorArgs in descriptorsArgs) {
                val descriptorHashCodeArgs = descriptorArgs.hashCodeArgs
                val descriptor = mDescriptors.remove(descriptorHashCodeArgs) as BluetoothGattDescriptor
                val descriptorHashCode = descriptor.hashCode()
                mDescriptorsArgs.remove(descriptorHashCode)
            }
        }
    }

    override fun clearServices() {
        mServer.clearServices()
        mServices.clear()
        mCharacteristics.clear()
        mDescriptors.clear()

        mServicesArgs.clear()
        mCharacteristicsArgs.clear()
        mDescriptorsArgs.clear()
    }

    override fun startAdvertising(advertisementArgs: MyAdvertisementArgs, callback: (Result<Unit>) -> Unit) {
        try {
            val settings = AdvertiseSettings.Builder().setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_BALANCED).setConnectable(true).build()
            val advertiseData = advertisementArgs.toAdvertiseData(adapter)
            advertiser.startAdvertising(settings, advertiseData, advertiseCallback)
            mStartAdvertisingCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun stopAdvertising() {
        advertiser.stopAdvertising(advertiseCallback)
        mAdvertising = false
    }

    override fun sendResponse(addressArgs: String, idArgs: Long, statusArgs: Long, offsetArgs: Long, valueArgs: ByteArray?) {
        val device = mDevices[addressArgs] as BluetoothDevice
        val requestId = idArgs.toInt()
        val status = statusArgs.toInt()
        val offset = offsetArgs.toInt()
        val sent = mServer.sendResponse(device, requestId, status, offset, valueArgs)
        if (!sent) {
            throw IllegalStateException("Send response failed.")
        }
    }

    override fun notifyCharacteristic(hashCodeArgs: Long, valueArgs: ByteArray, confirmArgs: Boolean, addressArgs: String, callback: (Result<Unit>) -> Unit) {
        try {
            val device = mDevices[addressArgs] as BluetoothDevice
            val characteristic = mCharacteristics[hashCodeArgs] as BluetoothGattCharacteristic
            val notifying = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val statusCode = mServer.notifyCharacteristicChanged(device, characteristic, confirmArgs, valueArgs)
                statusCode == BluetoothStatusCodes.SUCCESS
            } else {
                // TODO: remove this when minSdkVersion >= 33
                characteristic.value = valueArgs
                mServer.notifyCharacteristicChanged(device, characteristic, confirmArgs)
            }
            if (!notifying) {
                throw IllegalStateException()
            }
            mNotifyCharacteristicValueChangedCallbacks[addressArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun onPermissionsRequested(granted: Boolean) {
        val stateArgs = if (granted) {
            registerReceiver()
            adapter.state.toBluetoothLowEnergyStateArgs()
        } else MyBluetoothLowEnergyStateArgs.UNAUTHORIZED
        mOnStateChanged(stateArgs)
    }

    override fun onAdapterStateChanged(state: Int) {
        val stateArgs = state.toBluetoothLowEnergyStateArgs()
        mOnStateChanged(stateArgs)
    }

    fun onServiceAdded(status: Int, service: BluetoothGattService) {
        val callback = mAddServiceCallback ?: return
        mAddServiceCallback = null
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val error = IllegalStateException("Read rssi failed with status: $status")
            callback(Result.failure(error))
        }
    }

    fun onStartSuccess(settingsInEffect: AdvertiseSettings) {
        mAdvertising = true
        val callback = mStartAdvertisingCallback ?: return
        mStartAdvertisingCallback = null
        callback(Result.success(Unit))
    }

    fun onStartFailure(errorCode: Int) {
        val callback = mStartAdvertisingCallback ?: return
        mStartAdvertisingCallback = null
        val error = IllegalStateException("Start advertising failed with error code: $errorCode")
        callback(Result.failure(error))
    }

    fun onConnectionStateChange(device: BluetoothDevice, status: Int, newState: Int) {
        val centralArgs = device.toCentralArgs()
        val addressArgs = centralArgs.addressArgs
        val stateArgs = newState == BluetoothProfile.STATE_CONNECTED
        mDevices[addressArgs] = device
        mAPI.onConnectionStateChanged(centralArgs, stateArgs) {}
    }

    fun onMtuChanged(device: BluetoothDevice, mtu: Int) {
        val addressArgs = device.address
        val mtuArgs = mtu.toLong()
        mAPI.onMtuChanged(addressArgs, mtuArgs) {}
    }

    fun onCharacteristicReadRequest(device: BluetoothDevice, requestId: Int, offset: Int, characteristic: BluetoothGattCharacteristic) {
        val addressArgs = device.address
        val hashCode = characteristic.hashCode()
        val characteristicArgs = mCharacteristicsArgs[hashCode] ?: return
        val hashCodeArgs = characteristicArgs.hashCodeArgs
        val idArgs = requestId.toLong()
        val offsetArgs = offset.toLong()
        mAPI.onCharacteristicReadRequest(addressArgs, hashCodeArgs, idArgs, offsetArgs) {}
    }

    fun onCharacteristicWriteRequest(device: BluetoothDevice, requestId: Int, characteristic: BluetoothGattCharacteristic, preparedWrite: Boolean, responseNeeded: Boolean, offset: Int, value: ByteArray) {
        val addressArgs = device.address
        val hashCode = characteristic.hashCode()
        val characteristicArgs = mCharacteristicsArgs[hashCode] ?: return
        val hashCodeArgs = characteristicArgs.hashCodeArgs
        val idArgs = requestId.toLong()
        val offsetArgs = offset.toLong()
        mAPI.onCharacteristicWriteRequest(addressArgs, hashCodeArgs, idArgs, offsetArgs, value, preparedWrite, responseNeeded) {}
    }

    fun onExecuteWrite(device: BluetoothDevice, requestId: Int, execute: Boolean) {
        val addressArgs = device.address
        val idArgs = requestId.toLong()
        mAPI.onExecuteWrite(addressArgs, idArgs, execute) {}
    }

    fun onDescriptorReadRequest(device: BluetoothDevice, requestId: Int, offset: Int, descriptor: BluetoothGattDescriptor) {
        val addressArgs = device.address
        val hashCode = descriptor.hashCode()
        val descriptorArgs = mDescriptorsArgs[hashCode] ?: return
        val hashCodeArgs = descriptorArgs.hashCodeArgs
        val idArgs = requestId.toLong()
        val offsetArgs = offset.toLong()
        mAPI.onDescriptorReadRequest(addressArgs, hashCodeArgs, idArgs, offsetArgs) {}
    }

    fun onDescriptorWriteRequest(device: BluetoothDevice, requestId: Int, descriptor: BluetoothGattDescriptor, preparedWrite: Boolean, responseNeeded: Boolean, offset: Int, value: ByteArray) {
        val addressArgs = device.address
        val hashCode = descriptor.hashCode()
        val descriptorArgs = mDescriptorsArgs[hashCode] ?: return
        val hashCodeArgs = descriptorArgs.hashCodeArgs
        val idArgs = requestId.toLong()
        val offsetArgs = offset.toLong()
        mAPI.onDescriptorWriteRequest(addressArgs, hashCodeArgs, idArgs, offsetArgs, value, preparedWrite, responseNeeded) {}
        if (descriptor.uuid == CLIENT_CHARACTERISTIC_CONFIG_UUID) {
            val characteristic = descriptor.characteristic
            mOnCharacteristicNotifyStateChanged(device, characteristic, value)
        }
    }

    fun onNotificationSent(device: BluetoothDevice, status: Int) {
        val addressArgs = device.address
        val callback = mNotifyCharacteristicValueChangedCallbacks.remove(addressArgs) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val error = IllegalStateException("Notify characteristic value changed failed with status: $status")
            callback(Result.failure(error))
        }
    }

    private fun mOnStateChanged(stateArgs: MyBluetoothLowEnergyStateArgs) {
        val stateNumberArgs = stateArgs.raw.toLong()
        mAPI.onStateChanged(stateNumberArgs) {}
        // Renew GATT server when bluetooth adapter state changed.
        when (stateArgs) {
            MyBluetoothLowEnergyStateArgs.OFF -> mCloseServer()
            MyBluetoothLowEnergyStateArgs.ON -> mOpenServer()
            else -> {}
        }
    }

    private fun mOpenServer() {
        if (mOpening) {
            return
        }
        mServer = manager.openGattServer(mContext, bluetoothGattServerCallback)
        mOpening = true
    }

    private fun mCloseServer() {
        if (!mOpening) {
            return
        }
        mServer.close()
        mOpening = false
    }

    private fun mOnCharacteristicNotifyStateChanged(device: BluetoothDevice, characteristic: BluetoothGattCharacteristic, value: ByteArray) {
        val addressArgs = device.address
        val hashCode = characteristic.hashCode()
        val characteristicArgs = mCharacteristicsArgs[hashCode] ?: return
        val hashCodeArgs = characteristicArgs.hashCodeArgs
        val stateArgs = value.toNotifyStateArgs()
        val stateNumberArgs = stateArgs.raw.toLong()
        mAPI.onCharacteristicNotifyStateChanged(addressArgs, hashCodeArgs, stateNumberArgs) {}
    }
}