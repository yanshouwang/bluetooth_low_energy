package dev.yanshouwang.bluetooth_low_energy_android

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothProfile
import android.bluetooth.BluetoothStatusCodes
import android.bluetooth.le.BluetoothLeScanner
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.ParcelUuid
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.app.ActivityOptionsCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.BinaryMessenger
import java.util.concurrent.Executor

class MyCentralManager(context: Context, binaryMessenger: BinaryMessenger) : MyBluetoothLowEnergyManager(context), MyCentralManagerHostAPI {
    private val mAPI: MyCentralManagerFlutterAPI

    private val mScanCallback: ScanCallback by lazy { MyScanCallback(this) }
    private val mBluetoothGattCallback: BluetoothGattCallback by lazy { MyBluetoothGattCallback(this, executor) }

    private var mDiscovering: Boolean

    private val mDevices: MutableMap<String, BluetoothDevice>
    private val mGATTs: MutableMap<String, BluetoothGatt>
    private val mCharacteristics: MutableMap<String, Map<Long, BluetoothGattCharacteristic>>
    private val mDescriptors: MutableMap<String, Map<Long, BluetoothGattDescriptor>>

    private var mAuthorizeCallback: ((Result<Boolean>) -> Unit)?
    private var mShowAppSettingsCallback: ((Result<Unit>) -> Unit)?
    private var mStartDiscoveryCallback: ((Result<Unit>) -> Unit)?
    private val mConnectCallbacks: MutableMap<String, (Result<Unit>) -> Unit>
    private val mDisconnectCallbacks: MutableMap<String, (Result<Unit>) -> Unit>
    private val mRequestMtuCallbacks: MutableMap<String, (Result<Long>) -> Unit>
    private val mReadRssiCallbacks: MutableMap<String, (Result<Long>) -> Unit>
    private val mDiscoverServicesCallbacks: MutableMap<String, (Result<List<MyGATTServiceArgs>>) -> Unit>
    private val mReadCharacteristicCallbacks: MutableMap<String, MutableMap<Long, (Result<ByteArray>) -> Unit>>
    private val mWriteCharacteristicCallbacks: MutableMap<String, MutableMap<Long, (Result<Unit>) -> Unit>>
    private val mReadDescriptorCallbacks: MutableMap<String, MutableMap<Long, (Result<ByteArray>) -> Unit>>
    private val mWriteDescriptorCallbacks: MutableMap<String, MutableMap<Long, (Result<Unit>) -> Unit>>

    init {
        mAPI = MyCentralManagerFlutterAPI(binaryMessenger)

        mDiscovering = false

        mDevices = mutableMapOf()
        mGATTs = mutableMapOf()
        mCharacteristics = mutableMapOf()
        mDescriptors = mutableMapOf()

        mAuthorizeCallback = null
        mShowAppSettingsCallback = null
        mStartDiscoveryCallback = null
        mConnectCallbacks = mutableMapOf()
        mDisconnectCallbacks = mutableMapOf()
        mRequestMtuCallbacks = mutableMapOf()
        mReadRssiCallbacks = mutableMapOf()
        mDiscoverServicesCallbacks = mutableMapOf()
        mReadCharacteristicCallbacks = mutableMapOf()
        mWriteCharacteristicCallbacks = mutableMapOf()
        mReadDescriptorCallbacks = mutableMapOf()
        mWriteDescriptorCallbacks = mutableMapOf()
    }

