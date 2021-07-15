package dev.yanshouwang.bluetooth_low_energy

import android.Manifest
import android.bluetooth.*
import android.bluetooth.le.*
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.ParcelUuid
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.protobuf.ByteString
import dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.*
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

typealias StartScanHandler = (code: Int) -> Unit
typealias RequestPermissionsHandler = (granted: Boolean) -> Unit

/** BluetoothLowEnergyPlugin */
class BluetoothLowEnergyPlugin : FlutterPlugin, MethodCallHandler, StreamHandler, ActivityAware, RequestPermissionsResultListener {
    companion object {
        private const val CLIENT_CHARACTERISTIC_CONFIG = "00002902-0000-1000-8000-00805f9b34fb"
        private const val BLUETOOTH_ADAPTER_STATE_UNKNOWN = -1
        private const val NO_ERROR = 0
        private const val REQUEST_CODE = 443
    }

    private lateinit var method: MethodChannel
    private lateinit var event: EventChannel
    private lateinit var context: Context

    private var binding: ActivityPluginBinding? = null
    private var events: EventSink? = null

    private val bluetoothAvailable by lazy { context.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE) }
    private val bluetoothManager by lazy { context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager }
    private val bluetoothAdapter by lazy { bluetoothManager.adapter }
    private val handler by lazy { Handler(context.mainLooper) }

    private val bluetoothState: BluetoothState
        get() {
            return if (bluetoothAvailable) bluetoothAdapter.state.messageState
            else BluetoothState.UNSUPPORTED
        }

    private val bluetoothStateReceiver by lazy {
        object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val oldState = intent!!.getIntExtra(BluetoothAdapter.EXTRA_PREVIOUS_STATE, BLUETOOTH_ADAPTER_STATE_UNKNOWN).messageState
                val newState = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BLUETOOTH_ADAPTER_STATE_UNKNOWN).messageState
                if (newState == oldState) return
                if (newState != BluetoothState.POWERED_ON && scanning) scanning = false
                val event = Message.newBuilder()
                        .setCategory(BLUETOOTH_STATE)
                        .setState(newState)
                        .build()
                        .toByteArray()
                events?.success(event)
            }
        }
    }

    private val hasPermission
        get() = ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED

    private var requestPermissionsHandler: RequestPermissionsHandler? = null

    private var scanCode = NO_ERROR
    private var scanning = false

    private val scanCallback by lazy {
        object : ScanCallback() {
            override fun onScanFailed(errorCode: Int) {
                super.onScanFailed(errorCode)
                scanCode = errorCode
            }

            override fun onScanResult(callbackType: Int, result: ScanResult?) {
                super.onScanResult(callbackType, result)
                if (result == null) return
                val record = result.scanRecord
                val advertisements =
                        if (record == null) ByteString.EMPTY
                        else ByteString.copyFrom(record.bytes)
                // TODO: We can't get connectable value before Android 8.0, here we just return true
                //  remove this useless code after the minSdkVersion set to 26 or later.
                val connectable =
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) result.isConnectable
                        else true
                val builder = Discovery.newBuilder()
                        .setUuid(result.device.uuid)
                        .setRssi(result.rssi)
                        .setAdvertisements(advertisements)
                        .setConnectable(connectable)
                val discovery = builder.build()
                val event = Message.newBuilder()
                        .setCategory(CENTRAL_DISCOVERED)
                        .setDiscovery(discovery)
                        .build()
                        .toByteArray()
                events?.success(event)
            }

            override fun onBatchScanResults(results: MutableList<ScanResult>?) {
                super.onBatchScanResults(results)
                if (results == null) return
                for (result in results) {
                    val record = result.scanRecord
                    val advertisements =
                            if (record == null) ByteString.EMPTY
                            else ByteString.copyFrom(record.bytes)
                    // TODO: We can't get connectable value before Android 8.0, here we just return true
                    //  remove this useless code after the minSdkVersion set to 26 or later.
                    val connectable =
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) result.isConnectable
                            else true
                    val builder = Discovery.newBuilder()
                            .setUuid(result.device.uuid)
                            .setRssi(result.rssi)
                            .setAdvertisements(advertisements)
                            .setConnectable(connectable)
                    val discovery = builder.build()
                    val event = Message.newBuilder()
                            .setCategory(CENTRAL_DISCOVERED)
                            .setDiscovery(discovery)
                            .build()
                            .toByteArray()
                    events?.success(event)
                }
            }
        }
    }

    private val nativeGATTs by lazy { mutableMapOf<String, NativeGATT>() }

    private val connects by lazy { mutableMapOf<BluetoothGatt, Result>() }
    private val maximumWriteLengths by lazy { mutableMapOf<BluetoothGatt, Int>() }
    private val disconnects by lazy { mutableMapOf<BluetoothGatt, Result>() }
    private val characteristicReads by lazy { mutableMapOf<BluetoothGattCharacteristic, Result>() }
    private val characteristicWrites by lazy { mutableMapOf<BluetoothGattCharacteristic, Result>() }
    private val descriptorReads by lazy { mutableMapOf<BluetoothGattDescriptor, Result>() }
    private val descriptorWrites by lazy { mutableMapOf<BluetoothGattDescriptor, Result>() }

    private val bluetoothGattCallback by lazy {
        object : BluetoothGattCallback() {
            override fun onConnectionStateChange(gatt: BluetoothGatt?, status: Int, newState: Int) {
                super.onConnectionStateChange(gatt, status, newState)
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> {
                        when (newState) {
                            BluetoothProfile.STATE_DISCONNECTED -> {
                                // Maybe disconnect succeed, connect failed, or connection lost when an adaptor closed event triggered.
                                gatt!!.close()
                                val connect = connects.remove(gatt)
                                if (connect != null) handler.post { connect.error("GATT error with status: $status.", null, null) }
                                else {
                                    val nativeGATT = nativeGATTs.entries.first { entry -> entry.value.value === gatt }
                                    nativeGATTs.remove(nativeGATT.key)
                                    val disconnect = disconnects.remove(gatt)
                                    if (disconnect != null) handler.post { disconnect.success() }
                                    else {
                                        val connectionLost = GattConnectionLost.newBuilder()
                                                .setKey(nativeGATT.key)
                                                .setError("GATT error with status: $status")
                                                .build()
                                        val event = Message.newBuilder()
                                                .setCategory(GATT_CONNECTION_LOST)
                                                .setConnectionLost(connectionLost)
                                                .build()
                                                .toByteArray()
                                        handler.post { events?.success(event) }
                                    }
                                }
                            }
                            BluetoothProfile.STATE_CONNECTED -> {
                                // Must be connect succeed.
                                val requested = gatt!!.requestMtu(512)
                                if (!requested) gatt.disconnect()
                            }
                            else -> throw NotImplementedError() // should never be called.
                        }
                    }
                    else -> {
                        // Maybe connect failed, disconnect failed or connection lost.
                        gatt!!.close()
                        val connect = connects.remove(gatt)
                        if (connect != null) handler.post { connect.error("GATT error with status: $status", null, null) }
                        else {
                            val nativeGATT = nativeGATTs.entries.first { entry -> entry.value.value === gatt }
                            nativeGATTs.remove(nativeGATT.key)
                            val disconnect = disconnects.remove(gatt)
                            if (disconnect != null) handler.post { disconnect.error("GATT error with status: $status", null, null) }
                            else {
                                val connectionLost = GattConnectionLost.newBuilder()
                                        .setKey(nativeGATT.key)
                                        .setError("GATT error with status: $status")
                                        .build()
                                val event = Message.newBuilder()
                                        .setCategory(GATT_CONNECTION_LOST)
                                        .setConnectionLost(connectionLost)
                                        .build()
                                        .toByteArray()
                                handler.post { events?.success(event) }
                            }
                        }
                    }
                }
            }

            override fun onMtuChanged(gatt: BluetoothGatt?, mtu: Int, status: Int) {
                super.onMtuChanged(gatt, mtu, status)
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> {
                        val discovered = gatt!!.discoverServices()
                        if (discovered) maximumWriteLengths[gatt] = mtu - 3
                        else gatt.disconnect()
                    }
                    else -> gatt!!.disconnect()
                }
            }

            override fun onServicesDiscovered(gatt: BluetoothGatt?, status: Int) {
                super.onServicesDiscovered(gatt, status)
                val maximumWriteLength = maximumWriteLengths.remove(gatt)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> {
                        val nativeServices = mutableMapOf<String, NativeGattService>()
                        val messageServices = mutableListOf<GattService>()
                        for (service in gatt!!.services) {
                            val nativeCharacteristics = mutableMapOf<String, NativeGattCharacteristic>()
                            val messageCharacteristics = mutableListOf<GattCharacteristic>()
                            for (characteristic in service.characteristics) {
                                val nativeDescriptors = mutableMapOf<String, NativeGattDescriptor>()
                                val messageDescriptors = mutableListOf<GattDescriptor>()
                                for (descriptor in characteristic.descriptors) {
                                    // Add native descriptor.
                                    val nativeDescriptor = NativeGattDescriptor(descriptor)
                                    nativeDescriptors[nativeDescriptor.key] = nativeDescriptor
                                    // Add message descriptor.
                                    val descriptorUUID = descriptor.uuid.toString()
                                    val messageDescriptor = GattDescriptor.newBuilder()
                                            .setKey(nativeDescriptor.key)
                                            .setUuid(descriptorUUID)
                                            .build()
                                    messageDescriptors.add(messageDescriptor)
                                }
                                // Add native characteristic.
                                val nativeCharacteristic = NativeGattCharacteristic(characteristic, nativeDescriptors)
                                nativeCharacteristics[nativeCharacteristic.key] = nativeCharacteristic
                                // Add message characteristic.
                                val characteristicUUID = characteristic.uuid.toString()
                                val canRead = characteristic.properties and BluetoothGattCharacteristic.PROPERTY_READ != 0
                                val canWrite = characteristic.properties and BluetoothGattCharacteristic.PROPERTY_WRITE != 0
                                val canWriteWithoutResponse = characteristic.properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0
                                val canNotify = characteristic.properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0
                                val messageCharacteristic = GattCharacteristic.newBuilder()
                                        .setKey(nativeCharacteristic.key)
                                        .setUuid(characteristicUUID)
                                        .setCanRead(canRead)
                                        .setCanWrite(canWrite)
                                        .setCanWriteWithoutResponse(canWriteWithoutResponse)
                                        .setCanNotify(canNotify)
                                        .addAllDescriptors(messageDescriptors)
                                        .build()
                                messageCharacteristics.add(messageCharacteristic)
                            }
                            // Add native service.
                            val nativeService = NativeGattService(service, nativeCharacteristics)
                            nativeServices[nativeService.key] = nativeService
                            // Add message service.
                            val serviceUUID = service.uuid.toString()
                            val messageService = GattService.newBuilder()
                                    .setKey(nativeService.key)
                                    .setUuid(serviceUUID)
                                    .addAllCharacteristics(messageCharacteristics)
                                    .build()
                            messageServices.add(messageService)
                        }
                        // Add native gatt.
                        val nativeGATT = NativeGATT(gatt, nativeServices)
                        nativeGATTs[nativeGATT.key] = nativeGATT
                        // Add message gatt.
                        val reply = GATT.newBuilder()
                                .setKey(nativeGATT.key)
                                .setMaximumWriteLength(maximumWriteLength)
                                .addAllServices(messageServices)
                                .build()
                                .toByteArray()
                        val connect = connects.remove(gatt)!!
                        handler.post { connect.success(reply) }
                    }
                    else -> gatt!!.disconnect()
                }
            }

            override fun onCharacteristicRead(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic?, status: Int) {
                super.onCharacteristicRead(gatt, characteristic, status)
                val read = characteristicReads.remove(characteristic)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> handler.post { read.success(characteristic!!.value) }
                    else -> handler.post { read.error("GATT error with status: $status", null, null) }
                }
            }

            override fun onCharacteristicWrite(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic?, status: Int) {
                super.onCharacteristicWrite(gatt, characteristic, status)
                val write = characteristicWrites.remove(characteristic)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> handler.post { write.success() }
                    else -> handler.post { write.error("GATT error with status: $status", null, null) }
                }
            }

            override fun onCharacteristicChanged(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic?) {
                super.onCharacteristicChanged(gatt, characteristic)
                val nativeGATT = nativeGATTs.values.first { entry -> entry.value === gatt }
                val nativeService = nativeGATT.services.values.first { entry -> entry.value === characteristic!!.service }
                val nativeCharacteristic = nativeService.characteristics.values.first { entry -> entry.value === characteristic }
                val value = ByteString.copyFrom(characteristic!!.value)
                val characteristicValue = GattCharacteristicValue.newBuilder()
                        .setGattKey(nativeGATT.key)
                        .setServiceKey(nativeService.key)
                        .setKey(nativeCharacteristic.key)
                        .setValue(value)
                        .build()
                val event = Message.newBuilder()
                        .setCategory(GATT_CHARACTERISTIC_NOTIFY)
                        .setCharacteristicValue(characteristicValue)
                        .build()
                        .toByteArray()
                handler.post { events?.success(event) }
            }

            override fun onDescriptorRead(gatt: BluetoothGatt?, descriptor: BluetoothGattDescriptor?, status: Int) {
                super.onDescriptorRead(gatt, descriptor, status)
                val read = descriptorReads.remove(descriptor)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> handler.post { read.success(descriptor!!.value) }
                    else -> handler.post { read.error("GATT error with status: $status", null, null) }
                }
            }

            override fun onDescriptorWrite(gatt: BluetoothGatt?, descriptor: BluetoothGattDescriptor?, status: Int) {
                super.onDescriptorWrite(gatt, descriptor, status)
                val write = descriptorWrites.remove(descriptor)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> handler.post { write.success() }
                    else -> handler.post { write.error("GATT error with status: $status", null, null) }
                }
            }
        }
    }

    private fun startScan(services: List<String>, startScanHandler: StartScanHandler) {
        val filters = services.map { service ->
            val serviceUUID = ParcelUuid.fromString(service)
            ScanFilter.Builder()
                    .setServiceUuid(serviceUUID)
                    .build()
        }
        val settings = ScanSettings.Builder()
                .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
                .build()
        bluetoothAdapter.bluetoothLeScanner.startScan(filters, settings, scanCallback)
        // use handler.post to delay until #onScanFailed executed.
        handler.post {
            val code = scanCode
            when (code) {
                NO_ERROR -> scanning = true
                else -> scanCode = NO_ERROR
            }
            startScanHandler.invoke(code)
        }
    }

    private fun stopScan() {
        bluetoothAdapter.bluetoothLeScanner.stopScan(scanCallback)
        scanning = false
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
        for (nativeGATT in nativeGATTs.values) nativeGATT.value.disconnect()
        // Stop scan.
        if (scanning) stopScan()
        // Unregister bluetooth adapter state receiver.
        context.unregisterReceiver(bluetoothStateReceiver)
        event.setStreamHandler(null)
        method.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val data = call.arguments<ByteArray>()
        val command = Message.parseFrom(data)
        when (command.category!!) {
            BLUETOOTH_STATE -> result.success(bluetoothState.number)
            CENTRAL_START_DISCOVERY -> {
                val startDiscovery = Runnable {
                    val services = command.startDiscoveryArguments.servicesList
                    val startScanHandler: StartScanHandler = { code ->
                        when (code) {
                            NO_ERROR -> result.success()
                            else -> result.error("Discovery start failed with code: $code", null, null)
                        }
                    }
                    startScan(services, startScanHandler)
                }
                when {
                    hasPermission -> startDiscovery.run()
                    else -> {
                        requestPermissionsHandler = { granted ->
                            if (granted) startDiscovery.run()
                            else result.error("Discovery start failed because `ACCESS_FINE_LOCATION` was denied by user.", null, null)
                        }
                        val permissions = arrayOf(Manifest.permission.ACCESS_FINE_LOCATION)
                        ActivityCompat.requestPermissions(binding!!.activity, permissions, REQUEST_CODE)
                    }
                }
            }
            CENTRAL_STOP_DISCOVERY -> {
                stopScan()
                result.success()
            }
            CENTRAL_CONNECT -> {
                val device = bluetoothAdapter.getRemoteDevice(command.connectArguments.uuid.address)
                val gatt = when {
                    // Use TRANSPORT_LE to avoid none flag device on Android 23 or later.
                    Build.VERSION.SDK_INT >= Build.VERSION_CODES.M -> device.connectGatt(context, false, bluetoothGattCallback, BluetoothDevice.TRANSPORT_LE)
                    else -> device.connectGatt(context, false, bluetoothGattCallback)
                }
                connects[gatt] = result
            }
            GATT_DISCONNECT -> {
                val nativeGATT = nativeGATTs[command.disconnectArguments.key]!!
                disconnects[nativeGATT.value] = result
                nativeGATT.value.disconnect()
            }
            GATT_CHARACTERISTIC_READ -> {
                val nativeGATT = nativeGATTs[command.characteristicReadArguments.gattKey]!!
                val nativeService = nativeGATT.services[command.characteristicReadArguments.serviceKey]!!
                val nativeCharacteristic = nativeService.characteristics[command.characteristicReadArguments.key]!!
                val read = nativeGATT.value.readCharacteristic(nativeCharacteristic.value)
                if (read) characteristicReads[nativeCharacteristic.value] = result
                else result.error("Characteristic read failed.", null, null)
            }
            GATT_CHARACTERISTIC_WRITE -> {
                val nativeGATT = nativeGATTs[command.characteristicWriteArguments.gattKey]!!
                val nativeService = nativeGATT.services[command.characteristicWriteArguments.serviceKey]!!
                val nativeCharacteristic = nativeService.characteristics[command.characteristicWriteArguments.key]!!
                nativeCharacteristic.value.writeType =
                        if (command.characteristicWriteArguments.withoutResponse) BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
                        else BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
                nativeCharacteristic.value.value = command.characteristicWriteArguments.value.toByteArray()
                val written = nativeGATT.value.writeCharacteristic(nativeCharacteristic.value)
                if (written) characteristicWrites[nativeCharacteristic.value] = result
                else result.error("Characteristic write failed.", null, null)
            }
            GATT_CHARACTERISTIC_NOTIFY -> {
                val nativeGATT = nativeGATTs[command.characteristicNotifyArguments.gattKey]!!
                val nativeService = nativeGATT.services[command.characteristicNotifyArguments.serviceKey]!!
                val nativeCharacteristic = nativeService.characteristics[command.characteristicNotifyArguments.key]!!
                val descriptorUUID = UUID.fromString(CLIENT_CHARACTERISTIC_CONFIG)
                val descriptor = nativeCharacteristic.value.getDescriptor(descriptorUUID)
                val notified = nativeGATT.value.setCharacteristicNotification(nativeCharacteristic.value, command.characteristicNotifyArguments.state)
                if (notified) {
                    descriptor.value =
                            if (command.characteristicNotifyArguments.state) BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                            else BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
                    val written = nativeGATT.value.writeDescriptor(descriptor)
                    if (written) descriptorWrites[descriptor] = result
                    else result.error("Client characteristic config descriptor write failed.", null, null)
                } else result.error("Characteristic Notify failed.", null, null)
            }
            GATT_DESCRIPTOR_READ -> {
                val nativeGATT = nativeGATTs[command.descriptorReadArguments.gattKey]!!
                val nativeService = nativeGATT.services[command.descriptorReadArguments.serviceKey]!!
                val nativeCharacteristic = nativeService.characteristics[command.descriptorReadArguments.characteristicKey]!!
                val nativeDescriptor = nativeCharacteristic.descriptors[command.descriptorReadArguments.key]!!
                val read = nativeGATT.value.readDescriptor(nativeDescriptor.value)
                if (read) descriptorReads[nativeDescriptor.value] = result
                else result.error("Descriptor read failed.", null, null)
            }
            GATT_DESCRIPTOR_WRITE -> {
                val nativeGATT = nativeGATTs[command.descriptorWriteArguments.gattKey]!!
                val nativeService = nativeGATT.services[command.descriptorWriteArguments.serviceKey]!!
                val nativeCharacteristic = nativeService.characteristics[command.descriptorWriteArguments.characteristicKey]!!
                val nativeDescriptor = nativeCharacteristic.descriptors[command.descriptorWriteArguments.key]!!
                nativeDescriptor.value.value = command.descriptorWriteArguments.value.toByteArray()
                val written = nativeGATT.value.writeDescriptor(nativeDescriptor.value)
                if (written) descriptorWrites[nativeDescriptor.value] = result
                else result.error("Descriptor write failed.", null, null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, events: EventSink?) {
        Log.d(TAG, "onListen")
        this.events = events
    }

    override fun onCancel(arguments: Any?) {
        Log.d(TAG, "onCancel")
        // This must be a hot reload for now, clear all status here.
        // Clear connections.
        for (nativeGATT in nativeGATTs.values) nativeGATT.value.disconnect()
        // Stop scan.
        if (scanning) stopScan()
        events = null
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

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?): Boolean {
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

val Any.TAG: String
    get() = this::class.java.simpleName

fun Result.success() {
    success(null)
}

val Int.messageState: BluetoothState
    get() = when (this) {
        BluetoothAdapter.STATE_OFF -> BluetoothState.POWERED_OFF
        BluetoothAdapter.STATE_TURNING_ON -> BluetoothState.POWERED_OFF
        BluetoothAdapter.STATE_ON -> BluetoothState.POWERED_ON
        BluetoothAdapter.STATE_TURNING_OFF -> BluetoothState.POWERED_ON
        else -> BluetoothState.UNRECOGNIZED
    }

val BluetoothDevice.uuid: String
    get() {
        val node = address.filter { char -> char != ':' }.lowercase()
        // We don't known the timestamp of the bluetooth device, use nil UUID as prefix.
        return "00000000-0000-0000-0000-$node"
    }

val String.address: String
    get() = takeLast(12).chunked(2).joinToString(":").uppercase()