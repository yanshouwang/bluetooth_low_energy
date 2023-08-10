package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothManager
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import java.util.UUID

class MyCentralController(private val context: Context, private val binaryMessenger: BinaryMessenger) : MyCentralControllerHostApi {
    companion object {
        const val REQUEST_CODE = 443

        private val CLIENT_CHARACTERISTIC_CONFIG_UUID = UUID.fromString("00002902-0000-1000-8000-00805f9b34fb")
        private val permissions = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.BLUETOOTH_SCAN, android.Manifest.permission.BLUETOOTH_CONNECT)
        } else {
            arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION)
        }
    }

    private var binding: ActivityPluginBinding? = null

    private val api = MyCentralControllerFlutterApi(binaryMessenger)
    private val executor = ContextCompat.getMainExecutor(context)
    private val bluetoothManager = ContextCompat.getSystemService(context, BluetoothManager::class.java) as BluetoothManager
    private val bluetoothAdapter = bluetoothManager.adapter
    private val bluetoothLeScanner = bluetoothAdapter.bluetoothLeScanner

    private val instanceManager = MyInstanceManager()
    private val requestPermissionsResultListener = MyRequestPermissionResultListener()
    private val broadcastReceiver = MyBroadcastReceiver(api)
    private val scanCallback = MyScanCallback(instanceManager, api)
    private val bluetoothGattCallback = MyBluetoothGattCallback(instanceManager, api, executor)

    fun setUp() {
        MyCentralControllerHostApi.setUp(binaryMessenger, this)
    }

    fun tearDown() {
        MyCentralControllerHostApi.setUp(binaryMessenger, null)
    }

    fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.binding = binding
        binding.addRequestPermissionsResultListener(requestPermissionsResultListener)
    }

    fun onDetachedFromActivity() {
        val binding = binding ?: return
        binding.removeRequestPermissionsResultListener(requestPermissionsResultListener)
        this.binding = null
    }

    override fun initialize(callback: (Result<Unit>) -> Unit) {
        try {
            val unfinishedCallback = requestPermissionsResultListener.callback
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val activity = binding?.activity ?: throw IllegalStateException()
            ActivityCompat.requestPermissions(activity, permissions, REQUEST_CODE)
            requestPermissionsResultListener.callback = { authorized ->
                if (authorized) {
                    val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
                    context.registerReceiver(broadcastReceiver, filter)
                }
                callback(Result.success(Unit))
            }
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun free(hashCode: Long) {
        val key = hashCode.toInt()
        instanceManager.free(key)
    }

    override fun getState(): Long {
        val authorized = permissions.all { permission -> ActivityCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED }
        val stateArgs = if (authorized) bluetoothAdapter.stateArgs
        else MyCentralControllerStateArgs.UNAUTHORIZED
        return stateArgs.raw.toLong()
    }

    override fun startDiscovery(callback: (Result<Unit>) -> Unit) {
        try {
            val unfinishedCallback = scanCallback.scanFailedCallback
            if (unfinishedCallback != null) {
                throw IllegalStateException()
            }
            val filters = emptyList<ScanFilter>()
            val settings = ScanSettings.Builder().setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY).build()
            bluetoothLeScanner.startScan(filters, settings, scanCallback)
            scanCallback.scanFailedCallback = { errorCode ->
                val exception = IllegalStateException("Start discovery failed with error code: $errorCode")
                callback(Result.failure(exception))
            }
            executor.execute {
                scanCallback.scanFailedCallback ?: return@execute
                callback(Result.success(Unit))
                scanCallback.scanFailedCallback = null
            }
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun stopDiscovery() {
        bluetoothLeScanner.stopScan(scanCallback)
    }

    override fun connect(peripheralHashCode: Long, callback: (Result<Unit>) -> Unit) {
        try {
            val myPeripheralKey = peripheralHashCode.toInt()
            val myPeripheral = instanceManager.instanceOf(myPeripheralKey) as MyPeripheral
            val device = myPeripheral.device
            myPeripheral.gatt = connectPrivately(device, callback)
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    private fun connectPrivately(device: BluetoothDevice, callback: (Result<Unit>) -> Unit): BluetoothGatt {
        val key = device.hashCode()
        val unfinishedCallback = bluetoothGattCallback.connectCallbacks[key]
        if (unfinishedCallback != null) {
            throw IllegalStateException()
        }
        val autoConnect = false
        val gatt = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val transport = BluetoothDevice.TRANSPORT_LE
            device.connectGatt(context, autoConnect, bluetoothGattCallback, transport)
        } else {
            device.connectGatt(context, autoConnect, bluetoothGattCallback)
        }
        bluetoothGattCallback.connectCallbacks[key] = callback
        return gatt
    }

    override fun disconnect(peripheralHashCode: Long, callback: (Result<Unit>) -> Unit) {
        try {
            val myPeripheralKey = peripheralHashCode.toInt()
            val myPeripheral = instanceManager.instanceOf(myPeripheralKey) as MyPeripheral
            val gatt = myPeripheral.gatt
            disconnectPrivately(gatt, callback)
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    private fun disconnectPrivately(gatt: BluetoothGatt, callback: (Result<Unit>) -> Unit) {
        val key = gatt.hashCode()
        val unfinishedCallback = bluetoothGattCallback.disconnectCallbacks[key]
        if (unfinishedCallback != null) {
            throw IllegalStateException()
        }
        gatt.disconnect()
        bluetoothGattCallback.disconnectCallbacks[key] = callback
    }

    override fun discoverGATT(peripheralHashCode: Long, callback: (Result<Unit>) -> Unit) {
        try {
            val myPeripheralKey = peripheralHashCode.toInt()
            val myPeripheral = instanceManager.instanceOf(myPeripheralKey) as MyPeripheral
            val gatt = myPeripheral.gatt
            discoverGattPrivately(gatt, callback)
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    private fun discoverGattPrivately(gatt: BluetoothGatt, callback: (Result<Unit>) -> Unit) {
        val key = gatt.hashCode()
        val unfinishedCallback = bluetoothGattCallback.discoverGattCallbacks[key]
        if (unfinishedCallback != null) {
            throw IllegalStateException()
        }
        val isDiscovering = gatt.discoverServices()
        if (!isDiscovering) {
            throw IllegalStateException()
        }
        bluetoothGattCallback.discoverGattCallbacks[key] = callback
    }

    override fun getServices(peripheralHashCode: Long): List<MyGattServiceArgs> {
        val myPeripheralKey = peripheralHashCode.toInt()
        val myPeripheral = instanceManager.instanceOf(myPeripheralKey) as MyPeripheral
        val gatt = myPeripheral.gatt
        val services = gatt.services
        return services.map { service ->
            val key = service.hashCode()
            val instance = instanceManager.instanceOf(key)
            val myService = if (instance is MyGattService) instance
            else MyGattService(gatt, service, instanceManager)
            myService.toArgs()
        }
    }

    override fun getCharacteristics(serviceHashCode: Long): List<MyGattCharacteristicArgs> {
        val myServiceKey = serviceHashCode.toInt()
        val myService = instanceManager.instanceOf(myServiceKey) as MyGattService
        val gatt = myService.gatt
        val service = myService.service
        val characteristics = service.characteristics
        return characteristics.map { characteristic ->
            val key = characteristic.hashCode()
            val instance = instanceManager.instanceOf(key)
            val myCharacteristic = if (instance is MyGattCharacteristic) instance
            else MyGattCharacteristic(gatt, characteristic, instanceManager)
            myCharacteristic.toArgs()
        }
    }

    override fun getDescriptors(characteristicHashCode: Long): List<MyGattDescriptorArgs> {
        val myCharacteristicKey = characteristicHashCode.toInt()
        val myCharacteristic = instanceManager.instanceOf(myCharacteristicKey) as MyGattCharacteristic
        val gatt = myCharacteristic.gatt
        val characteristic = myCharacteristic.characteristic
        val descriptors = characteristic.descriptors
        return descriptors.map { descriptor ->
            val key = descriptor.hashCode()
            val instance = instanceManager.instanceOf(key)
            val myDescriptor = if (instance is MyGattDescriptor) instance
            else MyGattDescriptor(gatt, descriptor, instanceManager)
            myDescriptor.toArgs()
        }
    }

    override fun readCharacteristic(characteristicHashCode: Long, callback: (Result<ByteArray>) -> Unit) {
        try {
            val myCharacteristicKey = characteristicHashCode.toInt()
            val myCharacteristic = instanceManager.instanceOf(myCharacteristicKey) as MyGattCharacteristic
            val gatt = myCharacteristic.gatt
            val characteristic = myCharacteristic.characteristic
            readCharacteristicPrivately(gatt, characteristic, callback)
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    private fun readCharacteristicPrivately(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, callback: (Result<ByteArray>) -> Unit) {
        val key = characteristic.hashCode()
        val unfinishedCallback = bluetoothGattCallback.readCharacteristicCallbacks[key]
        if (unfinishedCallback != null) {
            throw IllegalStateException()
        }
        val isReading = gatt.readCharacteristic(characteristic)
        if (!isReading) {
            throw IllegalStateException()
        }
        bluetoothGattCallback.readCharacteristicCallbacks[key] = callback
    }

    override fun writeCharacteristic(characteristicHashCode: Long, value: ByteArray, typeNumber: Long, callback: (Result<Unit>) -> Unit) {
        try {
            val myCharacteristicKey = characteristicHashCode.toInt()
            val myCharacteristic = instanceManager.instanceOf(myCharacteristicKey) as MyGattCharacteristic
            val gatt = myCharacteristic.gatt
            val characteristic = myCharacteristic.characteristic
            val typeRaw = typeNumber.toInt()
            val typeArgs = MyGattCharacteristicWriteTypeArgs.ofRaw(typeRaw)
                    ?: throw IllegalArgumentException()
            val type = typeArgs.toType()
            writeCharacteristicPrivately(gatt, characteristic, value, type, callback)
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    private fun writeCharacteristicPrivately(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, value: ByteArray, type: Int, callback: (Result<Unit>) -> Unit) {
        val key = characteristic.hashCode()
        val unfinishedCallback = bluetoothGattCallback.writeCharacteristicCallbacks[key]
        if (unfinishedCallback != null) {
            throw IllegalStateException()
        }
        characteristic.value = value
        characteristic.writeType = type
        val isWriting = gatt.writeCharacteristic(characteristic)
        if (!isWriting) {
            throw IllegalStateException()
        }
        bluetoothGattCallback.writeCharacteristicCallbacks[key] = callback
    }

    override fun notifyCharacteristic(characteristicHashCode: Long, state: Boolean, callback: (Result<Unit>) -> Unit) {
        try {
            val myCharacteristicKey = characteristicHashCode.toInt()
            val myCharacteristic = instanceManager.instanceOf(myCharacteristicKey) as MyGattCharacteristic
            val gatt = myCharacteristic.gatt
            val characteristic = myCharacteristic.characteristic
            val isNotifying = gatt.setCharacteristicNotification(characteristic, state)
            if (!isNotifying) {
                throw IllegalStateException()
            }
            val descriptor = characteristic.getDescriptor(CLIENT_CHARACTERISTIC_CONFIG_UUID)
            val value = if (state) BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
            else BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
            writeDescriptorPrivately(gatt, descriptor, value, callback)
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun readDescriptor(descriptorHashCode: Long, callback: (Result<ByteArray>) -> Unit) {
        try {
            val myDescriptorKey = descriptorHashCode.toInt()
            val myDescriptor = instanceManager.instanceOf(myDescriptorKey) as MyGattDescriptor
            val gatt = myDescriptor.gatt
            val descriptor = myDescriptor.descriptor
            readDescriptorPrivately(gatt, descriptor, callback)
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    private fun readDescriptorPrivately(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, callback: (Result<ByteArray>) -> Unit) {
        val key = descriptor.hashCode()
        val unfinishedCallback = bluetoothGattCallback.readDescriptorCallbacks[key]
        if (unfinishedCallback != null) {
            throw IllegalStateException()
        }
        val isReading = gatt.readDescriptor(descriptor)
        if (!isReading) {
            throw IllegalStateException()
        }
        bluetoothGattCallback.readCharacteristicCallbacks[key] = callback
    }

    override fun writeDescriptor(descriptorHashCode: Long, value: ByteArray, callback: (Result<Unit>) -> Unit) {
        try {
            val myDescriptorKey = descriptorHashCode.toInt()
            val myDescriptor = instanceManager.instanceOf(myDescriptorKey) as MyGattDescriptor
            val gatt = myDescriptor.gatt
            val descriptor = myDescriptor.descriptor
            writeDescriptorPrivately(gatt, descriptor, value, callback)
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    private fun writeDescriptorPrivately(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, value: ByteArray, callback: (Result<Unit>) -> Unit) {
        val key = descriptor.hashCode()
        val unfinishedCallback = bluetoothGattCallback.writeDescriptorCallbacks[key]
        if (unfinishedCallback != null) {
            throw IllegalStateException()
        }
        descriptor.value = value
        val isWriting = gatt.writeDescriptor(descriptor)
        if (!isWriting) {
            throw IllegalStateException()
        }
        bluetoothGattCallback.writeCharacteristicCallbacks[key] = callback
    }
}

private val BluetoothAdapter.stateArgs: MyCentralControllerStateArgs
    get() = when (state) {
        BluetoothAdapter.STATE_ON -> MyCentralControllerStateArgs.POWEREDON
        else -> MyCentralControllerStateArgs.POWEREDOFF
    }

private fun MyGattCharacteristicWriteTypeArgs.toType(): Int {
    return when (this) {
        MyGattCharacteristicWriteTypeArgs.WITHRESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
        MyGattCharacteristicWriteTypeArgs.WITHOUTRESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
    }
}