    private val permissions: Array<String>
        get() = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            arrayOf(android.Manifest.permission.ACCESS_COARSE_LOCATION, android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.BLUETOOTH_SCAN, android.Manifest.permission.BLUETOOTH_CONNECT)
        } else {
            arrayOf(android.Manifest.permission.ACCESS_COARSE_LOCATION, android.Manifest.permission.ACCESS_FINE_LOCATION)
        }
    private val manager get() = ContextCompat.getSystemService(context, BluetoothManager::class.java) as BluetoothManager
    private val adapter get() = manager.adapter as BluetoothAdapter
    private val scanner: BluetoothLeScanner get() = adapter.bluetoothLeScanner
    private val executor get() = ContextCompat.getMainExecutor(context) as Executor

    override fun initialize(): MyCentralManagerArgs {
        if (mDiscovering) {
            stopDiscovery()
        }

        for (gatt in mGATTs.values) {
            gatt.disconnect()
        }

        mDevices.clear()
        mGATTs.clear()
        mCharacteristics.clear()
        mDescriptors.clear()

        mAuthorizeCallback = null
        mShowAppSettingsCallback = null
        mStartDiscoveryCallback = null
        mConnectCallbacks.clear()
        mDisconnectCallbacks.clear()
        mRequestMtuCallbacks.clear()
        mReadRssiCallbacks.clear()
        mDiscoverServicesCallbacks.clear()
        mReadCharacteristicCallbacks.clear()
        mWriteCharacteristicCallbacks.clear()
        mReadDescriptorCallbacks.clear()
        mWriteDescriptorCallbacks.clear()

        val enableNotificationValue = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
        val enableIndicationValue = BluetoothGattDescriptor.ENABLE_INDICATION_VALUE
        val disableNotificationValue = BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
        return MyCentralManagerArgs(enableNotificationValue, enableIndicationValue, disableNotificationValue)
    }

    override fun getState(): MyBluetoothLowEnergyStateArgs {
        val supported = context.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
        return if (supported) {
            val authorized = permissions.all { permission -> ActivityCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED }
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

    override fun startDiscovery(serviceUUIDsArgs: List<String>, callback: (Result<Unit>) -> Unit) {
        try {
            val filters = mutableListOf<ScanFilter>()
            for (serviceUuidArgs in serviceUUIDsArgs) {
                val serviceUUID = ParcelUuid.fromString(serviceUuidArgs)
                val filter = ScanFilter.Builder().setServiceUuid(serviceUUID).build()
                filters.add(filter)
            }
            val settings = ScanSettings.Builder().setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY).build()
            scanner.startScan(filters, settings, mScanCallback)
            executor.execute { onScanSucceeded() }
            mStartDiscoveryCallback = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun stopDiscovery() {
        scanner.stopScan(mScanCallback)
        mDiscovering = false
    }

    override fun connect(addressArgs: String, callback: (Result<Unit>) -> Unit) {
        try {
            val device = mDevices[addressArgs] as BluetoothDevice
            val autoConnect = false // Add to bluetoothGATTs cache.
            mGATTs[addressArgs] = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val transport = BluetoothDevice.TRANSPORT_LE
                device.connectGatt(context, autoConnect, mBluetoothGattCallback, transport)
            } else {
                device.connectGatt(context, autoConnect, mBluetoothGattCallback)
            }
            mConnectCallbacks[addressArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun disconnect(addressArgs: String, callback: (Result<Unit>) -> Unit) {
        try {
            val gatt = mGATTs[addressArgs] as BluetoothGatt
            gatt.disconnect()
            mDisconnectCallbacks[addressArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun retrieveConnectedPeripherals(): List<MyPeripheralArgs> {
        // The `BluetoothProfile.GATT` and `BluetoothProfile.GATT_SERVER` return same devices.
        val devices = manager.getConnectedDevices(BluetoothProfile.GATT)
        val peripheralsArgs = devices.map { device ->
            val peripheralArgs = device.toPeripheralArgs()
            val addressArgs = peripheralArgs.addressArgs
            mDevices[addressArgs] = device
            return@map peripheralArgs
        }
        return peripheralsArgs
    }

    override fun requestMTU(addressArgs: String, mtuArgs: Long, callback: (Result<Long>) -> Unit) {
        try {
            val gatt = mGATTs[addressArgs] as BluetoothGatt
            val mtu = mtuArgs.toInt()
            val requesting = gatt.requestMtu(mtu)
            if (!requesting) {
                throw IllegalStateException()
            }
            mRequestMtuCallbacks[addressArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun readRSSI(addressArgs: String, callback: (Result<Long>) -> Unit) {
        try {
            val gatt = mGATTs[addressArgs] as BluetoothGatt
            val reading = gatt.readRemoteRssi()
            if (!reading) {
                throw IllegalStateException()
            }
            mReadRssiCallbacks[addressArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun discoverGATT(addressArgs: String, callback: (Result<List<MyGATTServiceArgs>>) -> Unit) {
        try {
            val gatt = mGATTs[addressArgs] as BluetoothGatt
            val discovering = gatt.discoverServices()
            if (!discovering) {
                throw IllegalStateException()
            }
            mDiscoverServicesCallbacks[addressArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun readCharacteristic(addressArgs: String, hashCodeArgs: Long, callback: (Result<ByteArray>) -> Unit) {
        try {
            val gatt = mGATTs[addressArgs] as BluetoothGatt
            val characteristic = retrieveCharacteristic(addressArgs, hashCodeArgs) as BluetoothGattCharacteristic
            val reading = gatt.readCharacteristic(characteristic)
            if (!reading) {
                throw IllegalStateException()
            }
            val callbacks = mReadCharacteristicCallbacks.getOrPut(addressArgs) { mutableMapOf() }
            callbacks[hashCodeArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun writeCharacteristic(addressArgs: String, hashCodeArgs: Long, valueArgs: ByteArray, typeArgs: MyGATTCharacteristicWriteTypeArgs, callback: (Result<Unit>) -> Unit) {
        try {
            val gatt = mGATTs[addressArgs] as BluetoothGatt
            val characteristic = retrieveCharacteristic(addressArgs, hashCodeArgs) as BluetoothGattCharacteristic
            val type = typeArgs.toType()
            val writing = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val code = gatt.writeCharacteristic(characteristic, valueArgs, type)
                code == BluetoothStatusCodes.SUCCESS
            } else { // TODO: remove this when minSdkVersion >= 33
                characteristic.value = valueArgs
                characteristic.writeType = type
                gatt.writeCharacteristic(characteristic)
            }
            if (!writing) {
                throw IllegalStateException()
            }
            val callbacks = mWriteCharacteristicCallbacks.getOrPut(addressArgs) { mutableMapOf() }
            callbacks[hashCodeArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun setCharacteristicNotification(addressArgs: String, hashCodeArgs: Long, enableArgs: Boolean) {
        val gatt = mGATTs[addressArgs] as BluetoothGatt
        val characteristic = retrieveCharacteristic(addressArgs, hashCodeArgs) as BluetoothGattCharacteristic
        val notifying = gatt.setCharacteristicNotification(characteristic, enableArgs)
        if (!notifying) {
            throw IllegalStateException()
        }
    }

    override fun readDescriptor(addressArgs: String, hashCodeArgs: Long, callback: (Result<ByteArray>) -> Unit) {
        try {
            val gatt = mGATTs[addressArgs] as BluetoothGatt
            val descriptor = retrieveDescriptor(addressArgs, hashCodeArgs) as BluetoothGattDescriptor
            val reading = gatt.readDescriptor(descriptor)
            if (!reading) {
                throw IllegalStateException()
            }
            val callbacks = mReadDescriptorCallbacks.getOrPut(addressArgs) { mutableMapOf() }
            callbacks[hashCodeArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun writeDescriptor(addressArgs: String, hashCodeArgs: Long, valueArgs: ByteArray, callback: (Result<Unit>) -> Unit) {
        try {
            val gatt = mGATTs[addressArgs] as BluetoothGatt
            val descriptor = retrieveDescriptor(addressArgs, hashCodeArgs) as BluetoothGattDescriptor
            val writing = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val code = gatt.writeDescriptor(descriptor, valueArgs)
                code == BluetoothStatusCodes.SUCCESS
            } else { // TODO: remove this when minSdkVersion >= 33
                descriptor.value = valueArgs
                gatt.writeDescriptor(descriptor)
            }
            if (!writing) {
                throw IllegalStateException()
            }
            val callbacks = mWriteDescriptorCallbacks.getOrPut(addressArgs) { mutableMapOf() }
            callbacks[hashCodeArgs] = callback
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
        val authorized = permissions.contentEquals(this.permissions) && results.all { r -> r == PackageManager.PERMISSION_GRANTED }
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

    private fun onScanSucceeded() {
        mDiscovering = true
        val callback = mStartDiscoveryCallback ?: return
        mStartDiscoveryCallback = null
        callback(Result.success(Unit))
    }

    fun onScanFailed(errorCode: Int) {
        val callback = mStartDiscoveryCallback ?: return
        mStartDiscoveryCallback = null
        val error = IllegalStateException("Start discovery failed with error code: $errorCode")
        callback(Result.failure(error))
    }

    fun onScanResult(result: ScanResult) {
        val device = result.device
        val peripheralArgs = device.toPeripheralArgs()
        val addressArgs = peripheralArgs.addressArgs
        val rssiArgs = result.rssi.toLong()
        val advertisementArgs = result.toAdvertisementArgs()
        mDevices[addressArgs] = device
        mAPI.onDiscovered(peripheralArgs, rssiArgs, advertisementArgs) {}
    }

    fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
        val device = gatt.device
        val addressArgs = device.address // check connection state.
        if (newState == BluetoothProfile.STATE_DISCONNECTED) {
            gatt.close()
            mGATTs.remove(addressArgs)
            mCharacteristics.remove(addressArgs)
            mDescriptors.remove(addressArgs)
            val error = IllegalStateException("GATT is disconnected with status: $status")
            val requestMtuCallback = mRequestMtuCallbacks.remove(addressArgs)
            if (requestMtuCallback != null) {
                requestMtuCallback(Result.failure(error))
            }
            val readRssiCallback = mReadRssiCallbacks.remove(addressArgs)
            if (readRssiCallback != null) {
                readRssiCallback(Result.failure(error))
            }
            val discoverServicesCallback = mDiscoverServicesCallbacks.remove(addressArgs)
            if (discoverServicesCallback != null) {
                discoverServicesCallback(Result.failure(error))
            }
            val readCharacteristicCallbacks = mReadCharacteristicCallbacks.remove(addressArgs)
            if (readCharacteristicCallbacks != null) {
                val callbacks = readCharacteristicCallbacks.values
                for (callback in callbacks) {
                    callback(Result.failure(error))
                }
            }
            val writeCharacteristicCallbacks = mWriteCharacteristicCallbacks.remove(addressArgs)
            if (writeCharacteristicCallbacks != null) {
                val callbacks = writeCharacteristicCallbacks.values
                for (callback in callbacks) {
                    callback(Result.failure(error))
                }
            }
            val readDescriptorCallbacks = mReadDescriptorCallbacks.remove(addressArgs)
            if (readDescriptorCallbacks != null) {
                val callbacks = readDescriptorCallbacks.values
                for (callback in callbacks) {
                    callback(Result.failure(error))
                }
            }
            val writeDescriptorCallbacks = mWriteDescriptorCallbacks.remove(addressArgs)
            if (writeDescriptorCallbacks != null) {
                val callbacks = writeDescriptorCallbacks.values
                for (callback in callbacks) {
                    callback(Result.failure(error))
                }
            }
        }
        val stateArgs = newState.toConnectionStateArgs()
        mAPI.onConnectionStateChanged(addressArgs, stateArgs) {} // check connect & disconnect callbacks.
        val connectCallback = mConnectCallbacks.remove(addressArgs)
        if (connectCallback != null) {
            if (status == BluetoothGatt.GATT_SUCCESS) {
                connectCallback(Result.success(Unit))
            } else {
                val error = IllegalStateException("Connect failed with status: $status")
                connectCallback(Result.failure(error))
            }
        }
        val disconnectCallback = mDisconnectCallbacks.remove(addressArgs)
        if (disconnectCallback != null) {
            if (status == BluetoothGatt.GATT_SUCCESS) {
                disconnectCallback(Result.success(Unit))
            } else {
                val error = IllegalStateException("Disconnect failed with status: $status")
                disconnectCallback(Result.failure(error))
            }
        }
    }

    fun onMtuChanged(gatt: BluetoothGatt, mtu: Int, status: Int) {
        val device = gatt.device
        val addressArgs = device.address
        val result = if (status == BluetoothGatt.GATT_SUCCESS) {
            val mtuArgs = mtu.toLong()
            mAPI.onMTUChanged(addressArgs, mtuArgs) {}
            Result.success(mtuArgs)
        } else {
            val error = IllegalStateException("Read RSSI failed with status: $status")
            Result.failure(error)
        }
        val callback = mRequestMtuCallbacks.remove(addressArgs) ?: return
        callback(result)
    }

    fun onReadRemoteRssi(gatt: BluetoothGatt, rssi: Int, status: Int) {
        val device = gatt.device
        val addressArgs = device.address
        val callback = mReadRssiCallbacks.remove(addressArgs) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val rssiArgs = rssi.toLong()
            callback(Result.success(rssiArgs))
        } else {
            val error = IllegalStateException("Read RSSI failed with status: $status")
            callback(Result.failure(error))
        }
    }

    fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
        val device = gatt.device
        val addressArgs = device.address
        val callback = mDiscoverServicesCallbacks.remove(addressArgs) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val services = gatt.services
            val characteristics = services.flatMap { it.characteristics }
            val descriptors = characteristics.flatMap { it.descriptors }
            mCharacteristics[addressArgs] = characteristics.associateBy { it.hashCode().toLong() }
            mDescriptors[addressArgs] = descriptors.associateBy { it.hashCode().toLong() }
            val servicesArgs = services.map { it.toArgs() }
            callback(Result.success(servicesArgs))
        } else {
            val error = IllegalStateException("Discover GATT failed with status: $status")
            callback(Result.failure(error))
        }
    }

    fun onCharacteristicRead(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int, value: ByteArray) {
        val device = gatt.device
        val addressArgs = device.address
        val hashCodeArgs = characteristic.hashCode().toLong()
        val callbacks = mReadCharacteristicCallbacks[addressArgs] ?: return
        val callback = callbacks.remove(hashCodeArgs) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(value))
        } else {
            val error = IllegalStateException("Read characteristic failed with status: $status.")
            callback(Result.failure(error))
        }
    }

    fun onCharacteristicWrite(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int) {
        val device = gatt.device
        val addressArgs = device.address
        val hashCodeArgs = characteristic.hashCode().toLong()
        val callbacks = mWriteCharacteristicCallbacks[addressArgs] ?: return
        val callback = callbacks.remove(hashCodeArgs) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val error = IllegalStateException("Write characteristic failed with status: $status.")
            callback(Result.failure(error))
        }
    }

    fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, value: ByteArray) {
        val device = gatt.device
        val addressArgs = device.address
        val hashCodeArgs = characteristic.hashCode().toLong()
        mAPI.onCharacteristicNotified(addressArgs, hashCodeArgs, value) {}
    }

    fun onDescriptorRead(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int, value: ByteArray) {
        val device = gatt.device
        val addressArgs = device.address
        val hashCodeArgs = descriptor.hashCode().toLong()
        val callbacks = mReadDescriptorCallbacks[addressArgs] ?: return
        val callback = callbacks.remove(hashCodeArgs) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(value))
        } else {
            val error = IllegalStateException("Read descriptor failed with status: $status.")
            callback(Result.failure(error))
        }
    }

    fun onDescriptorWrite(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
        val device = gatt.device
        val addressArgs = device.address
        val hashCodeArgs = descriptor.hashCode().toLong()
        val callbacks = mWriteDescriptorCallbacks[addressArgs] ?: return
        val callback = callbacks.remove(hashCodeArgs) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val error = IllegalStateException("Write descriptor failed with status: $status.")
            callback(Result.failure(error))
        }
    }

    private fun retrieveCharacteristic(addressArgs: String, hashCodeArgs: Long): BluetoothGattCharacteristic? {
        val characteristics = mCharacteristics[addressArgs] ?: return null
        return characteristics[hashCodeArgs]
    }

    private fun retrieveDescriptor(addressArgs: String, hashCodeArgs: Long): BluetoothGattDescriptor? {
        val descriptors = mDescriptors[addressArgs] ?: return null
        return descriptors[hashCodeArgs]
    }
}
