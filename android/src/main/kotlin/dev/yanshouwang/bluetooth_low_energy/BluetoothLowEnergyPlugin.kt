package dev.yanshouwang.bluetooth_low_energy

import android.Manifest
import android.app.Activity
import android.bluetooth.*
import android.bluetooth.le.*
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Build
import android.os.ParcelUuid
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.protobuf.ByteString
import com.google.protobuf.kotlin.toByteString
import dev.yanshouwang.bluetooth_low_energy.messages.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.util.*

/** BluetoothLowEnergyPlugin */
class BluetoothLowEnergyPlugin : FlutterPlugin, ActivityAware {
    companion object {
        private const val NAMESPACE = "yanshouwang.dev/bluetooth_low_energy"
        private const val CLIENT_CHARACTERISTIC_CONFIG = "00002902-0000-1000-8000-00805f9b34fb"
        private const val BLUETOOTH_ADAPTER_STATE_UNKNOWN = -1
        private const val NO_ERROR = 0
        private const val REQUEST_CODE = 443
        private const val MAX_MTU = 517
    }

    private lateinit var binding: ActivityPluginBinding

    private var eventSink: EventChannel.EventSink? = null

    private val activity get() = binding.activity

    private val methodCallHandler by lazy {
        MethodChannel.MethodCallHandler { call, result ->
            val command = call.command
            when (command.category!!) {
                Messages.CommandCategory.COMMAND_CATEGORY_BLUETOOTH_AUTHORIZE -> {
                    val oldState = bluetoothState
                    requestPermissionResultListeners.add {
                        val newState = bluetoothState
                        if (newState != oldState) {
                            val event = event {
                                this.category = Messages.EventCategory.EVENT_CATEGORY_BLUETOOTH_STATE_CHANGED
                                this.bluetoothStateChangedArguments = bluetoothStateChangedEventArguments {
                                    this.state = newState
                                }
                            }.toByteArray()
                            eventSink?.success(event)
                        }
                        result.success()
                    }
                    ActivityCompat.requestPermissions(activity, runtimePermissions, REQUEST_CODE)
                }
                Messages.CommandCategory.COMMAND_CATEGORY_BLUETOOTH_GET_STATE -> {
                    val reply = reply {
                        this.bluetoothGetStateArguments = bluetoothGetStateReplyArguments {
                            this.state = bluetoothState
                        }
                    }.toByteArray()
                    result.success(reply)
                }
                Messages.CommandCategory.COMMAND_CATEGORY_BLUETOOTH_LISTEN_STATE_CHANGED -> {
                    val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
                    activity.registerReceiver(bluetoothStateChangedReceiver, filter)
                    result.success()
                }
                Messages.CommandCategory.COMMAND_CATEGORY_BLUETOOTH_CANCEL_STATE_CHANGED -> {
                    activity.unregisterReceiver(bluetoothStateChangedReceiver)
                    result.success()
                }
                Messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_START_DISCOVERY -> {
                    val arguments = command.centralStartDiscoveryArguments
                    val uuids = arguments.uuidsList
                    val filters = uuids.map { uuid ->
                        val serviceUUID = ParcelUuid.fromString(uuid)
                        ScanFilter.Builder().setServiceUuid(serviceUUID).build()
                    }
                    val settings = ScanSettings.Builder().setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY).build()
                    bluetoothAdapter.bluetoothLeScanner.startScan(
                        filters, settings, scanCallback
                    )
                    // use invokeOnMainThread to delay until #onScanFailed executed.
                    activity.invokeOnMainThread {
                        when (val code = scanCode) {
                            NO_ERROR -> result.success()
                            else -> {
                                result.error(
                                    TAG, "Start discovery failed with code: $code"
                                )
                                scanCode = NO_ERROR
                            }
                        }
                    }
                }
                Messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_STOP_DISCOVERY -> {
                    bluetoothAdapter.bluetoothLeScanner.stopScan(scanCallback)
                    result.success()
                }
                Messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_CONNECT -> {
                    val arguments = command.centralConnectArguments
                    val uuid = arguments.uuid
                    val address = toAddress(uuid)
                    val device = bluetoothAdapter.getRemoteDevice(address)
                    val autoConnect = false
                    val gatt = when {
                        // Use TRANSPORT_LE to avoid none flag device on Android 23 or later.
                        Build.VERSION.SDK_INT >= Build.VERSION_CODES.M -> device.connectGatt(
                            activity, autoConnect, bluetoothGattCallback, BluetoothDevice.TRANSPORT_LE
                        )
                        else -> device.connectGatt(activity, autoConnect, bluetoothGattCallback)
                    }
                    connects[gatt] = result
                }
                Messages.CommandCategory.COMMAND_CATEGORY_GATT_DISCONNECT -> {
                    val arguments = command.gattDisconnectArguments
                    val id = arguments.id
                    val gatt = bluetoothGATTs.first { it.id == id }
                    disconnects[gatt] = result
                    gatt.disconnect()
                }
                Messages.CommandCategory.COMMAND_CATEGORY_CHARACTERISTIC_READ -> {
                    val arguments = command.characteristicReadArguments
                    val gattId = arguments.gattId
                    val serviceId = arguments.serviceId
                    val id = arguments.id
                    val gatt = bluetoothGATTs.first { it.id == gattId }
                    val service = gatt.services.first { it.id == serviceId }
                    val characteristic = service.characteristics.first { it.id == id }
                    val readSuccessfully = gatt.readCharacteristic(characteristic)
                    if (readSuccessfully) characteristicReads[characteristic] = result
                    else result.error(TAG, "Read characteristic failed.")
                }
                Messages.CommandCategory.COMMAND_CATEGORY_CHARACTERISTIC_WRITE -> {
                    val arguments = command.characteristicWriteArguments
                    val gattId = arguments.gattId
                    val serviceId = arguments.serviceId
                    val id = arguments.id
                    val withoutResponse = arguments.withoutResponse
                    val value = arguments.value.toByteArray()
                    val gatt = bluetoothGATTs.first { it.id == gattId }
                    val service = gatt.services.first { it.id == serviceId }
                    val characteristic = service.characteristics.first { it.id == id }
                    characteristic.writeType = if (withoutResponse) BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
                    else BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
                    characteristic.value = value
                    val writeSuccessfully = gatt.writeCharacteristic(characteristic)
                    if (writeSuccessfully) characteristicWrites[characteristic] = result
                    else result.error(TAG, "Write characteristic failed.")
                }
                Messages.CommandCategory.COMMAND_CATEGORY_CHARACTERISTIC_NOTIFY -> {
                    val arguments = command.characteristicNotifyArguments
                    val gattId = arguments.gattId
                    val serviceId = arguments.serviceId
                    val id = arguments.id
                    val gatt = bluetoothGATTs.first { it.id == gattId }
                    val service = gatt.services.first { it.id == serviceId }
                    val characteristic = service.characteristics.first { it.id == id }
                    val descriptorUUID = UUID.fromString(CLIENT_CHARACTERISTIC_CONFIG)
                    val descriptor = characteristic.getDescriptor(descriptorUUID)
                    val notifySuccessfully = gatt.setCharacteristicNotification(characteristic, true)
                    if (notifySuccessfully) {
                        descriptor.value = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                        val writeSuccessfully = gatt.writeDescriptor(descriptor)
                        if (writeSuccessfully) descriptorWrites[descriptor] = result
                        else result.error(
                            TAG, "Write client characteristic config descriptor failed."
                        )
                    } else {
                        result.error(TAG, "Notify characteristic failed.")
                    }
                }
                Messages.CommandCategory.COMMAND_CATEGORY_CHARACTERISTIC_CANCEL_NOTIFY -> {
                    val arguments = command.characteristicCancelNotifyArguments
                    val gattId = arguments.gattId
                    val serviceId = arguments.serviceId
                    val id = arguments.id
                    val gatt = bluetoothGATTs.first { it.id == gattId }
                    val service = gatt.services.first { it.id == serviceId }
                    val characteristic = service.characteristics.first { it.id == id }
                    val descriptorUUID = UUID.fromString(CLIENT_CHARACTERISTIC_CONFIG)
                    val descriptor = characteristic.getDescriptor(descriptorUUID)
                    val notifySuccessfully = gatt.setCharacteristicNotification(characteristic, false)
                    if (notifySuccessfully) {
                        descriptor.value = BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
                        val writeSuccessfully = gatt.writeDescriptor(descriptor)
                        if (writeSuccessfully) descriptorWrites[descriptor] = result
                        else result.error(
                            TAG, "Write client characteristic config descriptor failed."
                        )
                    } else {
                        result.error(TAG, "Notify characteristic failed.")
                    }
                }
                Messages.CommandCategory.COMMAND_CATEGORY_DESCRIPTOR_READ -> {
                    val arguments = command.descriptorReadArguments
                    val gattId = arguments.gattId
                    val serviceId = arguments.serviceId
                    val characteristicId = arguments.characteristicId
                    val id = arguments.id
                    val gatt = bluetoothGATTs.first { it.id == gattId }
                    val service = gatt.services.first { it.id == serviceId }
                    val characteristic = service.characteristics.first { it.id == characteristicId }
                    val descriptor = characteristic.descriptors.first { it.id == id }
                    val readSuccessfully = gatt.readDescriptor(descriptor)
                    if (readSuccessfully) descriptorReads[descriptor] = result
                    else result.error(TAG, "Read descriptor failed.")
                }
                Messages.CommandCategory.COMMAND_CATEGORY_DESCRIPTOR_WRITE -> {
                    val arguments = command.descriptorWriteArguments
                    val gattId = arguments.gattId
                    val serviceId = arguments.serviceId
                    val characteristicId = arguments.characteristicId
                    val id = arguments.id
                    val value = arguments.value.toByteArray()
                    val gatt = bluetoothGATTs.first { it.id == gattId }
                    val service = gatt.services.first { it.id == serviceId }
                    val characteristic = service.characteristics.first { it.id == characteristicId }
                    val descriptor = characteristic.descriptors.first { it.id == id }
                    descriptor.value = value
                    val writeSuccessfully = gatt.writeDescriptor(descriptor)
                    if (writeSuccessfully) descriptorWrites[descriptor] = result
                    else result.error(TAG, "Write descriptor failed.")
                }
                Messages.CommandCategory.UNRECOGNIZED -> result.notImplemented()
            }
        }
    }
    private val streamHandler by lazy {
        object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        }
    }

    private val requestPermissionResultListeners by lazy { mutableListOf<(granted: Boolean) -> Unit>() }
    private val requestPermissionsResultListener by lazy {
        PluginRegistry.RequestPermissionsResultListener { requestCode, _, grantResults ->
            return@RequestPermissionsResultListener if (requestCode != REQUEST_CODE) false
            else {
                val granted = grantResults.all { result ->
                    result == PackageManager.PERMISSION_GRANTED
                }
                for (listener in requestPermissionResultListeners) {
                    listener(granted)
                }
                requestPermissionResultListeners.clear()
                true
            }
        }
    }

    private val bluetoothAvailable by lazy {
        activity.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
    }
    private val bluetoothAdapter by lazy {
        (activity.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager).adapter
    }
    private val runtimePermissions by lazy {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            arrayOf(Manifest.permission.BLUETOOTH_SCAN, Manifest.permission.BLUETOOTH_CONNECT)
        } else {
            arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.ACCESS_FINE_LOCATION)
        }
    }
    private val authorized
        get() = runtimePermissions.all { permission ->
            ContextCompat.checkSelfPermission(
                activity, permission
            ) == PackageManager.PERMISSION_GRANTED
        }
    private val bluetoothState: Messages.BluetoothState
        get() {
            return if (bluetoothAvailable) {
                if (authorized) {
                    toProtoBluetoothState(bluetoothAdapter.state)
                } else {
                    Messages.BluetoothState.BLUETOOTH_STATE_UNAUTHORIZED
                }
            } else {
                Messages.BluetoothState.BLUETOOTH_STATE_UNSUPPORTED
            }
        }

    private val bluetoothStateChangedReceiver by lazy {
        object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                // 在 UNSUPPORTED 和 UNAUTHORIZED 状态时不处理
                val bluetoothState = this@BluetoothLowEnergyPlugin.bluetoothState
                if (bluetoothState == Messages.BluetoothState.BLUETOOTH_STATE_UNSUPPORTED || bluetoothState == Messages.BluetoothState.BLUETOOTH_STATE_UNAUTHORIZED) {
                    return
                }
                val oldState = intent!!.getIntExtra(
                    BluetoothAdapter.EXTRA_PREVIOUS_STATE, BLUETOOTH_ADAPTER_STATE_UNKNOWN
                )
                val newState = intent.getIntExtra(
                    BluetoothAdapter.EXTRA_STATE, BLUETOOTH_ADAPTER_STATE_UNKNOWN
                )
                if (newState == oldState) return
                val state = toProtoBluetoothState(newState)
                val event = event {
                    this.category = Messages.EventCategory.EVENT_CATEGORY_BLUETOOTH_STATE_CHANGED
                    this.bluetoothStateChangedArguments = bluetoothStateChangedEventArguments {
                        this.state = state
                    }
                }.toByteArray()
                eventSink?.success(event)
            }
        }
    }

    private var scanCode = NO_ERROR

    private val bluetoothGATTs by lazy { mutableListOf<BluetoothGatt>() }

    private val connects by lazy { mutableMapOf<BluetoothGatt, MethodChannel.Result>() }
    private val maximumWriteLengths by lazy { mutableMapOf<BluetoothGatt, Int>() }
    private val disconnects by lazy { mutableMapOf<BluetoothGatt, MethodChannel.Result>() }
    private val characteristicReads by lazy { mutableMapOf<BluetoothGattCharacteristic, MethodChannel.Result>() }
    private val characteristicWrites by lazy { mutableMapOf<BluetoothGattCharacteristic, MethodChannel.Result>() }
    private val descriptorReads by lazy { mutableMapOf<BluetoothGattDescriptor, MethodChannel.Result>() }
    private val descriptorWrites by lazy { mutableMapOf<BluetoothGattDescriptor, MethodChannel.Result>() }

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
                val advertisements = if (record == null) ByteString.EMPTY
                else ByteString.copyFrom(record.bytes)
                // TODO: We can't get connectable value before Android 8.0, here we just return true
                //  remove this useless code after the minSdkVersion set to 26 or later.
                val connectable = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) result.isConnectable
                else true
                val event = event {
                    this.category = Messages.EventCategory.EVENT_CATEGORY_CENTRAL_DISCOVERED
                    this.centralDiscoveredArguments = centralDiscoveredEventArguments {
                        this.discovery = discovery {
                            this.uuid = result.device.uuid
                            this.rssi = result.rssi
                            this.advertisements = advertisements
                            this.connectable = connectable
                        }
                    }
                }.toByteArray()
                eventSink?.success(event)
            }

            override fun onBatchScanResults(results: MutableList<ScanResult>?) {
                super.onBatchScanResults(results)
                if (results == null) return
                for (result in results) {
                    onScanResult(ScanSettings.CALLBACK_TYPE_ALL_MATCHES, result)
                }
            }
        }
    }
    private val bluetoothGattCallback by lazy {
        object : BluetoothGattCallback() {
            override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
                super.onConnectionStateChange(gatt, status, newState)
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> {
                        when (newState) {
                            BluetoothProfile.STATE_DISCONNECTED -> {
                                // Maybe disconnect succeed, connect failed, or connection lost when an adaptor closed event triggered.
                                gatt.close()
                                val connect = connects.remove(gatt)
                                if (connect == null) {
                                    bluetoothGATTs.remove(gatt)
                                    val disconnect = disconnects.remove(gatt)
                                    if (disconnect == null) {
                                        val event = event {
                                            this.category = Messages.EventCategory.EVENT_CATEGORY_GATT_CONNECTION_LOST
                                            this.gattConnectionLostArguments = gattConnectionLostEventArguments {
                                                this.id = gatt.id
                                                this.errorCode = BluetoothGatt.GATT_SUCCESS
                                            }
                                        }.toByteArray()
                                        activity.invokeOnMainThread { eventSink?.success(event) }
                                    } else activity.invokeOnMainThread { disconnect.success() }
                                } else activity.invokeOnMainThread {
                                    connect.error(TAG, "GATT error with status: ${BluetoothGatt.GATT_SUCCESS}.")
                                }
                            }
                            BluetoothProfile.STATE_CONNECTED -> {
                                val requestMtuSuccessfully = gatt.requestMtu(MAX_MTU)
                                if (!requestMtuSuccessfully) gatt.disconnect()
                            }
                            else -> throw NotImplementedError() // should never be called.
                        }
                    }
                    else -> {
                        // Maybe connect failed, disconnect failed or connection lost.
                        gatt.close()
                        val connect = connects.remove(gatt)
                        if (connect == null) {
                            bluetoothGATTs.remove(gatt)
                            val disconnect = disconnects.remove(gatt)
                            if (disconnect == null) {
                                val event = event {
                                    this.category = Messages.EventCategory.EVENT_CATEGORY_GATT_CONNECTION_LOST
                                    this.gattConnectionLostArguments = gattConnectionLostEventArguments {
                                        this.id = gatt.id
                                        this.errorCode = status
                                    }
                                }.toByteArray()
                                activity.invokeOnMainThread { eventSink?.success(event) }
                            } else activity.invokeOnMainThread {
                                disconnect.error(TAG, "GATT error with status: $status")
                            }
                        } else activity.invokeOnMainThread {
                            connect.error(TAG, "GATT error with status: $status")
                        }
                    }
                }
            }

            override fun onMtuChanged(gatt: BluetoothGatt, mtu: Int, status: Int) {
                super.onMtuChanged(gatt, mtu, status)
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> {
                        val discovered = gatt.discoverServices()
                        if (discovered) maximumWriteLengths[gatt] = mtu - 3
                        else gatt.disconnect()
                    }
                    else -> gatt.disconnect()
                }
            }

            override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
                super.onServicesDiscovered(gatt, status)
                val maximumWriteLength = maximumWriteLengths.remove(gatt)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> {
                        bluetoothGATTs.add(gatt)
                        val reply = reply {
                            this.centralConnectArguments = centralConnectReplyArguments {
                                this.gatt = gATT {
                                    this.id = gatt.id
                                    this.maximumWriteLength = maximumWriteLength
                                    val services = gatt.services.map {
                                        gattService {
                                            this.id = it.id
                                            this.uuid = it.uuid.toString()
                                            val characteristics = it.characteristics.map {
                                                gattCharacteristic {
                                                    this.id = it.id
                                                    this.uuid = it.uuid.toString()
                                                    this.canRead =
                                                        it.properties and BluetoothGattCharacteristic.PROPERTY_READ != 0
                                                    this.canWrite =
                                                        it.properties and BluetoothGattCharacteristic.PROPERTY_WRITE != 0
                                                    this.canWriteWithoutResponse =
                                                        it.properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0
                                                    this.canNotify =
                                                        it.properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0
                                                    val descriptors = it.descriptors.map {
                                                        gattDescriptor {
                                                            this.id = it.id
                                                            this.uuid = it.uuid.toString()
                                                        }
                                                    }
                                                    this.descriptors.addAll(descriptors)
                                                }
                                            }
                                            this.characteristics.addAll(characteristics)
                                        }
                                    }
                                    this.services.addAll(services)
                                }
                            }
                        }.toByteArray()
                        val connect = connects.remove(gatt)!!
                        activity.invokeOnMainThread { connect.success(reply) }
                    }
                    else -> gatt.disconnect()
                }
            }

            override fun onCharacteristicRead(
                gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int
            ) {
                super.onCharacteristicRead(gatt, characteristic, status)
                val read = characteristicReads.remove(characteristic)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> activity.invokeOnMainThread {
                        val reply = reply {
                            this.characteristicReadArguments = characteristicReadReplyArguments {
                                this.value = characteristic.value.toByteString()
                            }
                        }.toByteArray()
                        read.success(reply)
                    }
                    else -> activity.invokeOnMainThread {
                        read.error(TAG, "GATT error with status: $status")
                    }
                }
            }

            override fun onCharacteristicWrite(
                gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int
            ) {
                super.onCharacteristicWrite(gatt, characteristic, status)
                val write = characteristicWrites.remove(characteristic)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> activity.invokeOnMainThread {
                        write.success()
                    }
                    else -> activity.invokeOnMainThread {
                        write.error(TAG, "GATT error with status: $status")
                    }
                }
            }

            override fun onCharacteristicChanged(
                gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic
            ) {
                super.onCharacteristicChanged(gatt, characteristic)
                val event = event {
                    this.category = Messages.EventCategory.EVENT_CATEGORY_CHARACTERISTIC_NOTIFIED
                    this.characteristicNotifiedArguments = characteristicNotifiedEventArguments {
                        this.gattId = gatt.id
                        this.serviceId = characteristic.service.id
                        this.id = characteristic.id
                        this.value = ByteString.copyFrom(characteristic.value)
                    }
                }.toByteArray()
                activity.invokeOnMainThread { eventSink?.success(event) }
            }

            override fun onDescriptorRead(
                gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int
            ) {
                super.onDescriptorRead(gatt, descriptor, status)
                val read = descriptorReads.remove(descriptor)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> activity.invokeOnMainThread {
                        val reply = reply {
                            this.descriptorReadArguments = descriptorReadReplyArguments {
                                this.value = descriptor.value.toByteString()
                            }
                        }.toByteArray()
                        read.success(reply)
                    }
                    else -> activity.invokeOnMainThread {
                        read.error(TAG, "GATT error with status: $status")
                    }
                }
            }

            override fun onDescriptorWrite(
                gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int
            ) {
                super.onDescriptorWrite(gatt, descriptor, status)
                val write = descriptorWrites.remove(descriptor)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> activity.invokeOnMainThread {
                        write.success()
                    }
                    else -> activity.invokeOnMainThread {
                        write.error(TAG, "GATT error with status: $status")
                    }
                }
            }
        }
    }

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        val messenger = binding.binaryMessenger
        MethodChannel(messenger, "$NAMESPACE/method").setMethodCallHandler(methodCallHandler)
        EventChannel(messenger, "$NAMESPACE/event").setStreamHandler(streamHandler)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {}

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.binding = binding
        binding.addRequestPermissionsResultListener(requestPermissionsResultListener)
    }

    override fun onDetachedFromActivity() {
        // Clear connections.
        for (gatt in bluetoothGATTs) {
            gatt.disconnect()
        }
        binding.removeRequestPermissionsResultListener(requestPermissionsResultListener)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    private fun toProtoBluetoothState(bluetoothState: Int): Messages.BluetoothState {
        return when (bluetoothState) {
            BluetoothAdapter.STATE_OFF -> Messages.BluetoothState.BLUETOOTH_STATE_POWERED_OFF
            BluetoothAdapter.STATE_TURNING_ON -> Messages.BluetoothState.BLUETOOTH_STATE_POWERED_OFF
            BluetoothAdapter.STATE_ON -> Messages.BluetoothState.BLUETOOTH_STATE_POWERED_ON
            BluetoothAdapter.STATE_TURNING_OFF -> Messages.BluetoothState.BLUETOOTH_STATE_POWERED_ON
            else -> Messages.BluetoothState.UNRECOGNIZED
        }
    }

    private fun toAddress(address: String): String {
        return address.takeLast(12).chunked(2).joinToString(":").uppercase()
    }
}

