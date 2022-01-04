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
import android.os.ParcelUuid
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.protobuf.ByteString
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
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

/** BluetoothLowEnergyPlugin */
class BluetoothLowEnergyPlugin : FlutterPlugin, ActivityAware {
    companion object {
        private const val NAMESPACE = "yanshouwang.dev/bluetooth_low_energy"
        private const val CLIENT_CHARACTERISTIC_CONFIG = "00002902-0000-1000-8000-00805f9b34fb"
        private const val BLUETOOTH_ADAPTER_STATE_UNKNOWN = -1
        private const val NO_ERROR = 0
        private const val REQUEST_CODE = 443
    }

    private lateinit var binding: ActivityPluginBinding

    private var eventSink: EventSink? = null

    private val methodCallHandler by lazy {
        MethodCallHandler { call, result ->
            val command = call.command
            when (command.category!!) {
                Messages.CommandCategory.COMMAND_CATEGORY_BLUETOOTH_GET_STATE -> {
                    val state = bluetoothState.number
                    result.success(state)
                }
                Messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_START_DISCOVERY -> {
                    val startDiscovery = Runnable {
                        val arguments = command.centralStartDiscoveryArguments
                        val uuids = arguments.uuidsList
                        val filters = uuids.map { uuid ->
                            val serviceUUID = ParcelUuid.fromString(uuid)
                            ScanFilter.Builder()
                                .setServiceUuid(serviceUUID)
                                .build()
                        }
                        val settings = ScanSettings.Builder()
                            .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
                            .build()
                        bluetoothAdapter.bluetoothLeScanner.startScan(
                            filters,
                            settings,
                            scanCallback
                        )
                        // use invokeOnMainThread to delay until #onScanFailed executed.
                        invokeOnMainThread {
                            when (val code = scanCode) {
                                NO_ERROR -> {
                                    result.success()
                                    scanning = true
                                }
                                else -> {
                                    result.error(TAG, "Start discovery failed with code: $code")
                                    scanCode = NO_ERROR
                                }
                            }
                        }
                    }
                    val hasPermission = ContextCompat.checkSelfPermission(
                        binding.activity,
                        Manifest.permission.ACCESS_FINE_LOCATION
                    ) == PackageManager.PERMISSION_GRANTED
                    if (hasPermission) startDiscovery.run()
                    else {
                        requestPermissionResultListeners.add { granted ->
                            if (granted) startDiscovery.run()
                            else result.error(
                                TAG,
                                "Start discovery failed: Permissions request was denied by user."
                            )
                        }
                        val permissions = arrayOf(Manifest.permission.ACCESS_FINE_LOCATION)
                        ActivityCompat.requestPermissions(
                            binding.activity,
                            permissions,
                            REQUEST_CODE
                        )
                    }
                }
                Messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_STOP_DISCOVERY -> {
                    bluetoothAdapter.bluetoothLeScanner.stopScan(scanCallback)
                    scanning = false
                    result.success()
                }
                Messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_CONNECT -> {
                    val arguments = command.centralConnectArguments
                    val uuid = arguments.uuid
                    val address = toAddress(uuid)
                    val device = bluetoothAdapter.getRemoteDevice(address)
                    val context = binding.activity
                    val autoConnect = false
                    val gatt = when {
                        // Use TRANSPORT_LE to avoid none flag device on Android 23 or later.
                        Build.VERSION.SDK_INT >= Build.VERSION_CODES.M -> device.connectGatt(
                            context,
                            autoConnect,
                            bluetoothGattCallback,
                            BluetoothDevice.TRANSPORT_LE
                        )
                        else -> device.connectGatt(
                            binding.activity,
                            autoConnect,
                            bluetoothGattCallback
                        )
                    }
                    connects[gatt] = result
                }
                Messages.CommandCategory.COMMAND_CATEGORY_GATT_DISCONNECT -> {
                    val arguments = command.gattDisconnectArguments
                    val indexedUUID = arguments.indexedUuid
                    val indexedGATT = indexedGATTs[indexedUUID]!!
                    val gatt = indexedGATT.`object`
                    disconnects[gatt] = result
                    gatt.disconnect()
                }
                Messages.CommandCategory.COMMAND_CATEGORY_GATT_CHARACTERISTIC_READ -> {
                    val arguments = command.characteristicReadArguments
                    val indexedGattUUID = arguments.indexedGattUuid
                    val indexedServiceUUID = arguments.indexedServiceUuid
                    val indexedUUID = arguments.indexedUuid
                    val indexedGATT = indexedGATTs[indexedGattUUID]!!
                    val indexedServices = indexedGATT.indexedServices
                    val indexedService = indexedServices[indexedServiceUUID]!!
                    val indexedCharacteristics = indexedService.indexedCharacteristics
                    val indexedCharacteristic = indexedCharacteristics[indexedUUID]!!
                    val gatt = indexedGATT.`object`
                    val characteristic = indexedCharacteristic.`object`
                    val readSuccessfully = gatt.readCharacteristic(characteristic)
                    if (readSuccessfully) characteristicReads[characteristic] = result
                    else result.error(TAG, "Read characteristic failed.")
                }
                Messages.CommandCategory.COMMAND_CATEGORY_GATT_CHARACTERISTIC_WRITE -> {
                    val arguments = command.characteristicWriteArguments
                    val indexedGattUUID = arguments.indexedGattUuid
                    val indexedServiceUUID = arguments.indexedServiceUuid
                    val indexedUUID = arguments.indexedUuid
                    val withoutResponse = arguments.withoutResponse
                    val value = arguments.value.toByteArray()
                    val indexedGATT = indexedGATTs[indexedGattUUID]!!
                    val indexedServices = indexedGATT.indexedServices
                    val indexedService = indexedServices[indexedServiceUUID]!!
                    val indexedCharacteristics = indexedService.indexedCharacteristics
                    val indexedCharacteristic = indexedCharacteristics[indexedUUID]!!
                    val gatt = indexedGATT.`object`
                    val characteristic = indexedCharacteristic.`object`
                    characteristic.writeType =
                        if (withoutResponse) BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
                        else BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
                    characteristic.value = value
                    val writeSuccessfully = gatt.writeCharacteristic(characteristic)
                    if (writeSuccessfully) characteristicWrites[characteristic] = result
                    else result.error(TAG, "Write characteristic failed.")
                }
                Messages.CommandCategory.COMMAND_CATEGORY_GATT_CHARACTERISTIC_NOTIFY -> {
                    val arguments = command.characteristicNotifyArguments
                    val indexedGattUUID = arguments.indexedGattUuid
                    val indexedServiceUUID = arguments.indexedServiceUuid
                    val indexedUUID = arguments.indexedUuid
                    val state = arguments.state
                    val indexedGATT = indexedGATTs[indexedGattUUID]!!
                    val indexedServices = indexedGATT.indexedServices
                    val indexedService = indexedServices[indexedServiceUUID]!!
                    val indexedCharacteristics = indexedService.indexedCharacteristics
                    val indexedCharacteristic = indexedCharacteristics[indexedUUID]!!
                    val gatt = indexedGATT.`object`
                    val characteristic = indexedCharacteristic.`object`
                    val descriptorUUID = UUID.fromString(CLIENT_CHARACTERISTIC_CONFIG)
                    val descriptor = characteristic.getDescriptor(descriptorUUID)
                    val notifySuccessfully =
                        gatt.setCharacteristicNotification(characteristic, state)
                    if (notifySuccessfully) {
                        descriptor.value =
                            if (state) BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                            else BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
                        val writeSuccessfully = gatt.writeDescriptor(descriptor)
                        if (writeSuccessfully) descriptorWrites[descriptor] = result
                        else result.error(
                            TAG,
                            "Write client characteristic config descriptor failed."
                        )
                    } else {
                        result.error(TAG, "Notify characteristic failed.")
                    }
                }
                Messages.CommandCategory.COMMAND_CATEGORY_GATT_DESCRIPTOR_READ -> {
                    val arguments = command.descriptorReadArguments
                    val indexedGattUUID = arguments.indexedGattUuid
                    val indexedServiceUUID = arguments.indexedServiceUuid
                    val indexedCharacteristicUUID = arguments.indexedCharacteristicUuid
                    val indexedUUID = arguments.indexedUuid
                    val indexedGATT = indexedGATTs[indexedGattUUID]!!
                    val indexedServices = indexedGATT.indexedServices
                    val indexedService = indexedServices[indexedServiceUUID]!!
                    val indexedCharacteristics = indexedService.indexedCharacteristics
                    val indexedCharacteristic = indexedCharacteristics[indexedCharacteristicUUID]!!
                    val indexedDescriptors = indexedCharacteristic.indexedDescriptors
                    val indexedDescriptor = indexedDescriptors[indexedUUID]!!
                    val gatt = indexedGATT.`object`
                    val descriptor = indexedDescriptor.`object`
                    val readSuccessfully = gatt.readDescriptor(descriptor)
                    if (readSuccessfully) descriptorReads[descriptor] = result
                    else result.error(TAG, "Read descriptor failed.")
                }
                Messages.CommandCategory.COMMAND_CATEGORY_GATT_DESCRIPTOR_WRITE -> {
                    val arguments = command.descriptorWriteArguments
                    val indexedGattUUID = arguments.indexedGattUuid
                    val indexedServiceUUID = arguments.indexedServiceUuid
                    val indexedCharacteristicUUID = arguments.indexedCharacteristicUuid
                    val indexedUUID = arguments.indexedUuid
                    val value = arguments.value.toByteArray()
                    val indexedGATT = indexedGATTs[indexedGattUUID]!!
                    val indexedServices = indexedGATT.indexedServices
                    val indexedService = indexedServices[indexedServiceUUID]!!
                    val indexedCharacteristics = indexedService.indexedCharacteristics
                    val indexedCharacteristic = indexedCharacteristics[indexedCharacteristicUUID]!!
                    val indexedDescriptors = indexedCharacteristic.indexedDescriptors
                    val indexedDescriptor = indexedDescriptors[indexedUUID]!!
                    val gatt = indexedGATT.`object`
                    val descriptor = indexedDescriptor.`object`
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
        object : StreamHandler {
            override fun onListen(arguments: Any?, events: EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                // This must be a hot reload for now, clear all status here.
                clear()
                eventSink = null
            }
        }
    }

    private val requestPermissionsResultListener by lazy {
        RequestPermissionsResultListener { requestCode, _, grantResults ->
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

    private val requestPermissionResultListeners by lazy { mutableListOf<(granted: Boolean) -> Unit>() }

    private val bluetoothAvailable by lazy {
        binding.activity.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
    }
    private val bluetoothManager by lazy {
        binding.activity.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
    }
    private val bluetoothAdapter by lazy { bluetoothManager.adapter }

    private val bluetoothState: Messages.BluetoothState
        get() {
            return if (bluetoothAvailable) toProtoBluetoothState(bluetoothAdapter.state)
            else Messages.BluetoothState.BLUETOOTH_STATE_UNSUPPORTED
        }

    private val bluetoothStateReceiver by lazy {
        object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val oldState = intent!!.getIntExtra(
                    BluetoothAdapter.EXTRA_PREVIOUS_STATE,
                    BLUETOOTH_ADAPTER_STATE_UNKNOWN
                )
                val newState = intent.getIntExtra(
                    BluetoothAdapter.EXTRA_STATE,
                    BLUETOOTH_ADAPTER_STATE_UNKNOWN
                )
                if (newState == oldState) return
                val state = toProtoBluetoothState(newState)
                if (state != Messages.BluetoothState.BLUETOOTH_STATE_POWERED_ON && scanning) {
                    scanning = false
                }
                val event = event {
                    this.category = Messages.EventCategory.EVENT_CATEGORY_BLUETOOTH_STATE_CHANGED
                    this.bluetoothStateChangedArguments = bluetoothStateChangedArguments {
                        this.state = state
                    }
                }.toByteArray()
                eventSink?.success(event)
            }
        }
    }

    private var scanCode = NO_ERROR
    private var scanning = false

    private val indexedGATTs by lazy { mutableMapOf<String, IndexedGATT>() }
    private val connects by lazy { mutableMapOf<BluetoothGatt, Result>() }
    private val maximumWriteLengths by lazy { mutableMapOf<BluetoothGatt, Int>() }
    private val disconnects by lazy { mutableMapOf<BluetoothGatt, Result>() }
    private val characteristicReads by lazy { mutableMapOf<BluetoothGattCharacteristic, Result>() }
    private val characteristicWrites by lazy { mutableMapOf<BluetoothGattCharacteristic, Result>() }
    private val descriptorReads by lazy { mutableMapOf<BluetoothGattDescriptor, Result>() }
    private val descriptorWrites by lazy { mutableMapOf<BluetoothGattDescriptor, Result>() }

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
                val event = event {
                    this.category = Messages.EventCategory.EVENT_CATEGORY_CENTRAL_DISCOVERED
                    this.centralDiscoveredArguments = centralDiscoveredArguments {
                        this.discovery = peripheralDiscovery {
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
                    val record = result.scanRecord
                    val advertisements =
                        if (record == null) ByteString.EMPTY
                        else ByteString.copyFrom(record.bytes)
                    // TODO: We can't get connectable value before Android 8.0, here we just return true
                    //  remove this useless code after the minSdkVersion set to 26 or later.
                    val connectable =
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) result.isConnectable
                        else true
                    val event = event {
                        this.category = Messages.EventCategory.EVENT_CATEGORY_CENTRAL_DISCOVERED
                        this.centralDiscoveredArguments = centralDiscoveredArguments {
                            this.discovery = peripheralDiscovery {
                                this.uuid = result.device.uuid
                                this.rssi = result.rssi
                                this.advertisements = advertisements
                                this.connectable = connectable
                            }
                        }
                    }.toByteArray()
                    eventSink?.success(event)
                }
            }
        }
    }
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
                                if (connect == null) {
                                    val indexedGATT = indexedGATTs.entries.first { entry ->
                                        entry.value.`object` === gatt
                                    }
                                    indexedGATTs.remove(indexedGATT.key)
                                    val disconnect = disconnects.remove(gatt)
                                    if (disconnect == null) {
                                        val event = event {
                                            this.category =
                                                Messages.EventCategory.EVENT_CATEGORY_GATT_CONNECTION_LOST
                                            this.gattConnectionLostArguments =
                                                gattConnectionLostArguments {
                                                    this.indexedUuid = indexedGATT.key
                                                    this.error = "GATT error with status: $status"
                                                }
                                        }.toByteArray()
                                        invokeOnMainThread { eventSink?.success(event) }
                                    } else invokeOnMainThread { disconnect.success() }
                                } else invokeOnMainThread {
                                    connect.error(TAG, "GATT error with status: $status.")
                                }
                            }
                            BluetoothProfile.STATE_CONNECTED -> {
                                // Must be connect succeed.
                                val requestMtuSuccessfully = gatt!!.requestMtu(512)
                                if (!requestMtuSuccessfully) gatt.disconnect()
                            }
                            else -> throw NotImplementedError() // should never be called.
                        }
                    }
                    else -> {
                        // Maybe connect failed, disconnect failed or connection lost.
                        gatt!!.close()
                        val connect = connects.remove(gatt)
                        if (connect == null) {
                            val indexedGATT = indexedGATTs.entries.first { entry ->
                                entry.value.`object` === gatt
                            }
                            indexedGATTs.remove(indexedGATT.key)
                            val disconnect = disconnects.remove(gatt)
                            if (disconnect == null) {
                                val event = event {
                                    this.category =
                                        Messages.EventCategory.EVENT_CATEGORY_GATT_CONNECTION_LOST
                                    this.gattConnectionLostArguments = gattConnectionLostArguments {
                                        this.indexedUuid = indexedGATT.key
                                        this.error = "GATT error with status: $status"
                                    }
                                }.toByteArray()
                                invokeOnMainThread { eventSink?.success(event) }
                            } else invokeOnMainThread {
                                disconnect.error(TAG, "GATT error with status: $status")
                            }
                        } else invokeOnMainThread {
                            connect.error(TAG, "GATT error with status: $status")
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
                        val indexedServices = mutableMapOf<String, IndexedGattService>()
                        val replyServices = mutableListOf<Messages.GattService>()
                        for (service in gatt!!.services) {
                            val indexedCharacteristics =
                                mutableMapOf<String, IndexedGattCharacteristic>()
                            val replyCharacteristics = mutableListOf<Messages.GattCharacteristic>()
                            for (characteristic in service.characteristics) {
                                val indexedDescriptors =
                                    mutableMapOf<String, IndexedGattDescriptor>()
                                val replyDescriptors = mutableListOf<Messages.GattDescriptor>()
                                for (descriptor in characteristic.descriptors) {
                                    // Add indexed descriptor.
                                    val indexedDescriptor = IndexedGattDescriptor(descriptor)
                                    indexedDescriptors[indexedDescriptor.uuid] = indexedDescriptor
                                    // Add reply descriptor.
                                    val replyDescriptor = gattDescriptor {
                                        this.indexedUuid = indexedDescriptor.uuid
                                        this.uuid = descriptor.uuid.toString()
                                    }
                                    replyDescriptors.add(replyDescriptor)
                                }
                                // Add indexed characteristic.
                                val indexedCharacteristic =
                                    IndexedGattCharacteristic(characteristic, indexedDescriptors)
                                indexedCharacteristics[indexedCharacteristic.uuid] =
                                    indexedCharacteristic
                                // Add reply characteristic.
                                val replyCharacteristic = gattCharacteristic {
                                    this.indexedUuid = indexedCharacteristic.uuid
                                    this.uuid = characteristic.uuid.toString()
                                    this.canRead =
                                        characteristic.properties and BluetoothGattCharacteristic.PROPERTY_READ != 0
                                    this.canWrite =
                                        characteristic.properties and BluetoothGattCharacteristic.PROPERTY_WRITE != 0
                                    this.canWriteWithoutResponse =
                                        characteristic.properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0
                                    this.canNotify =
                                        characteristic.properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0
                                    this.descriptors.addAll(replyDescriptors)
                                }
                                replyCharacteristics.add(replyCharacteristic)
                            }
                            // Add indexed service.
                            val indexedService = IndexedGattService(service, indexedCharacteristics)
                            indexedServices[indexedService.uuid] = indexedService
                            // Add reply service.
                            val replyService = gattService {
                                this.indexedUuid = indexedService.uuid
                                this.uuid = service.uuid.toString()
                                this.characteristics.addAll(replyCharacteristics)
                            }
                            replyServices.add(replyService)
                        }
                        // Add indexed GATT.
                        val indexedGATT = IndexedGATT(gatt, indexedServices)
                        indexedGATTs[indexedGATT.uuid] = indexedGATT
                        // Make connect reply.
                        val messageGATT = gATT {
                            this.indexedUuid = indexedGATT.uuid
                            this.maximumWriteLength = maximumWriteLength
                            this.services.addAll(replyServices)
                        }.toByteArray()
                        val connect = connects.remove(gatt)!!
                        invokeOnMainThread { connect.success(messageGATT) }
                    }
                    else -> gatt!!.disconnect()
                }
            }

            override fun onCharacteristicRead(
                gatt: BluetoothGatt?,
                characteristic: BluetoothGattCharacteristic?,
                status: Int
            ) {
                super.onCharacteristicRead(gatt, characteristic, status)
                val read = characteristicReads.remove(characteristic)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> invokeOnMainThread {
                        read.success(characteristic!!.value)
                    }
                    else -> invokeOnMainThread {
                        read.error(TAG, "GATT error with status: $status")
                    }
                }
            }

            override fun onCharacteristicWrite(
                gatt: BluetoothGatt?,
                characteristic: BluetoothGattCharacteristic?,
                status: Int
            ) {
                super.onCharacteristicWrite(gatt, characteristic, status)
                val write = characteristicWrites.remove(characteristic)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> invokeOnMainThread {
                        write.success()
                    }
                    else -> invokeOnMainThread {
                        write.error(TAG, "GATT error with status: $status")
                    }
                }
            }

            override fun onCharacteristicChanged(
                gatt: BluetoothGatt?,
                characteristic: BluetoothGattCharacteristic?
            ) {
                super.onCharacteristicChanged(gatt, characteristic)
                val indexedGATT = indexedGATTs.values.first { entry ->
                    entry.`object` === gatt
                }
                val indexedServices = indexedGATT.indexedServices
                val indexedService = indexedServices.values.first { entry ->
                    entry.`object` === characteristic!!.service
                }
                val indexedCharacteristics = indexedService.indexedCharacteristics
                val indexedCharacteristic = indexedCharacteristics.values.first { entry ->
                    entry.`object` === characteristic
                }
                val event = event {
                    this.category =
                        Messages.EventCategory.EVENT_CATEGORY_GATT_CHARACTERISTIC_VALUE_CHANGED
                    this.characteristicValueChangedArguments =
                        gattCharacteristicValueChangedArguments {
                            this.indexedGattUuid = indexedGATT.uuid
                            this.indexedServiceUuid = indexedService.uuid
                            this.indexedUuid = indexedCharacteristic.uuid
                            this.value = ByteString.copyFrom(characteristic!!.value)
                        }
                }.toByteArray()
                invokeOnMainThread { eventSink?.success(event) }
            }

            override fun onDescriptorRead(
                gatt: BluetoothGatt?,
                descriptor: BluetoothGattDescriptor?,
                status: Int
            ) {
                super.onDescriptorRead(gatt, descriptor, status)
                val read = descriptorReads.remove(descriptor)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> invokeOnMainThread {
                        read.success(descriptor!!.value)
                    }
                    else -> invokeOnMainThread {
                        read.error(TAG, "GATT error with status: $status")
                    }
                }
            }

            override fun onDescriptorWrite(
                gatt: BluetoothGatt?,
                descriptor: BluetoothGattDescriptor?,
                status: Int
            ) {
                super.onDescriptorWrite(gatt, descriptor, status)
                val write = descriptorWrites.remove(descriptor)!!
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> invokeOnMainThread {
                        write.success()
                    }
                    else -> invokeOnMainThread {
                        write.error(TAG, "GATT error with status: $status")
                    }
                }
            }
        }
    }

    override fun onAttachedToEngine(@NonNull binding: FlutterPluginBinding) {
        val messenger = binding.binaryMessenger
        MethodChannel(messenger, "$NAMESPACE/method").setMethodCallHandler(methodCallHandler)
        EventChannel(messenger, "$NAMESPACE/event").setStreamHandler(streamHandler)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPluginBinding) {}

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.binding = binding
        binding.addRequestPermissionsResultListener(requestPermissionsResultListener)
        // Register bluetooth adapter state receiver.
        val bluetoothStateFilter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        binding.activity.registerReceiver(bluetoothStateReceiver, bluetoothStateFilter)
    }

    override fun onDetachedFromActivity() {
        clear()
        // Unregister bluetooth adapter state receiver.
        binding.activity.unregisterReceiver(bluetoothStateReceiver)
        binding.removeRequestPermissionsResultListener(requestPermissionsResultListener)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    private fun clear() {
        // Clear connections.
        for (indexedGATT in indexedGATTs.values) {
            val gatt = indexedGATT.`object`
            gatt.disconnect()
        }
        // Stop scan.
        if (scanning) {
            bluetoothAdapter.bluetoothLeScanner.stopScan(scanCallback)
            scanning = false
        }
    }

    private fun invokeOnMainThread(action: Runnable) {
        binding.activity.runOnUiThread(action)
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

val MethodCall.command: Messages.Command
    get() {
        val data = arguments<ByteArray>()
        return Messages.Command.parseFrom(data)
    }

fun Result.success() {
    success(null)
}

fun Result.error(errorCode: String, errorMessage: String) {
    error(errorCode, errorMessage, null)
}

fun Result.error(e: Exception) {
    val errorCode = e.TAG
    val errorMessage = e.localizedMessage
    val errorDetails = e.stackTraceToString()
    error(errorCode, errorMessage, errorDetails)
}

fun EventSink.error(errorCode: String, errorMessage: String) {
    error(errorCode, errorMessage, null)
}

fun EventSink.error(e: Exception) {
    val errorCode = e.TAG
    val errorMessage = e.localizedMessage
    val errorDetails = e.stackTraceToString()
    error(errorCode, errorMessage, errorDetails)
}

val BluetoothDevice.uuid: String
    get() {
        val node = address.filter { char -> char != ':' }.lowercase()
        // We don't known the timestamp of the bluetooth device, use nil UUID as prefix.
        return "00000000-0000-0000-0000-$node"
    }