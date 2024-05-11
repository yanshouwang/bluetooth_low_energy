package dev.yanshouwang.bluetooth_low_energy_android

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

class MyPeripheralManager(context: Context, binaryMessenger: BinaryMessenger) : MyBluetoothLowEnergyManager(context), MyPeripheralManagerHostAPI {
    private val mAPI: MyPeripheralManagerFlutterAPI

    private val mBluetoothGattServerCallback: BluetoothGattServerCallback by lazy { MyBluetoothGattServerCallback(this, executor) }
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
    private var mShowAppSettingsCallback: ((Result<Unit>) -> Unit)?
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
        mShowAppSettingsCallback = null
        mAddServiceCallback = null
        mStartAdvertisingCallback = null
        mNotifyCharacteristicValueChangedCallbacks = mutableMapOf()
    }

    private val mPermissions: Array<String>
        get() = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            arrayOf(android.Manifest.permission.ACCESS_COARSE_LOCATION, android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.BLUETOOTH_ADVERTISE, android.Manifest.permission.BLUETOOTH_CONNECT)
        } else {
            arrayOf(android.Manifest.permission.ACCESS_COARSE_LOCATION, android.Manifest.permission.ACCESS_FINE_LOCATION)
        }
    private val manager get() = ContextCompat.getSystemService(context, BluetoothManager::class.java) as BluetoothManager
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
        mShowAppSettingsCallback = null
        mAddServiceCallback = null
        mStartAdvertisingCallback = null
        mNotifyCharacteristicValueChangedCallbacks.clear()

        val enableNotificationValue = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
        val enableIndicationValue = BluetoothGattDescriptor.ENABLE_INDICATION_VALUE
        val disableNotificationValue = BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
        return MyPeripheralManagerArgs(enableNotificationValue, enableIndicationValue, disableNotificationValue)
    }

    override fun getState(): MyBluetoothLowEnergyStateArgs {
        val supported = context.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
        return if (supported) {
            val authorized = mPermissions.all { permission -> ActivityCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED }
            return if (authorized) adapter.state.toBluetoothLowEnergyStateArgs()
            else MyBluetoothLowEnergyStateArgs.UNAUTHORIZED
        } else MyBluetoothLowEnergyStateArgs.UNSUPPORTED
    }

    override fun authorize(callback: (Result<Boolean>) -> Unit) {
        try {
            ActivityCompat.requestPermissions(activity, mPermissions, AUTHORIZE_CODE)
            mAuthorizeCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun showAppSettings(callback: (Result<Unit>) -> Unit) {
        try {
            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
            intent.data = Uri.fromParts("package", activity.packageName, null)
            val options = ActivityOptionsCompat.makeBasic().toBundle()
            ActivityCompat.startActivityForResult(activity, intent, SHOW_APP_SETTINGS_CODE, options)
            mShowAppSettingsCallback = callback
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
            val service = serviceArgs.toService()
            val characteristicsArgs = serviceArgs.characteristicsArgs.requireNoNulls()
            for (characteristicArgs in characteristicsArgs) {
                val characteristic = characteristicArgs.toCharacteristic()
                val descriptorsArgs = characteristicArgs.descriptorsArgs.requireNoNulls()
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
        val service = mServices.remove(hashCodeArgs) as BluetoothGattService
        val removed = server.removeService(service)
        if (!removed) {
            throw IllegalStateException()
        }
        val hashCode = service.hashCode()
        val serviceArgs = mServicesArgs.remove(hashCode) as MyMutableGATTServiceArgs
        val characteristicsArgs = serviceArgs.characteristicsArgs.requireNoNulls()
        for (characteristicArgs in characteristicsArgs) {
            val characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
            val characteristic = mCharacteristics.remove(characteristicHashCodeArgs) as BluetoothGattCharacteristic
            val characteristicHashCode = characteristic.hashCode()
            mCharacteristicsArgs.remove(characteristicHashCode)
            val descriptorsArgs = characteristicArgs.descriptorsArgs.requireNoNulls()
            for (descriptorArgs in descriptorsArgs) {
                val descriptorHashCodeArgs = descriptorArgs.hashCodeArgs
                val descriptor = mDescriptors.remove(descriptorHashCodeArgs) as BluetoothGattDescriptor
                val descriptorHashCode = descriptor.hashCode()
                mDescriptorsArgs.remove(descriptorHashCode)
            }
        }
    }

    override fun clearServices() {
        server.clearServices()
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
            advertiser.startAdvertising(settings, advertiseData, mAdvertiseCallback)
            mStartAdvertisingCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun stopAdvertising() {
        advertiser.stopAdvertising(mAdvertiseCallback)
        mAdvertising = false
    }

    override fun sendResponse(addressArgs: String, idArgs: Long, statusArgs: MyGATTStatusArgs, offsetArgs: Long, valueArgs: ByteArray?) {
        val device = mDevices[addressArgs] as BluetoothDevice
        val requestId = idArgs.toInt()
        val status = statusArgs.toStatus()
        val offset = offsetArgs.toInt()
        val sent = server.sendResponse(device, requestId, status, offset, valueArgs)
        if (!sent) {
            throw IllegalStateException("Send response failed.")
        }
    }

    override fun notifyCharacteristicChanged(addressArgs: String, hashCodeArgs: Long, confirmArgs: Boolean, valueArgs: ByteArray, callback: (Result<Unit>) -> Unit) {
        try {
            val device = mDevices[addressArgs] as BluetoothDevice
            val characteristic = mCharacteristics[hashCodeArgs] as BluetoothGattCharacteristic
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
        if (intent.action != BluetoothAdapter.ACTION_STATE_CHANGED) {
            return
        }
        val state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.STATE_OFF)
        val stateArgs = state.toBluetoothLowEnergyStateArgs()
        mAPI.onStateChanged(stateArgs) {}
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, results: IntArray): Boolean {
        if (requestCode != AUTHORIZE_CODE) {
            return false
        }
        val callback = mAuthorizeCallback ?: return false
        mAuthorizeCallback = null
        val authorized = permissions.contentEquals(this.mPermissions) && results.all { r -> r == PackageManager.PERMISSION_GRANTED }
        callback(Result.success(authorized))
        return true
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != SHOW_APP_SETTINGS_CODE) {
            return false
        }
        val callback = mShowAppSettingsCallback ?: return false
        mShowAppSettingsCallback = null
        callback(Result.success(Unit))
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
        val statusArgs = status.toLong()
        val stateArgs = newState.toConnectionStateArgs()
        mDevices[addressArgs] = device
        mAPI.onConnectionStateChanged(centralArgs, statusArgs, stateArgs) {}
    }

    fun onMtuChanged(device: BluetoothDevice, mtu: Int) {
        val addressArgs = device.address
        val mtuArgs = mtu.toLong()
        mAPI.onMTUChanged(addressArgs, mtuArgs) {}
    }

    fun onCharacteristicReadRequest(device: BluetoothDevice, requestId: Int, offset: Int, characteristic: BluetoothGattCharacteristic) {
        val addressArgs = device.address
        val idArgs = requestId.toLong()
        val offsetArgs = offset.toLong()
        val hashCode = characteristic.hashCode()
        val characteristicArgs = mCharacteristicsArgs[hashCode]
        if (characteristicArgs == null) {
            val status = BluetoothGatt.GATT_FAILURE
            server.sendResponse(device, requestId, status, offset, null)
        } else {
            val hashCodeArgs = characteristicArgs.hashCodeArgs
            mAPI.onCharacteristicReadRequest(addressArgs, idArgs, offsetArgs, hashCodeArgs) {}
        }
    }

    fun onCharacteristicWriteRequest(device: BluetoothDevice, requestId: Int, characteristic: BluetoothGattCharacteristic, preparedWrite: Boolean, responseNeeded: Boolean, offset: Int, value: ByteArray) {
        val addressArgs = device.address
        val idArgs = requestId.toLong()
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
            val offsetArgs = offset.toLong()
            mAPI.onCharacteristicWriteRequest(addressArgs, idArgs, hashCodeArgs, preparedWrite, responseNeeded, offsetArgs, value) {}
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

    fun onDescriptorReadRequest(device: BluetoothDevice, requestId: Int, offset: Int, descriptor: BluetoothGattDescriptor) {
        val addressArgs = device.address
        val idArgs = requestId.toLong()
        val offsetArgs = offset.toLong()
        val hashCode = descriptor.hashCode()
        val descriptorArgs = mDescriptorsArgs[hashCode]
        if (descriptorArgs == null) {
            val status = BluetoothGatt.GATT_FAILURE
            server.sendResponse(device, requestId, status, offset, null)
        } else {
            val hashCodeArgs = descriptorArgs.hashCodeArgs
            mAPI.onDescriptorReadRequest(addressArgs, idArgs, offsetArgs, hashCodeArgs) {}
        }
    }

    fun onDescriptorWriteRequest(device: BluetoothDevice, requestId: Int, descriptor: BluetoothGattDescriptor, preparedWrite: Boolean, responseNeeded: Boolean, offset: Int, value: ByteArray) {
        val addressArgs = device.address
        val idArgs = requestId.toLong()
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
            val offsetArgs = offset.toLong()
            mAPI.onDescriptorWriteRequest(addressArgs, idArgs, hashCodeArgs, preparedWrite, responseNeeded, offsetArgs, value) {}
        }
    }

    fun onExecuteWrite(device: BluetoothDevice, requestId: Int, execute: Boolean) {
        val addressArgs = device.address
        val idArgs = requestId.toLong()
        mAPI.onExecuteWrite(addressArgs, idArgs, execute) {}
    }
}