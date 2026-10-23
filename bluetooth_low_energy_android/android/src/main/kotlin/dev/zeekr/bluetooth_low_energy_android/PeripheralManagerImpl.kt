package dev.zeekr.bluetooth_low_energy_android

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattServer
import android.bluetooth.BluetoothGattServerCallback
import android.bluetooth.BluetoothGattService
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothProfile
import android.bluetooth.BluetoothStatusCodes
import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseSettings
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Log
import androidx.annotation.RequiresPermission
import androidx.core.app.ActivityCompat
import androidx.core.app.ActivityOptionsCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.BinaryMessenger

class PeripheralManagerImpl(context: Context, binaryMessenger: BinaryMessenger) :
    BluetoothLowEnergyManagerImpl(context), PeripheralManagerHostApi {
    companion object {
        private const val TAG = "BluetoothLowEnergy"

        // The pairing dialog of the bluetooth settings, brought up when a central
        // asks to pair while the screen is off and the stack only notifies.
        private const val PAIRING_PACKAGE = "com.android.settings"
        private const val PAIRING_CLASS = "com.android.settings.bluetooth.BluetoothPairingDialog"
    }

    private val mApi: PeripheralManagerFlutterApi

    private val mBluetoothGattServerCallback: BluetoothGattServerCallback by lazy {
        BluetoothGattServerCallbackImpl(
            this, executor
        )
    }
    private val mAdvertiseCallback: AdvertiseCallback by lazy { AdvertiseCallbackImpl(this) }
    private val mPairingReceiver: BroadcastReceiverImpl by lazy { BroadcastReceiverImpl(this) }

    private var mServer: BluetoothGattServer?
    private var mAdvertising: Boolean

    private val mServicesArgs: MutableMap<Int, MutableGATTServiceArgs>
    private val mCharacteristicsArgs: MutableMap<Int, MutableGATTCharacteristicArgs>
    private val mDescriptorsArgs: MutableMap<Int, MutableGATTDescriptorArgs>

    private val mDevices: MutableMap<String, BluetoothDevice>
    private val mServices: MutableMap<Long, BluetoothGattService>
    private val mCharacteristics: MutableMap<Long, BluetoothGattCharacteristic>
    private val mDescriptors: MutableMap<Long, BluetoothGattDescriptor>

    // The name the adapter had before a peripheral renamed it, see `restoreName`.
    private var mOriginalName: String?

    private var mAuthorizeCallback: ((Result<Boolean>) -> Unit)?
    private var mSetNameCallback: ((Result<String?>) -> Unit)?
    private var mAddServiceCallback: ((Result<Unit>) -> Unit)?
    private var mStartAdvertisingCallback: ((Result<Unit>) -> Unit)?
    private val mNotifyCharacteristicValueChangedCallbacks: MutableMap<String, (Result<Unit>) -> Unit>

    init {
        // The pairing and bond state broadcasts are how a peripheral learns that
        // a central is asking for an encrypted link, see [onReceive].
        val pairingFilter = IntentFilter(BluetoothDevice.ACTION_PAIRING_REQUEST)
        pairingFilter.addAction(BluetoothDevice.ACTION_BOND_STATE_CHANGED)
        // Exported on purpose: these are protected broadcasts sent by the
        // bluetooth stack, and a not-exported registration is wrapped in a
        // `.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` that the app may not
        // declare, in which case the system drops every one of them.
        ContextCompat.registerReceiver(
            context, mPairingReceiver, pairingFilter, ContextCompat.RECEIVER_EXPORTED
        )

        mApi = PeripheralManagerFlutterApi(binaryMessenger)

        mServer = null
        mAdvertising = false

        mServicesArgs = mutableMapOf()
        mCharacteristicsArgs = mutableMapOf()
        mDescriptorsArgs = mutableMapOf()

        mDevices = mutableMapOf()
        mServices = mutableMapOf()
        mCharacteristics = mutableMapOf()
        mDescriptors = mutableMapOf()

        mOriginalName = null
        mAuthorizeCallback = null
        mSetNameCallback = null
        mAddServiceCallback = null
        mStartAdvertisingCallback = null
        mNotifyCharacteristicValueChangedCallbacks = mutableMapOf()
    }

    private val permissions: Array<String>
        get() = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            arrayOf(Manifest.permission.BLUETOOTH_ADVERTISE, Manifest.permission.BLUETOOTH_CONNECT)
        } else {
            arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.ACCESS_FINE_LOCATION)
        }
    private val manager
        get() = ContextCompat.getSystemService(context, BluetoothManager::class.java) as BluetoothManager
    private val adapter get() = manager.adapter as BluetoothAdapter
    private val advertiser get() = adapter.bluetoothLeAdvertiser
    private val server get() = mServer ?: throw IllegalStateException()
    private val executor get() = ContextCompat.getMainExecutor(context)

    @RequiresPermission(allOf = [Manifest.permission.BLUETOOTH_CONNECT, Manifest.permission.BLUETOOTH_ADVERTISE])
    override fun initialize(): PeripheralManagerArgs {
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
        return PeripheralManagerArgs(enableNotificationValue, enableIndicationValue, disableNotificationValue)
    }

    override fun getState(): BluetoothLowEnergyStateArgs {
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
            if (authorized) adapter.state.toBluetoothLowEnergyStateArgs()
            else BluetoothLowEnergyStateArgs.UNAUTHORIZED
        } else BluetoothLowEnergyStateArgs.UNSUPPORTED
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

    @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
    override fun setName(nameArgs: String, callback: (Result<String?>) -> Unit) {
        try {
            // The name of a LE advertisement *is* the name of the adapter here,
            // so renaming it renames the phone itself over BR/EDR as well, and a
            // central then lists the very same name twice. Hold on to the name it
            // had, `stopAdvertising` hands it back.
            if (mOriginalName == null) {
                mOriginalName = try {
                    adapter.name
                } catch (e: SecurityException) {
                    Log.w(TAG, "Reading the bluetooth name failed: $e.")
                    null
                }
            }
            val setting = adapter.setName(nameArgs)
            if (!setting) {
                throw IllegalStateException()
            }
            mSetNameCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
    override fun openGATTServer() {
        mServer = manager.openGattServer(context, mBluetoothGattServerCallback)
    }

    @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
    override fun closeGATTServer() {
        server.close()
    }

    @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
    override fun addService(serviceArgs: MutableGATTServiceArgs, callback: (Result<Unit>) -> Unit) {
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

    @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
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

    @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
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
        settingsArgs: AdvertiseSettingsArgs,
        advertiseDataArgs: AdvertiseDataArgs,
        scanResponseArgs: AdvertiseDataArgs,
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

    @RequiresPermission(allOf = [Manifest.permission.BLUETOOTH_ADVERTISE, Manifest.permission.BLUETOOTH_CONNECT])
    override fun stopAdvertising() {
        advertiser.stopAdvertising(mAdvertiseCallback)
        mAdvertising = false
        restoreName()
    }

    // Hands the name the adapter had before the peripheral renamed it back, so
    // that the phone stops showing up under the name of the advertisement.
    @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
    fun restoreName() {
        val nameArgs = mOriginalName ?: return
        mOriginalName = null
        try {
            if (adapter.name == nameArgs) {
                return
            }
            adapter.setName(nameArgs)
            Log.v(TAG, "Restored the bluetooth name $nameArgs.")
        } catch (e: Throwable) {
            Log.w(TAG, "Restoring the bluetooth name $nameArgs failed: $e.")
        }
    }

    override fun getCentral(addressArgs: String): CentralArgs {
        val device = adapter.getRemoteDevice(addressArgs)
        val centralArgs = device.toCentralArgs()
        val addressArgs = centralArgs.addressArgs
        mDevices[addressArgs] = device
        return centralArgs
    }

    @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
    override fun retrieveConnectedCentrals(): List<CentralArgs> {
        // The `BluetoothProfile.GATT` and `BluetoothProfile.GATT_SERVER` return same devices.
        val devices = manager.getConnectedDevices(BluetoothProfile.GATT_SERVER)
        val centralsArgs = devices.map { device ->
            val centralArgs = device.toCentralArgs()
            val addressArgs = centralArgs.addressArgs
            mDevices[addressArgs] = device
            return@map centralArgs
        }
        return centralsArgs
    }

    @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
    override fun disconnect(addressArgs: String) {
        val device = mDevices[addressArgs] ?: throw IllegalArgumentException()
        server.cancelConnection(device)
    }

    @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
    override fun sendResponse(
        addressArgs: String, idArgs: Long, statusArgs: GATTStatusArgs, offsetArgs: Long, valueArgs: ByteArray?
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

    @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
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
                mApi.onStateChanged(stateArgs) {}
            }

            BluetoothAdapter.ACTION_LOCAL_NAME_CHANGED -> {
                val callback = mSetNameCallback ?: return
                mSetNameCallback = null
                val nameArgs = intent.getStringExtra(BluetoothAdapter.EXTRA_LOCAL_NAME)
                callback(Result.success(nameArgs))
            }

            BluetoothDevice.ACTION_PAIRING_REQUEST -> {
                val device = getDevice(intent) ?: return
                // A central that pairs over BR/EDR never shows up as a connected
                // GATT device, so this is gated on the advertising rather than on
                // the connected centrals: a phone pairing with a phone does the
                // classic procedure, and that is exactly the one that needs it.
                if (!mAdvertising) return
                showPairing(device, intent)
            }

            BluetoothDevice.ACTION_BOND_STATE_CHANGED -> {
                val device = getDevice(intent) ?: return
                val previousState = intent.getIntExtra(BluetoothDevice.EXTRA_PREVIOUS_BOND_STATE, BluetoothDevice.ERROR)
                val state = intent.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, BluetoothDevice.ERROR)
                Log.v(TAG, "Bond state of ${device.address} changed from $previousState to $state.")
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
        mApi.onConnectionStateChanged(centralArgs, statusArgs, stateArgs) {}
    }

    private fun showPairing(device: BluetoothDevice, intent: Intent) {
        val variant = intent.getIntExtra(BluetoothDevice.EXTRA_PAIRING_VARIANT, BluetoothDevice.ERROR)
        val key = intent.getIntExtra(BluetoothDevice.EXTRA_PAIRING_KEY, BluetoothDevice.ERROR)
        Log.v(TAG, "Pairing with ${device.address} asked for variant $variant, key $key.")
        // Answering the request takes `setPairingConfirmation` or `setPin`, both
        // of which are kept for privileged callers, so the only thing left to do
        // is make sure the user actually sees it: the stack posts a notification
        // instead of a dialog whenever the screen is off, and that notification
        // is easily missed, so bring up the dialog of the bluetooth settings.
        val dialog = Intent(BluetoothDevice.ACTION_PAIRING_REQUEST)
        dialog.setClassName(PAIRING_PACKAGE, PAIRING_CLASS)
        dialog.putExtra(BluetoothDevice.EXTRA_DEVICE, device)
        dialog.putExtra(BluetoothDevice.EXTRA_PAIRING_VARIANT, variant)
        dialog.putExtra(BluetoothDevice.EXTRA_PAIRING_KEY, key)
        dialog.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        dialog.addFlags(Intent.FLAG_ACTIVITY_NO_USER_ACTION)
        try {
            context.startActivity(dialog)
        } catch (e: Throwable) {
            Log.w(TAG, "Showing the pairing dialog of ${device.address} failed: $e.")
            // Not every build ships that dialog, fall back to the bluetooth
            // settings, where the pairing can be finished by hand.
            try {
                val settings = Intent(Settings.ACTION_BLUETOOTH_SETTINGS)
                settings.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(settings)
            } catch (e2: Throwable) {
                Log.w(TAG, "Showing the bluetooth settings failed: $e2.")
            }
        }
    }

    @Suppress("DEPRECATION")
    private fun getDevice(intent: Intent): BluetoothDevice? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE, BluetoothDevice::class.java)
        } else {
            intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE) as? BluetoothDevice
        }
    }

    fun onMtuChanged(device: BluetoothDevice, mtu: Int) {
        val centralArgs = device.toCentralArgs()
        val mtuArgs = mtu.args
        mApi.onMTUChanged(centralArgs, mtuArgs) {}
    }

    @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
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
            mApi.onCharacteristicReadRequest(centralArgs, idArgs, offsetArgs, hashCodeArgs) {}
        }
    }

    @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
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
            mApi.onCharacteristicWriteRequest(
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

    @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
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
            mApi.onDescriptorReadRequest(centralArgs, idArgs, offsetArgs, hashCodeArgs) {}
        }
    }

    @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
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
            mApi.onDescriptorWriteRequest(
                centralArgs, idArgs, hashCodeArgs, preparedWrite, responseNeeded, offsetArgs, value
            ) {}
        }
    }

    fun onExecuteWrite(device: BluetoothDevice, requestId: Int, execute: Boolean) {
        val centralArgs = device.toCentralArgs()
        val idArgs = requestId.args
        mApi.onExecuteWrite(centralArgs, idArgs, execute) {}
    }

    private fun addServiceArgs(serviceArgs: MutableGATTServiceArgs): BluetoothGattService {
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

    private fun removeServiceArgs(serviceArgs: MutableGATTServiceArgs) {
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