val Any.TAG: String
    get() = this::class.java.simpleName

val Any.id: String
    get() = hashCode().toString()

val MethodCall.command: Messages.Command
    get() {
        val data = arguments<ByteArray>()
        return Messages.Command.parseFrom(data)
    }

fun Activity.invokeOnMainThread(action: Runnable) = runOnUiThread(action)

fun MethodChannel.Result.success() {
    success(null)
}

fun MethodChannel.Result.error(errorCode: String, errorMessage: String) {
    error(errorCode, errorMessage, null)
}

fun MethodChannel.Result.error(e: Exception) {
    val errorCode = e.TAG
    val errorMessage = e.localizedMessage
    val errorDetails = e.stackTraceToString()
    error(errorCode, errorMessage, errorDetails)
}

fun EventChannel.EventSink.error(errorCode: String, errorMessage: String) {
    error(errorCode, errorMessage, null)
}

fun EventChannel.EventSink.error(e: Exception) {
    val errorCode = e.TAG
    val errorMessage = e.localizedMessage
    val errorDetails = e.stackTraceToString()
    error(errorCode, errorMessage, errorDetails)
}

val BluetoothDevice.uuid: String
    get() {
        val node = address.filter { char -> char != ':' }.lowercase()
        // We don't know the timestamp of the bluetooth device, use nil UUID as prefix.
        return "00000000-0000-0000-0000-$node"
    }