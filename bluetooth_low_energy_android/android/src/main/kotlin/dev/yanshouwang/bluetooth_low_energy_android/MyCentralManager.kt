package dev.yanshouwang.bluetooth_low_energy_android

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
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
import android.os.Build
import io.flutter.plugin.common.BinaryMessenger

class MyCentralManager(context: Context, binaryMessenger: BinaryMessenger) :
    MyBluetoothLowEnergyManager(context), MyCentralManagerHostApi {
    companion object {
        const val REQUEST_CODE = 443
    }

    private val mContext: Context
    private val mApi: MyCentralManagerFlutterApi

    private val mScanCallback: ScanCallback by lazy {
        MyScanCallback(this)
    }
    private val mBluetoothGattCallback: BluetoothGattCallback by lazy {
        MyBluetoothGattCallback(this, executor)
    }

    private var mDiscovering: Boolean

    private val mDevices: MutableMap<String, BluetoothDevice>
    private val mGATTs: MutableMap<String, BluetoothGatt>
    private val mCharacteristics: MutableMap<String, List<BluetoothGattCharacteristic>>
    private val mDescriptors: MutableMap<String, List<BluetoothGattDescriptor>>

    private var mSetUpCallback: ((Result<MyCentralManagerArgs>) -> Unit)?
    private var mStartDiscoveryCallback: ((Result<Unit>) -> Unit)?
    private val mConnectCallbacks: MutableMap<String, (Result<Unit>) -> Unit>
    private val mDisconnectCallbacks: MutableMap<String, (Result<Unit>) -> Unit>
    private val mReadRssiCallbacks: MutableMap<String, (Result<Long>) -> Unit>
    private val mDiscoverGattCallbacks: MutableMap<String, (Result<List<MyGattServiceArgs>>) -> Unit>
    private val mReadCharacteristicCallbacks: MutableMap<String, MutableMap<Long, (Result<ByteArray>) -> Unit>>
    private val mWriteCharacteristicCallbacks: MutableMap<String, MutableMap<Long, (Result<Unit>) -> Unit>>
    private val mReadDescriptorCallbacks: MutableMap<String, MutableMap<Long, (Result<ByteArray>) -> Unit>>
    private val mWriteDescriptorCallbacks: MutableMap<String, MutableMap<Long, (Result<Unit>) -> Unit>>

    init {
        mContext = context
        mApi = MyCentralManagerFlutterApi(binaryMessenger)

        mDiscovering = false

        mDevices = mutableMapOf()
        mGATTs = mutableMapOf()
        mCharacteristics = mutableMapOf()
        mDescriptors = mutableMapOf()

        mSetUpCallback = null
        mStartDiscoveryCallback = null
        mConnectCallbacks = mutableMapOf()
        mDisconnectCallbacks = mutableMapOf()
        mReadRssiCallbacks = mutableMapOf()
        mDiscoverGattCallbacks = mutableMapOf()
        mReadCharacteristicCallbacks = mutableMapOf()
        mWriteCharacteristicCallbacks = mutableMapOf()
        mReadDescriptorCallbacks = mutableMapOf()
        mWriteDescriptorCallbacks = mutableMapOf()
    }

    private val mScanner: BluetoothLeScanner get() = adapter.bluetoothLeScanner

    override fun setUp(callback: (Result<MyCentralManagerArgs>) -> Unit) {
        try {
            mClearState()
            if (unsupported) {
                val stateNumberArgs = MyBluetoothLowEnergyStateArgs.UNSUPPORTED.raw.toLong()
                val args = MyCentralManagerArgs(stateNumberArgs)
                callback(Result.success(args))
            } else {
                val permissions = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    arrayOf(
                        android.Manifest.permission.ACCESS_COARSE_LOCATION,
                        android.Manifest.permission.ACCESS_FINE_LOCATION,
                        android.Manifest.permission.BLUETOOTH_SCAN,
                        android.Manifest.permission.BLUETOOTH_CONNECT
                    )
                } else {
                    arrayOf(
                        android.Manifest.permission.ACCESS_COARSE_LOCATION,
                        android.Manifest.permission.ACCESS_FINE_LOCATION
                    )
                }
                requestPermissions(permissions, REQUEST_CODE)
                mSetUpCallback = callback
            }
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun startDiscovery(callback: (Result<Unit>) -> Unit) {
        try {
            val filters = emptyList<ScanFilter>()
            val settings =
                ScanSettings.Builder().setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY).build()
            mScanner.startScan(filters, settings, mScanCallback)
            mStartDiscoveryCallback = callback
            executor.execute {
                onScanSucceed()
            }
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun stopDiscovery() {
        mScanner.stopScan(mScanCallback)
        mDiscovering = false
    }

    override fun connect(addressArgs: String, callback: (Result<Unit>) -> Unit) {
        try {
            val device = mDevices[addressArgs] as BluetoothDevice
            val autoConnect = false
            // Add to bluetoothGATTs cache.
            mGATTs[addressArgs] = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val transport = BluetoothDevice.TRANSPORT_LE
                device.connectGatt(mContext, autoConnect, mBluetoothGattCallback, transport)
            } else {
                device.connectGatt(mContext, autoConnect, mBluetoothGattCallback)
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

    override fun requestMTU(addressArgs: String, mtuArgs: Long) {
        val gatt = mGATTs[addressArgs] as BluetoothGatt
        val mtu = mtuArgs.toInt()
        val requesting = gatt.requestMtu(mtu)
        if (!requesting) {
            throw IllegalStateException()
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

    override fun discoverGATT(
        addressArgs: String, callback: (Result<List<MyGattServiceArgs>>) -> Unit
    ) {
        try {
            val gatt = mGATTs[addressArgs] as BluetoothGatt
            val discovering = gatt.discoverServices()
            if (!discovering) {
                throw IllegalStateException()
            }
            mDiscoverGattCallbacks[addressArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun readCharacteristic(
        addressArgs: String, hashCodeArgs: Long, callback: (Result<ByteArray>) -> Unit
    ) {
        try {
            val gatt = mGATTs[addressArgs] as BluetoothGatt
            val characteristic =
                mRetrieveCharacteristic(addressArgs, hashCodeArgs) as BluetoothGattCharacteristic
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

    override fun writeCharacteristic(
        addressArgs: String,
        hashCodeArgs: Long,
        valueArgs: ByteArray,
        typeNumberArgs: Long,
        callback: (Result<Unit>) -> Unit
    ) {
        try {
            val gatt = mGATTs[addressArgs] as BluetoothGatt
            val characteristic =
                mRetrieveCharacteristic(addressArgs, hashCodeArgs) as BluetoothGattCharacteristic
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
            val callbacks = mWriteCharacteristicCallbacks.getOrPut(addressArgs) { mutableMapOf() }
            callbacks[hashCodeArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun notifyCharacteristic(
        addressArgs: String,
        hashCodeArgs: Long,
        stateNumberArgs: Long,
        callback: (Result<Unit>) -> Unit
    ) {
        try {
            val gatt = mGATTs[addressArgs] as BluetoothGatt
            val characteristic =
                mRetrieveCharacteristic(addressArgs, hashCodeArgs) as BluetoothGattCharacteristic
            val stateArgs = stateNumberArgs.toNotifyStateArgs()
            val enable = stateArgs != MyGattCharacteristicNotifyStateArgs.NONE
            val notifying = gatt.setCharacteristicNotification(characteristic, enable)
            if (!notifying) {
                throw IllegalStateException()
            }
            // TODO: Seems the docs is not correct, this operation is necessary for all characteristics.
            // https://developer.android.com/guide/topics/connectivity/bluetooth/transfer-ble-data#notification
            // This is specific to Heart Rate Measurement.
            //if (characteristic.uuid == UUID_HEART_RATE_MEASUREMENT) {
            val cccDescriptor = characteristic.getDescriptor(CLIENT_CHARACTERISTIC_CONFIG_UUID)
            val cccHashCodeArgs = cccDescriptor.hashCode().toLong()
            val valueArgs = stateArgs.toValue()
            writeDescriptor(addressArgs, cccHashCodeArgs, valueArgs, callback)
            //} else {
            //    callback(Result.success(Unit))
            //}
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun readDescriptor(
        addressArgs: String, hashCodeArgs: Long, callback: (Result<ByteArray>) -> Unit
    ) {
        try {
            val gatt = mGATTs[addressArgs] as BluetoothGatt
            val descriptor =
                mRetrieveDescriptor(addressArgs, hashCodeArgs) as BluetoothGattDescriptor
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

    override fun writeDescriptor(
        addressArgs: String,
        hashCodeArgs: Long,
        valueArgs: ByteArray,
        callback: (Result<Unit>) -> Unit
    ) {
        try {
            val gatt = mGATTs[addressArgs] as BluetoothGatt
            val descriptor =
                mRetrieveDescriptor(addressArgs, hashCodeArgs) as BluetoothGattDescriptor
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
            val callbacks = mWriteDescriptorCallbacks.getOrPut(addressArgs) { mutableMapOf() }
            callbacks[hashCodeArgs] = callback
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, results: IntArray
    ): Boolean {
        if (requestCode != REQUEST_CODE) {
            return false
        }
        val granted = results.all { r -> r == PackageManager.PERMISSION_GRANTED }
        val callback = mSetUpCallback ?: return false
        mSetUpCallback = null
        val stateArgs = if (granted) adapter.stateArgs
        else MyBluetoothLowEnergyStateArgs.UNAUTHORIZED
        val stateNumberArgs = stateArgs.raw.toLong()
        val args = MyCentralManagerArgs(stateNumberArgs)
        callback(Result.success(args))
        if (granted && !registered) {
            registerReceiver()
        }
        return true
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        if (action != BluetoothAdapter.ACTION_STATE_CHANGED) {
            return
        }
        val state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.STATE_OFF)
        val stateArgs = state.toBluetoothLowEnergyStateArgs()
        val stateNumberArgs = stateArgs.raw.toLong()
        mApi.onStateChanged(stateNumberArgs) {}
    }

    private fun onScanSucceed() {
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
        this.mDevices[addressArgs] = device
        val rssiArgs = result.rssi.toLong()
        val advertisementArgs = result.advertisementArgs
        mApi.onDiscovered(peripheralArgs, rssiArgs, advertisementArgs) {}
    }

    fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
        val device = gatt.device
        val addressArgs = device.address
        // check connection state.
        if (newState == BluetoothProfile.STATE_DISCONNECTED) {
            gatt.close()
            mGATTs.remove(addressArgs)
            mCharacteristics.remove(addressArgs)
            mDescriptors.remove(addressArgs)
            val error = IllegalStateException("GATT is disconnected with status: $status")
            val readRssiCallback = mReadRssiCallbacks.remove(addressArgs)
            if (readRssiCallback != null) {
                readRssiCallback(Result.failure(error))
            }
            val discoverGattCallback = mDiscoverGattCallbacks.remove(addressArgs)
            if (discoverGattCallback != null) {
                discoverGattCallback(Result.failure(error))
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
        val stateArgs = newState == BluetoothProfile.STATE_CONNECTED
        mApi.onPeripheralStateChanged(addressArgs, stateArgs) {}
        // check connect & disconnect callbacks.
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
        if (status != BluetoothGatt.GATT_SUCCESS) {
            return
        }
        val device = gatt.device
        val addressArgs = device.address
        val mtuArgs = mtu.toLong()
        mApi.onMtuChanged(addressArgs, mtuArgs) {}
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
        val callback = mDiscoverGattCallbacks.remove(addressArgs) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val services = gatt.services
            val characteristics = services.flatMap { it.characteristics }
            val descriptors = characteristics.flatMap { it.descriptors }
            mCharacteristics[addressArgs] = characteristics
            mDescriptors[addressArgs] = descriptors
            val servicesArgs = services.map { it.toArgs() }
            callback(Result.success(servicesArgs))
        } else {
            val error = IllegalStateException("Discover GATT failed with status: $status")
            callback(Result.failure(error))
        }
    }

    fun onCharacteristicRead(
        gatt: BluetoothGatt,
        characteristic: BluetoothGattCharacteristic,
        status: Int,
        value: ByteArray
    ) {
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

    fun onCharacteristicWrite(
        gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int
    ) {
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

    fun onCharacteristicChanged(
        gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, value: ByteArray
    ) {
        val device = gatt.device
        val addressArgs = device.address
        val hashCodeArgs = characteristic.hashCode().toLong()
        mApi.onCharacteristicValueChanged(addressArgs, hashCodeArgs, value) {}
    }

    fun onDescriptorRead(
        gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int, value: ByteArray
    ) {
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

    private fun mClearState() {
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
        mSetUpCallback = null
        mStartDiscoveryCallback = null
        mConnectCallbacks.clear()
        mDisconnectCallbacks.clear()
        mReadRssiCallbacks.clear()
        mDiscoverGattCallbacks.clear()
        mReadCharacteristicCallbacks.clear()
        mWriteCharacteristicCallbacks.clear()
        mReadDescriptorCallbacks.clear()
        mWriteDescriptorCallbacks.clear()
    }

    private fun mRetrieveCharacteristic(
        addressArgs: String, hashCodeArgs: Long
    ): BluetoothGattCharacteristic? {
        val characteristics = mCharacteristics[addressArgs]
        return characteristics?.firstOrNull { it.hashCode().toLong() == hashCodeArgs }
    }

    private fun mRetrieveDescriptor(
        addressArgs: String, hashCodeArgs: Long
    ): BluetoothGattDescriptor? {
        val descriptors = mDescriptors[addressArgs]
        return descriptors?.firstOrNull { it.hashCode().toLong() == hashCodeArgs }
    }
}
