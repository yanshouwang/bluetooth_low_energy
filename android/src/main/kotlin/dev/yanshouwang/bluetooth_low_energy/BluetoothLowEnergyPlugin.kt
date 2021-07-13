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
            return if (bluetoothAvailable) bluetoothAdapter.state.bluetoothState
            else BluetoothState.UNSUPPORTED
        }

    private val bluetoothStateReceiver by lazy {
        object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val oldState = intent!!.getIntExtra(BluetoothAdapter.EXTRA_PREVIOUS_STATE, BLUETOOTH_ADAPTER_STATE_UNKNOWN).bluetoothState
                val newState = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BLUETOOTH_ADAPTER_STATE_UNKNOWN).bluetoothState
                if (newState == oldState) return
                if (newState != BluetoothState.POWERED_ON && scanning) scanning = false
                val message = Message.newBuilder()
                        .setCategory(BLUETOOTH_STATE)
                        .setState(newState)
                        .build()
                        .toByteArray()
                events?.success(message)
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
                val uuid = result.device.uuid
                val rssi = result.rssi
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
                        .setUuid(uuid)
                        .setRssi(rssi)
                        .setAdvertisements(advertisements)
                        .setConnectable(connectable)
                val discovery = builder.build()
                val message = Message.newBuilder()
                        .setCategory(CENTRAL_DISCOVERED)
                        .setDiscovery(discovery)
                        .build()
                        .toByteArray()
                events?.success(message)
            }

            override fun onBatchScanResults(results: MutableList<ScanResult>?) {
                super.onBatchScanResults(results)
                if (results == null) return
                for (result in results) {
                    val uuid = result.device.uuid
                    val rssi = result.rssi
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
                            .setUuid(uuid)
                            .setRssi(rssi)
                            .setAdvertisements(advertisements)
                            .setConnectable(connectable)
                    val discovery = builder.build()
                    val message = Message.newBuilder()
                            .setCategory(CENTRAL_DISCOVERED)
                            .setDiscovery(discovery)
                            .build()
                            .toByteArray()
                    events?.success(message)
                }
            }
        }
    }

    private val connects by lazy { mutableMapOf<String, Result>() }
    private val bluetoothGATTs by lazy { mutableMapOf<Int, BluetoothGatt>() }
    private val maximumWriteLengths by lazy { mutableMapOf<Int, Int>() }
    private val disconnects by lazy { mutableMapOf<Int, Result>() }
    private val characteristicReads by lazy { mutableMapOf<Int, Result>() }
    private val characteristicWrites by lazy { mutableMapOf<Int, Result>() }
    private val descriptorReads by lazy { mutableMapOf<Int, Result>() }
    private val descriptorWrites by lazy { mutableMapOf<Int, Result>() }
    private val bluetoothGattCallback by lazy {
        object : BluetoothGattCallback() {
            override fun onConnectionStateChange(gatt: BluetoothGatt?, status: Int, newState: Int) {
                super.onConnectionStateChange(gatt, status, newState)
                val uuid = gatt!!.device.uuid
                val id = gatt.hashCode()
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> {
                        when (newState) {
                            BluetoothProfile.STATE_DISCONNECTED -> {
                                // Maybe disconnect succeed, connect failed, or connection lost when an adaptor closed event triggered.
                                bluetoothGATTs.remove(id)!!.close()
                                val disconnect = disconnects.remove(id)
                                if (disconnect != null) handler.post { disconnect.success() }
                                else {
                                    val connect = connects.remove(uuid)
                                    if (connect != null) handler.post { connect.error("GATT error with status: $status.", null, null) }
                                    else {
                                        val connectionLost = GattConnectionLost.newBuilder()
                                                .setId(id)
                                                .setError("GATT error with status: $status")
                                                .build()
                                        val message = Message.newBuilder()
                                                .setCategory(GATT_CONNECTION_LOST)
                                                .setConnectionLost(connectionLost)
                                                .build()
                                                .toByteArray()
                                        handler.post { events?.success(message) }
                                    }
                                }
                            }
                            BluetoothProfile.STATE_CONNECTED -> {
                                // Must be connect succeed.
                                val requested = gatt.requestMtu(512)
                                if (!requested) gatt.disconnect()
                            }
                            else -> throw NotImplementedError() // should never be called.
                        }
                    }
                    else -> {
                        // Maybe connect failed, disconnect failed or connection lost.
                        bluetoothGATTs.remove(id)!!.close()
                        val connect = connects.remove(uuid)
                        if (connect != null) handler.post { connect.error("GATT error with status: $status", null, null) }
                        else {
                            val disconnect = disconnects.remove(id)
                            if (disconnect != null) handler.post { disconnect.error("GATT error with status: $status", null, null) }
                            else {
                                val connectionLost = GattConnectionLost.newBuilder()
                                        .setId(id)
                                        .setError("GATT error with status: $status")
                                        .build()
                                val message = Message.newBuilder()
                                        .setCategory(GATT_CONNECTION_LOST)
                                        .setConnectionLost(connectionLost)
                                        .build()
                                        .toByteArray()
                                handler.post { events?.success(message) }
                            }
                        }
                    }
                }
            }

            override fun onMtuChanged(gatt: BluetoothGatt?, mtu: Int, status: Int) {
                super.onMtuChanged(gatt, mtu, status)
                val id = gatt!!.hashCode()
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> {
                        val discovered = gatt.discoverServices()
                        if (discovered) maximumWriteLengths[id] = mtu - 3
                        else gatt.disconnect()
                    }
                    else -> gatt.disconnect()
                }
            }

            override fun onServicesDiscovered(gatt: BluetoothGatt?, status: Int) {
                super.onServicesDiscovered(gatt, status)
                val uuid = gatt!!.device.uuid
                val id = gatt.hashCode()
                val maximumWriteLength = maximumWriteLengths.remove(id)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> {
                        val connect = connects.remove(uuid)!!
                        val services = gatt.services.map { service ->
                            val serviceId = service.hashCode()
                            val serviceUUID = service.uuid.toString()
                            val characteristics = service.characteristics.map { characteristic ->
                                val characteristicId = characteristic.hashCode()
                                val characteristicUUID = characteristic.uuid.toString()
                                val properties = characteristic.properties
                                val canRead = properties and BluetoothGattCharacteristic.PROPERTY_READ != 0
                                val canWrite = properties and BluetoothGattCharacteristic.PROPERTY_WRITE != 0
                                val canWriteWithoutResponse = properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0
                                val canNotify = properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0
                                val descriptors = characteristic.descriptors.map { descriptor ->
                                    val descriptorId = descriptor.hashCode()
                                    val descriptorUUID = descriptor.uuid.toString()
                                    GattDescriptor.newBuilder()
                                            .setId(descriptorId)
                                            .setUuid(descriptorUUID)
                                            .build()
                                }
                                GattCharacteristic.newBuilder()
                                        .setId(characteristicId)
                                        .setUuid(characteristicUUID)
                                        .setCanRead(canRead)
                                        .setCanWrite(canWrite)
                                        .setCanWriteWithoutResponse(canWriteWithoutResponse)
                                        .setCanNotify(canNotify)
                                        .addAllDescriptors(descriptors)
                                        .build()
                            }
                            GattService.newBuilder()
                                    .setId(serviceId)
                                    .setUuid(serviceUUID)
                                    .addAllCharacteristics(characteristics).build()
                        }
                        val reply = GATT.newBuilder()
                                .setId(id)
                                .setMaximumWriteLength(maximumWriteLength)
                                .addAllServices(services)
                                .build()
                                .toByteArray()
                        handler.post { connect.success(reply) }
                    }
                    else -> gatt.disconnect()
                }
            }

            override fun onCharacteristicRead(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic?, status: Int) {
                super.onCharacteristicRead(gatt, characteristic, status)
                val key = characteristic!!.hashCode()
                val read = characteristicReads.remove(key)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> handler.post { read.success(characteristic.value) }
                    else -> handler.post { read.error("GATT error with status: $status", null, null) }
                }
            }

            override fun onCharacteristicWrite(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic?, status: Int) {
                super.onCharacteristicWrite(gatt, characteristic, status)
                val key = characteristic!!.hashCode()
                val write = characteristicWrites.remove(key)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> handler.post { write.success() }
                    else -> handler.post { write.error("GATT error with status: $status", null, null) }
                }
            }

            override fun onCharacteristicChanged(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic?) {
                super.onCharacteristicChanged(gatt, characteristic)
                val id = characteristic!!.hashCode()
                val value = ByteString.copyFrom(characteristic.value)
                val characteristicValue = GattCharacteristicValue.newBuilder()
                        .setId(id)
                        .setValue(value)
                        .build()
                val message = Message.newBuilder()
                        .setCategory(GATT_CHARACTERISTIC_NOTIFY)
                        .setCharacteristicValue(characteristicValue)
                        .build()
                        .toByteArray()
                handler.post { events?.success(message) }
            }

            override fun onDescriptorRead(gatt: BluetoothGatt?, descriptor: BluetoothGattDescriptor?, status: Int) {
                super.onDescriptorRead(gatt, descriptor, status)
                val key = descriptor!!.hashCode()
                val read = descriptorReads.remove(key)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> handler.post { read.success(descriptor.value) }
                    else -> handler.post { read.error("GATT error with status: $status", null, null) }
                }
            }

            override fun onDescriptorWrite(gatt: BluetoothGatt?, descriptor: BluetoothGattDescriptor?, status: Int) {
                super.onDescriptorWrite(gatt, descriptor, status)
                val key = descriptor!!.hashCode()
                val write = descriptorWrites.remove(key)!!
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

    private fun findGattAndCharacteristic(id: Int): GattAndCharacteristic? {
        for (gatt in bluetoothGATTs.values)
            for (service in gatt.services)
                for (characteristic in service.characteristics) {
                    val characteristicId = characteristic.hashCode()
                    if (characteristicId == id)
                        return GattAndCharacteristic(gatt, characteristic)
                }
        return null
    }

    private fun findGattAndDescriptor(id: Int): GattAndDescriptor? {
        for (gatt in bluetoothGATTs.values)
            for (service in gatt.services)
                for (characteristic in service.characteristics)
                    for (descriptor in characteristic.descriptors) {
                        val descriptorId = descriptor.hashCode()
                        if (descriptorId == id)
                            return GattAndDescriptor(gatt, descriptor)
                    }
        return null
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
        for (gatt in bluetoothGATTs.values) gatt.close()
        bluetoothGATTs.clear()
        // Stop scan.
        if (scanning) stopScan()
        // Unregister bluetooth adapter state receiver.
        context.unregisterReceiver(bluetoothStateReceiver)
        event.setStreamHandler(null)
        method.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val data = call.arguments<ByteArray>()
        val message = Message.parseFrom(data)
        when (message.category!!) {
            BLUETOOTH_STATE -> result.success(bluetoothState.number)
            CENTRAL_START_DISCOVERY -> {
                when {
                    requestPermissionsHandler != null -> result.error("Already in discovery starting state.", null, null)
                    else -> {
                        val startDiscovery = Runnable {
                            val arguments = message.startDiscoveryArguments
                            val services = arguments.servicesList
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
                }
            }
            CENTRAL_STOP_DISCOVERY -> {
                stopScan()
                result.success()
            }
            CENTRAL_DISCOVERED -> result.notImplemented()
            CENTRAL_CONNECT -> {
                val arguments = message.connectArguments
                val uuid = arguments.uuid
                val connect = connects[uuid]
                if (connect != null) {
                    result.error("Already in connecting sate", null, null)
                } else {
                    val device = bluetoothAdapter.getRemoteDevice(uuid.address)
                    val gatt = when {
                        // Use TRANSPORT_LE to avoid none flag device on Android 23 or later.
                        Build.VERSION.SDK_INT >= Build.VERSION_CODES.M -> device.connectGatt(context, false, bluetoothGattCallback, BluetoothDevice.TRANSPORT_LE)
                        else -> device.connectGatt(context, false, bluetoothGattCallback)
                    }
                    connects[uuid] = result
                    val id = gatt.hashCode()
                    bluetoothGATTs[id] = gatt
                }
            }
            GATT_DISCONNECT -> {
                val arguments = message.disconnectArguments
                val id = arguments.id
                val disconnect = disconnects[id]
                val gatt = bluetoothGATTs[id]!!
                if (disconnect != null) {
                    result.error("Already in disconnecting state.", null, null)
                } else {
                    disconnects[id] = result
                    gatt.disconnect()
                }
            }
            GATT_CONNECTION_LOST -> result.notImplemented()
            GATT_CHARACTERISTIC_READ -> {
                val arguments = message.characteristicReadArguments
                val id = arguments.id
                val characteristicRead = characteristicReads[id]
                if (characteristicRead != null) {
                    result.error("Already in reading state.", null, null)
                } else {
                    val found = findGattAndCharacteristic(id)
                    if (found == null) {
                        result.error("Characteristic not found.", null, null)
                    } else {
                        val gatt = found.gatt
                        val characteristic = found.characteristic
                        val read = gatt.readCharacteristic(characteristic)
                        if (read) characteristicReads[id] = result
                        else result.error("Characteristic read failed.", null, null)
                    }
                }
            }
            GATT_CHARACTERISTIC_WRITE -> {
                val arguments = message.characteristicWriteArguments
                val id = arguments.id
                val characteristicWrite = characteristicWrites[id]
                if (characteristicWrite != null) {
                    result.error("Already in writing state.", null, null)
                } else {
                    val found = findGattAndCharacteristic(id)
                    if (found == null) {
                        result.error("Characteristic not found.", null, null)
                    } else {
                        val gatt = found.gatt
                        val characteristic = found.characteristic
                        characteristic.writeType =
                                if (arguments.withoutResponse) BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
                                else BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
                        characteristic.value = arguments.value.toByteArray()
                        val written = gatt.writeCharacteristic(characteristic)
                        if (written) characteristicWrites[id] = result
                        else result.error("Characteristic write failed.", null, null)
                    }
                }
            }
            GATT_CHARACTERISTIC_NOTIFY -> {
                val arguments = message.characteristicNotifyArguments
                val id = arguments.id
                val found = findGattAndCharacteristic(id)
                if (found == null) {
                    result.error("Characteristic not found.", null, null)
                } else {
                    val gatt = found.gatt
                    val characteristic = found.characteristic
                    val descriptorUUID = UUID.fromString(CLIENT_CHARACTERISTIC_CONFIG)
                    val descriptor = characteristic.getDescriptor(descriptorUUID)
                    val descriptorId = descriptor.hashCode()
                    val descriptorWrite = descriptorWrites[descriptorId]
                    if (descriptorWrite != null) {
                        result.error("Already in notifying state.", null, null)
                    } else {
                        val notified = gatt.setCharacteristicNotification(characteristic, arguments.state)
                        if (notified) {
                            descriptor.value =
                                    if (arguments.state) BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                                    else BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
                            val written = gatt.writeDescriptor(descriptor)
                            if (written) descriptorWrites[descriptorId] = result
                            else result.error("Client characteristic config descriptor write failed.", null, null)
                        } else {
                            result.error("Characteristic Notify failed.", null, null)
                        }
                    }
                }
            }
            GATT_DESCRIPTOR_READ -> {
                val arguments = message.descriptorReadArguments
                val id = arguments.id
                val descriptorRead = descriptorReads[id]
                if (descriptorRead != null) {
                    result.error("Already in reading state.", null, null)
                } else {
                    val found = findGattAndDescriptor(id)
                    if (found == null) {
                        result.error("Descriptor not found.", null, null)
                    } else {
                        val gatt = found.gatt
                        val descriptor = found.descriptor
                        val read = gatt.readDescriptor(descriptor)
                        if (read) descriptorReads[id] = result
                        else result.error("Descriptor read failed.", null, null)
                    }
                }
            }
            GATT_DESCRIPTOR_WRITE -> {
                val arguments = message.descriptorWriteArguments
                val id = arguments.id
                val descriptorWrite = descriptorWrites[id]
                if (descriptorWrite != null) {
                    result.error("Already in writing state.", null, null)
                } else {
                    val found = findGattAndDescriptor(id)
                    if (found == null) {
                        result.error("Descriptor not found.", null, null)
                    } else {
                        val gatt = found.gatt
                        val descriptor = found.descriptor
                        descriptor.value = arguments.value.toByteArray()
                        val written = !gatt.writeDescriptor(descriptor)
                        if (written) descriptorWrites[id] = result
                        else result.error("Descriptor write failed.", null, null)
                    }
                }
            }
            UNRECOGNIZED -> result.notImplemented()
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
        for (gatt in bluetoothGATTs.values) gatt.close()
        bluetoothGATTs.clear()
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

class GattAndCharacteristic(val gatt: BluetoothGatt, val characteristic: BluetoothGattCharacteristic)
class GattAndDescriptor(val gatt: BluetoothGatt, val descriptor: BluetoothGattDescriptor)

fun Result.success() {
    success(null)
}

val Any.TAG: String
    get() = this::class.java.simpleName

val Int.bluetoothState: BluetoothState
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
