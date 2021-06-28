package dev.yanshouwang.bluetooth_low_energy

import android.Manifest
import android.bluetooth.*
import android.bluetooth.le.*
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.*
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.protobuf.ByteString
import dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.*
import dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.Message
import dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.MessageCategory.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener
import java.util.*

const val NAMESPACE = "yanshouwang.dev/bluetooth_low_energy"

typealias RequestPermissionsHandler = (granted: Boolean) -> Unit

/** BluetoothLowEnergyPlugin */
class BluetoothLowEnergyPlugin : FlutterPlugin, MethodCallHandler, StreamHandler, ActivityAware,
        RequestPermissionsResultListener {
    companion object {
        private const val CLIENT_CHARACTERISTIC_CONFIG = "00002902-0000-1000-8000-00805f9b34fb"
        private const val UNKNOWN = -1
        private const val NO_ERROR = 0
        private const val SCAN_ALREADY_STARTED = 1
        private const val INVALID_REQUEST = 2
        private const val REQUEST_PERMISSION_FAILED = 3
        private const val REQUEST_MTU_FAILED = 4
        private const val DISCOVER_SERVICES_FAILED = 5
        private const val READ_CHARACTERISTIC_FAILED = 6
        private const val WRITE_CHARACTERISTIC_FAILED = 7
        private const val NOTIFY_CHARACTERISTIC_FAILED = 8
        private const val READ_DESCRIPTOR_FAILED = 9
        private const val WRITE_DESCRIPTOR_FAILED = 10
        private const val REQUEST_CODE = 443
    }

    private lateinit var method: MethodChannel
    private lateinit var event: EventChannel
    private lateinit var context: Context

    private var binding: ActivityPluginBinding? = null
    private var sink: EventSink? = null

    private val handler by lazy { Handler(context.mainLooper) }

    private val bluetoothManager by lazy { context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager }
    private val bluetoothAdapter by lazy { bluetoothManager.adapter }

    private val bluetoothState: BluetoothState
        get() = when {
            context.missingBluetoothFeature -> BluetoothState.UNSUPPORTED
            else -> bluetoothAdapter.state.bluetoothState
        }

    private val bluetoothStateReceiver by lazy {
        object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val oldState = intent!!.getIntExtra(BluetoothAdapter.EXTRA_PREVIOUS_STATE, UNKNOWN)
                val newState = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, UNKNOWN)
                Log.d(TAG, "Bluetooth adapter old state: $oldState; new state: $newState")
                val event = Message.newBuilder()
                        .setCategory(BLUETOOTH_STATE)
                        .setState(newState.bluetoothState)
                        .build()
                        .toByteArray()
                sink?.success(event)
            }
        }
    }

    private val hasPermission
        get() = ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

    private var requestPermissionsHandler: RequestPermissionsHandler? = null

    private var scanning = false
        set(value) {
            if (field == value)
                return
            field = value
            val event = Message.newBuilder()
                    .setCategory(CENTRAL_SCANNING)
                    .setScanning(field)
                    .build()
                    .toByteArray()
            sink?.success(event)
        }

    private val scan18 by lazy {
        BluetoothAdapter.LeScanCallback { device, rssi, scanRecord ->
            val discovery = Discovery.newBuilder()
                    .setDevice(device.address)
                    .setRssi(rssi)
                    .putAllAdvertisements(scanRecord.advertisements)
                    .build()
            val event = Message.newBuilder()
                    .setCategory(CENTRAL_DISCOVERED)
                    .setDiscovery(discovery)
                    .build()
                    .toByteArray()
            sink?.success(event)
        }
    }

    private val scan21 by lazy {
        @RequiresApi(Build.VERSION_CODES.LOLLIPOP) object : ScanCallback() {
            override fun onScanFailed(errorCode: Int) {
                super.onScanFailed(errorCode)
                Log.d(TAG, "onScanFailed: $errorCode")
            }

            override fun onScanResult(callbackType: Int, result: ScanResult?) {
                super.onScanResult(callbackType, result)
                if (result == null)
                    return
                val builder = Discovery.newBuilder()
                        .setDevice(result.device.address)
                        .setRssi(result.rssi)
                if (result.scanRecord != null) {
                    builder.putAllAdvertisements(result.scanRecord?.bytes?.advertisements)
                }
                val discovery = builder.build()
                val event = Message.newBuilder()
                        .setCategory(CENTRAL_DISCOVERED)
                        .setDiscovery(discovery)
                        .build()
                        .toByteArray()
                sink?.success(event)
            }

            override fun onBatchScanResults(results: MutableList<ScanResult>?) {
                super.onBatchScanResults(results)
                results?.forEach { result ->
                    val builder = Discovery.newBuilder()
                            .setDevice(result.device.address)
                            .setRssi(result.rssi)
                    if (result.scanRecord != null) {
                        builder.putAllAdvertisements(result.scanRecord?.bytes?.advertisements)
                    }
                    val discovery = builder.build()
                    val event = Message.newBuilder()
                            .setCategory(CENTRAL_DISCOVERED)
                            .setDiscovery(discovery)
                            .build()
                            .toByteArray()
                    sink?.success(event)
                }
            }
        }
    }

    private fun startScan(services: List<String>): Int {
        return when {
            scanning -> SCAN_ALREADY_STARTED
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP -> {
                val filters = services.map { service ->
                    val uuid = ParcelUuid.fromString(service)
                    ScanFilter.Builder()
                            .setServiceUuid(uuid)
                            .build()
                }
                val settings = ScanSettings.Builder()
                        .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
                        .build()
                bluetoothAdapter.bluetoothLeScanner.startScan(filters, settings, scan21)
                // TODO: seems there is no way to get success callback when use bluetoothLeScanner#startScan.
                scanning = true
                NO_ERROR
            }
            else -> {
                val uuids = services.map { service -> UUID.fromString(service) }.toTypedArray()
                val succeed = bluetoothAdapter.startLeScan(uuids, scan18)
                if (succeed) {
                    scanning = true
                    NO_ERROR
                } else {
                    UNKNOWN
                }
            }
        }
    }

    private fun stopScan() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            bluetoothAdapter.bluetoothLeScanner.stopScan(scan21)
        } else {
            bluetoothAdapter.stopLeScan(scan18)
        }
        scanning = false
    }

    private val connects by lazy { mutableMapOf<String, Result>() }
    private val mtus by lazy { mutableMapOf<String, Int>() }
    private val disconnects by lazy { mutableMapOf<String, Result>() }
    private val gatts by lazy { mutableMapOf<String, BluetoothGatt>() }
    private val characteristicReads by lazy { mutableMapOf<Int, Result>() }
    private val characteristicWrites by lazy { mutableMapOf<Int, Result>() }
    private val descriptorReads by lazy { mutableMapOf<Int, Result>() }
    private val descriptorWrites by lazy { mutableMapOf<Int, Result>() }

    private val bluetoothGattCallback by lazy {
        object : BluetoothGattCallback() {
            override fun onConnectionStateChange(gatt: BluetoothGatt?, status: Int, newState: Int) {
                super.onConnectionStateChange(gatt, status, newState)
                val address = gatt!!.device.address
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> {
                        when (newState) {
                            BluetoothProfile.STATE_CONNECTED -> {
                                val code = when {
                                    Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP -> {
                                        // TODO: how to get local MTU size here?
                                        if (gatt.requestMtu(512)) NO_ERROR
                                        else REQUEST_MTU_FAILED
                                    }
                                    else -> {
                                        if (gatt.discoverServices()) {
                                            // Just use 23 as MTU before LOLLIPOP.
                                            mtus[address] = 23
                                            NO_ERROR
                                        } else DISCOVER_SERVICES_FAILED
                                    }
                                }
                                if (code != NO_ERROR) {
                                    gatts.remove(address)!!.close()
                                    val connect = connects.remove(address)!!
                                    handler.post { connect.error(code) }
                                }
                            }
                            BluetoothProfile.STATE_DISCONNECTED -> {
                                gatts.remove(address)!!.close()
                                val disconnect = disconnects.remove(address)!!
                                handler.post { disconnect.success() }
                            }
                            else -> throw NotImplementedError() // should never be called.
                        }
                    }
                    else -> {
                        gatts.remove(address)!!.close()
                        val connect = connects.remove(address)
                        val disconnect = disconnects.remove(address)
                        when {
                            connect != null -> handler.post { connect.error(status) }
                            disconnect != null -> handler.post { disconnect.error(status) }
                            else -> {
                                val connectionLost = ConnectionLost.newBuilder()
                                        .setDevice(address)
                                        .setErrorCode(status)
                                        .build()
                                val event = Message.newBuilder()
                                        .setCategory(GATT_CONNECTION_LOST)
                                        .setConnectionLost(connectionLost)
                                        .build()
                                        .toByteArray()
                                handler.post { sink?.success(event) }
                            }
                        }
                    }
                }
            }

            override fun onMtuChanged(gatt: BluetoothGatt?, mtu: Int, status: Int) {
                super.onMtuChanged(gatt, mtu, status)
                val address = gatt!!.device.address
                val code = when (status) {
                    BluetoothGatt.GATT_SUCCESS -> {
                        if (gatt.discoverServices()) {
                            mtus[address] = mtu
                            NO_ERROR
                        } else DISCOVER_SERVICES_FAILED
                    }
                    else -> status
                }
                if (code != NO_ERROR) {
                    gatts.remove(address)!!.close()
                    val connect = connects.remove(address)!!
                    handler.post { connect.error(code) }
                }
            }

            override fun onServicesDiscovered(gatt: BluetoothGatt?, status: Int) {
                super.onServicesDiscovered(gatt, status)
                val address = gatt!!.device.address
                val connect = connects.remove(address)!!
                val mtu = mtus.remove(address)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> {
                        val services = gatt.services.map { service ->
                            val serviceUUID = service.uuid.toString()
                            val characteristics = service.characteristics.map { characteristic ->
                                val characteristicUUID = characteristic.uuid.toString()
                                val properties = characteristic.properties
                                val canRead = properties and BluetoothGattCharacteristic.PROPERTY_READ != 0
                                val canWrite = properties and BluetoothGattCharacteristic.PROPERTY_WRITE != 0
                                val canWriteWithoutResponse = properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0
                                val canNotify = properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0
                                val descriptors = characteristic.descriptors.map { descriptor ->
                                    val descriptorUUID = descriptor.uuid.toString()
                                    GattDescriptor.newBuilder()
                                            .setUuid(descriptorUUID)
                                            .build()
                                }
                                GattCharacteristic.newBuilder()
                                        .setUuid(characteristicUUID)
                                        .setCanRead(canRead)
                                        .setCanWrite(canWrite)
                                        .setCanWriteWithoutResponse(canWriteWithoutResponse)
                                        .setCanNotify(canNotify)
                                        .addAllDescriptors(descriptors)
                                        .build()
                            }
                            GattService.newBuilder()
                                    .setUuid(serviceUUID)
                                    .addAllCharacteristics(characteristics).build()
                        }
                        val reply = GATT.newBuilder().setMtu(mtu).addAllServices(services).build().toByteArray()
                        handler.post { connect.success(reply) }
                    }
                    else -> {
                        gatts.remove(address)!!.close()
                        handler.post { connect.error(status) }
                    }
                }
            }

            override fun onCharacteristicRead(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic?, status: Int) {
                super.onCharacteristicRead(gatt, characteristic, status)
                val key = characteristic!!.hashCode()
                val read = characteristicReads.remove(key)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> handler.post { read.success(characteristic.value) }
                    else -> handler.post { read.error(status) }
                }
            }

            override fun onCharacteristicWrite(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic?, status: Int) {
                super.onCharacteristicWrite(gatt, characteristic, status)
                val key = characteristic!!.hashCode()
                val write = characteristicWrites.remove(key)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> handler.post { write.success() }
                    else -> handler.post { write.error(status) }
                }
            }

            override fun onCharacteristicChanged(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic?) {
                super.onCharacteristicChanged(gatt, characteristic)
                val address = gatt!!.device.address
                val serviceUUID = characteristic!!.service.uuid.toString()
                val characteristicUUID = characteristic.uuid.toString()
                val value = ByteString.copyFrom(characteristic.value)
                val characteristicValue = GattCharacteristicValue.newBuilder()
                        .setDevice(address)
                        .setService(serviceUUID)
                        .setCharacteristic(characteristicUUID)
                        .setValue(value)
                        .build()
                val event = Message.newBuilder()
                        .setCategory(GATT_CHARACTERISTIC_NOTIFY)
                        .setCharacteristicValue(characteristicValue)
                        .build()
                        .toByteArray()
                sink?.success(event)
            }

            override fun onDescriptorRead(gatt: BluetoothGatt?, descriptor: BluetoothGattDescriptor?, status: Int) {
                super.onDescriptorRead(gatt, descriptor, status)
                val key = descriptor!!.hashCode()
                val read = descriptorReads.remove(key)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> handler.post { read.success(descriptor.value) }
                    else -> handler.post { read.error(status) }
                }
            }

            override fun onDescriptorWrite(gatt: BluetoothGatt?, descriptor: BluetoothGattDescriptor?, status: Int) {
                super.onDescriptorWrite(gatt, descriptor, status)
                val key = descriptor!!.hashCode()
                val write = descriptorWrites.remove(key)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> handler.post { write.success() }
                    else -> handler.post { write.error(status) }
                }
            }
        }
    }

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        method = MethodChannel(binding.binaryMessenger, "$NAMESPACE/method")
        method.setMethodCallHandler(this)
        event = EventChannel(binding.binaryMessenger, "$NAMESPACE/event")
        event.setStreamHandler(this)
        context = binding.applicationContext
        // Register bluetooth adapter state receiver.
        val adapterStateFilter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        context.registerReceiver(bluetoothStateReceiver, adapterStateFilter)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        // Clear connections.
        for (gatt in gatts.values) gatt.close()
        // Stop scan.
        if (scanning) stopScan()
        // Unregister bluetooth adapter state receiver.
        context.unregisterReceiver(bluetoothStateReceiver)
        event.setStreamHandler(null)
        method.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.category) {
            BLUETOOTH_STATE -> result.success(bluetoothState.number)
            CENTRAL_START_DISCOVERY -> {
                when {
                    requestPermissionsHandler != null -> result.error(INVALID_REQUEST)
                    else -> {
                        val startDiscovery = Runnable {
                            val data = call.arguments<ByteArray>()
                            val arguments = StartDiscoveryArguments.parseFrom(data)
                            val code = startScan(arguments.servicesList)
                            if (code == NO_ERROR) {
                                result.success()
                            } else {
                                result.error(code, "Scan start failed with code: $code.")
                            }
                        }
                        when {
                            hasPermission -> startDiscovery.run()
                            else -> {
                                requestPermissionsHandler = { granted ->
                                    if (granted) startDiscovery.run()
                                    else result.error(
                                            REQUEST_PERMISSION_FAILED,
                                            "Request permission failed."
                                    )
                                }
                                val permissions = arrayOf(Manifest.permission.ACCESS_FINE_LOCATION)
                                ActivityCompat.requestPermissions(
                                        binding!!.activity,
                                        permissions,
                                        REQUEST_CODE
                                )
                            }
                        }
                    }
                }
            }
            CENTRAL_STOP_DISCOVERY -> {
                stopScan()
                result.success()
            }
            CENTRAL_DISCOVERED -> result.notImplemented()
            CENTRAL_SCANNING -> result.success(scanning)
            CENTRAL_CONNECT -> {
                val address = call.arguments<String>()
                val connect = connects[address]
                var gatt = gatts[address]
                if (connect != null || gatt != null) {
                    result.error(INVALID_REQUEST)
                } else {
                    val device = bluetoothAdapter.getRemoteDevice(address)
                    gatt = when {
                        // Use TRANSPORT_LE to avoid none flag device on Android 23 or later.
                        Build.VERSION.SDK_INT >= Build.VERSION_CODES.M -> device.connectGatt(context, false, bluetoothGattCallback, BluetoothDevice.TRANSPORT_LE)
                        else -> device.connectGatt(context, false, bluetoothGattCallback)
                    }
                    connects[address] = result
                    gatts[address] = gatt
                }
            }
            GATT_DISCONNECT -> {
                val address = call.arguments<String>()
                val disconnect = disconnects[address]
                val gatt = gatts[address]
                if (disconnect != null || gatt == null) {
                    result.error(INVALID_REQUEST)
                } else {
                    disconnects[address] = result
                    gatt.disconnect()
                }
            }
            GATT_CONNECTION_LOST -> result.notImplemented()
            GATT_CHARACTERISTIC_READ -> {
                val data = call.arguments<ByteArray>()
                val arguments = GattCharacteristicReadArguments.parseFrom(data)
                val gatt = gatts[arguments.device]
                if (gatt == null) result.error(INVALID_REQUEST)
                else {
                    val serviceUUID = UUID.fromString(arguments.service)
                    val service = gatt.getService(serviceUUID)
                    val characteristicUUID = UUID.fromString(arguments.characteristic)
                    val characteristic = service.getCharacteristic(characteristicUUID)
                    val key = characteristic.hashCode()
                    val characteristicRead = characteristicReads[key]
                    if (characteristicRead != null) result.error(INVALID_REQUEST)
                    else {
                        val failed = !gatt.readCharacteristic(characteristic)
                        if (failed) result.error(READ_CHARACTERISTIC_FAILED)
                        else characteristicReads[key] = result
                    }
                }
            }
            GATT_CHARACTERISTIC_WRITE -> {
                val data = call.arguments<ByteArray>()
                val arguments = GattCharacteristicWriteArguments.parseFrom(data)
                val gatt = gatts[arguments.device]
                if (gatt == null) result.error(INVALID_REQUEST)
                else {
                    val serviceUUID = UUID.fromString(arguments.service)
                    val service = gatt.getService(serviceUUID)
                    val characteristicUUID = UUID.fromString(arguments.characteristic)
                    val characteristic = service.getCharacteristic(characteristicUUID)
                    val key = characteristic.hashCode()
                    val characteristicWrite = characteristicWrites[key]
                    if (characteristicWrite != null) result.error(INVALID_REQUEST)
                    else {
                        characteristic.value = arguments.value.toByteArray()
                        characteristic.writeType =
                                if (arguments.withoutResponse) BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
                                else BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
                        val failed = !gatt.writeCharacteristic(characteristic)
                        if (failed) result.error(WRITE_CHARACTERISTIC_FAILED)
                        else characteristicWrites[key] = result
                    }
                }
            }
            GATT_CHARACTERISTIC_NOTIFY -> {
                val data = call.arguments<ByteArray>()
                val arguments = GattCharacteristicNotifyArguments.parseFrom(data)
                val gatt = gatts[arguments.device]
                if (gatt == null) result.error(INVALID_REQUEST)
                else {
                    val serviceUUID = UUID.fromString(arguments.service)
                    val service = gatt.getService(serviceUUID)
                    val characteristicUUID = UUID.fromString(arguments.characteristic)
                    val characteristic = service.getCharacteristic(characteristicUUID)
                    val descriptorUUID = UUID.fromString(CLIENT_CHARACTERISTIC_CONFIG)
                    val descriptor = characteristic.getDescriptor(descriptorUUID)
                    val key = descriptor.hashCode()
                    val descriptorWrite = descriptorWrites[key]
                    if (descriptorWrite != null) result.error(INVALID_REQUEST)
                    else {
                        var failed = !gatt.setCharacteristicNotification(characteristic, arguments.state)
                        if (failed) result.error(NOTIFY_CHARACTERISTIC_FAILED)
                        else {
                            descriptor.value =
                                    if (arguments.state) BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                                    else BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
                            failed = !gatt.writeDescriptor(descriptor)
                            if (failed) result.error(WRITE_DESCRIPTOR_FAILED)
                            else descriptorWrites[key] = result
                        }
                    }
                }
            }
            GATT_DESCRIPTOR_READ -> {
                val data = call.arguments<ByteArray>()
                val arguments = GattDescriptorReadArguments.parseFrom(data)
                val gatt = gatts[arguments.device]
                if (gatt == null) result.error(INVALID_REQUEST)
                else {
                    val serviceUUID = UUID.fromString(arguments.service)
                    val service = gatt.getService(serviceUUID)
                    val characteristicUUID = UUID.fromString(arguments.characteristic)
                    val characteristic = service.getCharacteristic(characteristicUUID)
                    val descriptorUUID = UUID.fromString(arguments.descriptor)
                    val descriptor = characteristic.getDescriptor(descriptorUUID)
                    val key = descriptor.hashCode()
                    val descriptorRead = descriptorReads[key]
                    if (descriptorRead != null) result.error(INVALID_REQUEST)
                    else {
                        val failed = !gatt.readDescriptor(descriptor)
                        if (failed) result.error(READ_DESCRIPTOR_FAILED)
                        else descriptorReads[key] = result
                    }
                }
            }
            GATT_DESCRIPTOR_WRITE -> {
                val data = call.arguments<ByteArray>()
                val arguments = GattDescriptorWriteArguments.parseFrom(data)
                val gatt = gatts[arguments.device]
                if (gatt == null) result.error(INVALID_REQUEST)
                else {
                    val serviceUUID = UUID.fromString(arguments.service)
                    val service = gatt.getService(serviceUUID)
                    val characteristicUUID = UUID.fromString(arguments.characteristic)
                    val characteristic = service.getCharacteristic(characteristicUUID)
                    val descriptorUUID = UUID.fromString(arguments.descriptor)
                    val descriptor = characteristic.getDescriptor(descriptorUUID)
                    val key = descriptor.hashCode()
                    val descriptorWrite = descriptorWrites[key]
                    if (descriptorWrite != null) result.error(INVALID_REQUEST)
                    else {
                        val failed = !gatt.writeDescriptor(descriptor)
                        if (failed) result.error(WRITE_DESCRIPTOR_FAILED)
                        else descriptorWrites[key] = result
                    }
                }
            }
            UNRECOGNIZED -> result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, sink: EventSink?) {
        Log.d(TAG, "onListen")
        this.sink = sink
    }

    override fun onCancel(arguments: Any?) {
        Log.d(TAG, "onCancel")
        sink = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.binding = binding
        this.binding!!.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivity() {
        binding!!.removeRequestPermissionsResultListener(this)
        binding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<out String>?,
            grantResults: IntArray?
    ): Boolean {
        return when {
            requestCode != REQUEST_CODE || requestPermissionsHandler == null -> false
            else -> {
                val granted =
                        grantResults != null && grantResults.all { result -> result == PackageManager.PERMISSION_GRANTED }
                requestPermissionsHandler!!.invoke(granted)
                requestPermissionsHandler = null
                true
            }
        }
    }
}

