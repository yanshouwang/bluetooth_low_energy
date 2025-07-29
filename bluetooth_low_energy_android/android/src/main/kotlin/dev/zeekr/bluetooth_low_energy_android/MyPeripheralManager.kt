package dev.zeekr.bluetooth_low_energy_android

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattServer
import android.bluetooth.BluetoothGattServerCallback
import android.bluetooth.BluetoothGattService
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothStatusCodes
import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseSettings
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.app.ActivityOptionsCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.BinaryMessenger
import java.util.concurrent.Executor

class MyPeripheralManager(context: Context, binaryMessenger: BinaryMessenger) : MyBluetoothLowEnergyManager(context),
    MyPeripheralManagerHostAPI {
    private val mAPI: MyPeripheralManagerFlutterAPI

    private val mBluetoothGattServerCallback: BluetoothGattServerCallback by lazy {
        MyBluetoothGattServerCallback(
            this, executor
        )
    }
    private val mAdvertiseCallback: AdvertiseCallback by lazy { MyAdvertiseCallback(this) }

    private var mServer: BluetoothGattServer?
    private var mAdvertising: Boolean

    private val mServicesArgs: MutableMap<Int, MyMutableGATTServiceArgs>
    private val mCharacteristicsArgs: MutableMap<Int, MyMutableGATTCharacteristicArgs>
    private val mDescriptorsArgs: MutableMap<Int, MyMutableGATTDescriptorArgs>

    private val mDevices: MutableMap<String, BluetoothDevice>
    private val mServices: MutableMap<Long, BluetoothGattService>
    private val mCharacteristics: MutableMap<Long, BluetoothGattCharacteristic>
    private val mDescriptors: MutableMap<Long, BluetoothGattDescriptor>

    private var mAuthorizeCallback: ((Result<Boolean>) -> Unit)?
    private var mSetNameCallback: ((Result<String?>) -> Unit)?
    private var mAddServiceCallback: ((Result<Unit>) -> Unit)?
    private var mStartAdvertisingCallback: ((Result<Unit>) -> Unit)?
    private val mNotifyCharacteristicValueChangedCallbacks: MutableMap<String, (Result<Unit>) -> Unit>

    init {
        mAPI = MyPeripheralManagerFlutterAPI(binaryMessenger)

        mServer = null
        mAdvertising = false

        mServicesArgs = mutableMapOf()
        mCharacteristicsArgs = mutableMapOf()
        mDescriptorsArgs = mutableMapOf()

        mDevices = mutableMapOf()
        mServices = mutableMapOf()
        mCharacteristics = mutableMapOf()
        mDescriptors = mutableMapOf()

        mAuthorizeCallback = null
        mSetNameCallback = null
        mAddServiceCallback = null
        mStartAdvertisingCallback = null
        mNotifyCharacteristicValueChangedCallbacks = mutableMapOf()
    }

    private val permissions: Array<String>
        get() = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            arrayOf(android.Manifest.permission.BLUETOOTH_ADVERTISE, android.Manifest.permission.BLUETOOTH_CONNECT)
        } else {
            arrayOf(
                android.Manifest.permission.ACCESS_COARSE_LOCATION, android.Manifest.permission.ACCESS_FINE_LOCATION
            )
        }
    private val manager
        get() = ContextCompat.getSystemService(
            context, BluetoothManager::class.java
        ) as BluetoothManager
    private val adapter get() = manager.adapter as BluetoothAdapter
    private val advertiser get() = adapter.bluetoothLeAdvertiser
    private val server get() = mServer ?: throw IllegalStateException()
    private val executor get() = ContextCompat.getMainExecutor(context) as Executor

    override fun initialize(): MyPeripheralManagerArgs {
        if (mAdvertising) {
            stopAdvertising()
        }

        mServer?.close()

        mServicesArgs.clear()
        mCharacteristicsArgs.clear()
        mDescriptorsArgs.clear()

        mDevices.clear()
        mServices.clear()
        mCharacteristics.clear()
        mDescriptors.clear()

        mAuthorizeCallback = null
        mSetNameCallback = null
        mAddServiceCallback = null
        mStartAdvertisingCallback = null
        mNotifyCharacteristicValueChangedCallbacks.clear()

        val enableNotificationValue = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
        val enableIndicationValue = BluetoothGattDescriptor.ENABLE_INDICATION_VALUE
        val disableNotificationValue = BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
        return MyPeripheralManagerArgs(enableNotificationValue, enableIndicationValue, disableNotificationValue)
    }

    override fun getState(): MyBluetoothLowEnergyStateArgs {
        // Use isMultipleAdvertisementSupported() to check whether LE Advertising is supported on this device before calling this method.
        // See https://developer.android.com/reference/kotlin/android/bluetooth/BluetoothAdapter#getbluetoothleadvertiser
        val supported =
            context.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE) && adapter.isMultipleAdvertisementSupported
        return if (supported) {
            val authorized = permissions.all { permission ->
                ActivityCompat.checkSelfPermission(
                    context, permission
                ) == PackageManager.PERMISSION_GRANTED
            }
            return if (authorized) adapter.state.toBluetoothLowEnergyStateArgs()
            else MyBluetoothLowEnergyStateArgs.UNAUTHORIZED
        } else MyBluetoothLowEnergyStateArgs.UNSUPPORTED
    }

    override fun authorize(callback: (Result<Boolean>) -> Unit) {
        try {
            ActivityCompat.requestPermissions(activity, permissions, AUTHORIZE_CODE)
            mAuthorizeCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun showAppSettings() {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
        intent.data = Uri.fromParts("package", activity.packageName, null)
        val options = ActivityOptionsCompat.makeBasic().toBundle()
        ActivityCompat.startActivity(activity, intent, options)
    }

    override fun setName(nameArgs: String, callback: (Result<String?>) -> Unit) {
        try {
            val setting = adapter.setName(nameArgs)
            if (!setting) {
                throw IllegalStateException()
            }
            mSetNameCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun openGATTServer() {
        mServer = manager.openGattServer(context, mBluetoothGattServerCallback)
    }

    override fun closeGATTServer() {
        server.close()
    }

    override fun addService(serviceArgs: MyMutableGATTServiceArgs, callback: (Result<Unit>) -> Unit) {
        try {
            val service = addServiceArgs(serviceArgs)
            val adding = server.addService(service)
            if (!adding) {
                throw IllegalStateException()
            }
            mAddServiceCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun removeService(hashCodeArgs: Long) {
        val service = mServices[hashCodeArgs] ?: throw IllegalArgumentException()
        val removed = server.removeService(service)
        if (!removed) {
            throw IllegalStateException()
        }
        val hashCode = service.hashCode()
        val serviceArgs = mServicesArgs[hashCode] ?: throw IllegalArgumentException()
        removeServiceArgs(serviceArgs)
    }

    override fun removeAllServices() {
        server.clearServices()
        mServices.clear()
        mCharacteristics.clear()
        mDescriptors.clear()

        mServicesArgs.clear()
        mCharacteristicsArgs.clear()
        mDescriptorsArgs.clear()
    }

    override fun startAdvertising(
        settingsArgs: MyAdvertiseSettingsArgs,
        advertiseDataArgs: MyAdvertiseDataArgs,
        scanResponseArgs: MyAdvertiseDataArgs,
        callback: (Result<Unit>) -> Unit
    ) {
        try {
            val settings = settingsArgs.toAdvertiseSettings()
            val advertiseData = advertiseDataArgs.toAdvertiseData()
            val scanResponse = scanResponseArgs.toAdvertiseData()
            advertiser.startAdvertising(settings, advertiseData, scanResponse, mAdvertiseCallback)
            mStartAdvertisingCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun stopAdvertising() {
        advertiser.stopAdvertising(mAdvertiseCallback)
        mAdvertising = false
    }

    override fun sendResponse(
        addressArgs: String, idArgs: Long, statusArgs: MyGATTStatusArgs, offsetArgs: Long, valueArgs: ByteArray?
    ) {
        val device = mDevices[addressArgs] ?: throw IllegalArgumentException()
        val requestId = idArgs.toInt()
        val status = statusArgs.toStatus()
        val offset = offsetArgs.toInt()
        val sent = server.sendResponse(device, requestId, status, offset, valueArgs)
        if (!sent) {
            throw IllegalStateException("Send response failed.")
        }
    }

    override fun notifyCharacteristicChanged(
        addressArgs: String,
        hashCodeArgs: Long,
        confirmArgs: Boolean,
        valueArgs: ByteArray,
        callback: (Result<Unit>) -> Unit
    ) {
        try {
            val device = mDevices[addressArgs] ?: throw IllegalArgumentException()
            val characteristic = mCharacteristics[hashCodeArgs] ?: throw IllegalArgumentException()
            val notifying = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val statusCode = server.notifyCharacteristicChanged(device, characteristic, confirmArgs, valueArgs)
                statusCode == BluetoothStatusCodes.SUCCESS
            } else { // TODO: remove this when minSdkVersion >= 33
                characteristic.value = valueArgs
                server.notifyCharacteristicChanged(device, characteristic, confirmArgs)
            }
            if (!notifying) {
                throw IllegalStateException()
            }
            mNotifyCharacteristicValueChangedCallbacks[addressArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            BluetoothAdapter.ACTION_STATE_CHANGED -> {
                val state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.STATE_OFF)
                val stateArgs = state.toBluetoothLowEnergyStateArgs()
                mAPI.onStateChanged(stateArgs) {}
            }

            BluetoothAdapter.ACTION_LOCAL_NAME_CHANGED -> {
                val callback = mSetNameCallback ?: return
                mSetNameCallback = null
                val nameArgs = intent.getStringExtra(BluetoothAdapter.EXTRA_LOCAL_NAME)
                callback(Result.success(nameArgs))
            }

            else -> {}
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, results: IntArray
    ): Boolean {
        if (requestCode != AUTHORIZE_CODE) {
            return false
        }
        val callback = mAuthorizeCallback ?: return false
        mAuthorizeCallback = null
        val authorized =
            permissions.contentEquals(this.permissions) && results.all { r -> r == PackageManager.PERMISSION_GRANTED }
        callback(Result.success(authorized))
        return true
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
        val statusArgs = status.args
        val stateArgs = newState.toConnectionStateArgs()
        mDevices[addressArgs] = device
        mAPI.onConnectionStateChanged(centralArgs, statusArgs, stateArgs) {}
    }

    fun onMtuChanged(device: BluetoothDevice, mtu: Int) {
        val centralArgs = device.toCentralArgs()
        val mtuArgs = mtu.args
        mAPI.onMTUChanged(centralArgs, mtuArgs) {}
    }

    fun onCharacteristicReadRequest(
        device: BluetoothDevice, requestId: Int, offset: Int, characteristic: BluetoothGattCharacteristic
    ) {
        val centralArgs = device.toCentralArgs()
        val idArgs = requestId.args
        val offsetArgs = offset.args
        val hashCode = characteristic.hashCode()
        val characteristicArgs = mCharacteristicsArgs[hashCode]
        if (characteristicArgs == null) {
            val status = BluetoothGatt.GATT_FAILURE
            server.sendResponse(device, requestId, status, offset, null)
        } else {
            val hashCodeArgs = characteristicArgs.hashCodeArgs
            mAPI.onCharacteristicReadRequest(centralArgs, idArgs, offsetArgs, hashCodeArgs) {}
        }
    }

    fun onCharacteristicWriteRequest(
        device: BluetoothDevice,
        requestId: Int,
        characteristic: BluetoothGattCharacteristic,
        preparedWrite: Boolean,
        responseNeeded: Boolean,
        offset: Int,
        value: ByteArray
    ) {
        val centralArgs = device.toCentralArgs()
        val idArgs = requestId.args
        val hashCode = characteristic.hashCode()
        val characteristicArgs = mCharacteristicsArgs[hashCode]
        if (characteristicArgs == null) {
            if (!responseNeeded) {
                return
            }
            val status = BluetoothGatt.GATT_FAILURE
            server.sendResponse(device, requestId, status, offset, null)
        } else {
            val hashCodeArgs = characteristicArgs.hashCodeArgs
            val offsetArgs = offset.args
            mAPI.onCharacteristicWriteRequest(
                centralArgs, idArgs, hashCodeArgs, preparedWrite, responseNeeded, offsetArgs, value
            ) {}
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

    fun onDescriptorReadRequest(
        device: BluetoothDevice, requestId: Int, offset: Int, descriptor: BluetoothGattDescriptor
    ) {
        val centralArgs = device.toCentralArgs()
        val idArgs = requestId.args
        val offsetArgs = offset.args
        val hashCode = descriptor.hashCode()
        val descriptorArgs = mDescriptorsArgs[hashCode]
        if (descriptorArgs == null) {
            val status = BluetoothGatt.GATT_FAILURE
            server.sendResponse(device, requestId, status, offset, null)
        } else {
            val hashCodeArgs = descriptorArgs.hashCodeArgs
            mAPI.onDescriptorReadRequest(centralArgs, idArgs, offsetArgs, hashCodeArgs) {}
        }
    }

    fun onDescriptorWriteRequest(
        device: BluetoothDevice,
        requestId: Int,
        descriptor: BluetoothGattDescriptor,
        preparedWrite: Boolean,
        responseNeeded: Boolean,
        offset: Int,
        value: ByteArray
    ) {
        val centralArgs = device.toCentralArgs()
        val idArgs = requestId.args
        val hashCode = descriptor.hashCode()
        val descriptorArgs = mDescriptorsArgs[hashCode]
        if (descriptorArgs == null) {
            if (!responseNeeded) {
                return
            }
            val status = BluetoothGatt.GATT_FAILURE
            server.sendResponse(device, requestId, status, offset, null)
        } else {
            val hashCodeArgs = descriptorArgs.hashCodeArgs
            val offsetArgs = offset.args
            mAPI.onDescriptorWriteRequest(
                centralArgs, idArgs, hashCodeArgs, preparedWrite, responseNeeded, offsetArgs, value
            ) {}
        }
    }

    fun onExecuteWrite(device: BluetoothDevice, requestId: Int, execute: Boolean) {
        val centralArgs = device.toCentralArgs()
        val idArgs = requestId.args
        mAPI.onExecuteWrite(centralArgs, idArgs, execute) {}
    }

    private fun addServiceArgs(serviceArgs: MyMutableGATTServiceArgs): BluetoothGattService {
        val service = serviceArgs.toService()
        this.mServicesArgs[service.hashCode] = serviceArgs
        this.mServices[serviceArgs.hashCodeArgs] = service
        val includedServicesArgs = serviceArgs.includedServicesArgs.requireNoNulls()
        for (includedServiceArgs in includedServicesArgs) {
            val includedService = addServiceArgs(includedServiceArgs)
            val adding = service.addService(includedService)
            if (!adding) {
                throw IllegalStateException()
            }
        }
        val characteristicsArgs = serviceArgs.characteristicsArgs.requireNoNulls()
        for (characteristicArgs in characteristicsArgs) {
            val characteristic = characteristicArgs.toCharacteristic()
            this.mCharacteristicsArgs[characteristic.hashCode] = characteristicArgs
            this.mCharacteristics[characteristicArgs.hashCodeArgs] = characteristic
            val descriptorsArgs = characteristicArgs.descriptorsArgs.requireNoNulls()
            for (descriptorArgs in descriptorsArgs) {
                val descriptor = descriptorArgs.toDescriptor()
                this.mDescriptorsArgs[descriptor.hashCode] = descriptorArgs
                this.mDescriptors[descriptorArgs.hashCodeArgs] = descriptor
                val descriptorAdded = characteristic.addDescriptor(descriptor)
                if (!descriptorAdded) {
                    throw IllegalStateException()
                }
            }
            val characteristicAdded = service.addCharacteristic(characteristic)
            if (!characteristicAdded) {
                throw IllegalStateException()
            }
        }
        return service
    }

    private fun removeServiceArgs(serviceArgs: MyMutableGATTServiceArgs) {
        val includedServicesArgs = serviceArgs.includedServicesArgs.requireNoNulls()
        for (includedServiceArgs in includedServicesArgs) {
            removeServiceArgs(includedServiceArgs)
        }
        val characteristicsArgs = serviceArgs.characteristicsArgs.requireNoNulls()
        for (characteristicArgs in characteristicsArgs) {
            val descriptorsArgs = characteristicArgs.descriptorsArgs.requireNoNulls()
            for (descriptorArgs in descriptorsArgs) {
                val descriptor = mDescriptors.remove(descriptorArgs.hashCodeArgs) ?: throw IllegalArgumentException()
                this.mDescriptorsArgs.remove(descriptor.hashCode)
            }
            val characteristic =
                mCharacteristics.remove(characteristicArgs.hashCodeArgs) ?: throw IllegalArgumentException()
            this.mCharacteristicsArgs.remove(characteristic.hashCode)
        }
        val service = mServices.remove(serviceArgs.hashCodeArgs) ?: throw IllegalArgumentException()
        mServicesArgs.remove(service.hashCode)
    }
}