fun Result.success() {
    success(null)
}

fun Result.error(code: Int, message: String? = null, details: String? = null) {
    error("$code", message, details)
}

val Any.TAG: String
    get() = this::class.java.simpleName

val MethodCall.category: MessageCategory
    get() = valueOf(method)

val Context.missingBluetoothFeature: Boolean
    get() = !packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)

val Int.bluetoothState: BluetoothState
    get() = when (this) {
        BluetoothAdapter.STATE_OFF -> BluetoothState.POWERED_OFF
        BluetoothAdapter.STATE_TURNING_ON -> BluetoothState.POWERED_OFF
        BluetoothAdapter.STATE_ON -> BluetoothState.POWERED_ON
        BluetoothAdapter.STATE_TURNING_OFF -> BluetoothState.POWERED_ON
        else -> BluetoothState.UNKNOWN
    }

val ByteArray.advertisements: Map<Int, ByteString>
    get() {
        val advertisements = mutableMapOf<Int, ByteString>()
        var i = 0
        while (i < size) {
            val remained = this[i++].toUByte().toInt()
            if (remained == 0) {
                break
            }
            val key = this[i++].toUByte().toInt()
            val value = ByteString.copyFrom(this, i, remained - 1)
            i += value.size()
            advertisements[key] = value
        }
        return advertisements
    }