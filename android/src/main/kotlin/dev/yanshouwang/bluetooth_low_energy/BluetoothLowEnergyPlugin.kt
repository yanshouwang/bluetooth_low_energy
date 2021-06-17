package dev.yanshouwang.bluetooth_low_energy

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
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

/** BluetoothLowEnergyPlugin */
class BluetoothLowEnergyPlugin : FlutterPlugin, ActivityAware, MethodCallHandler, StreamHandler {
    companion object {
        private const val UNKNOWN = -1
        private const val NO_ERROR = 0
        private const val SCAN_ALREADY_STARTED = 1
        private const val REQUEST_PERMISSION_FAILED = 2
        private const val UNFINISHED_RESULT = Int.MAX_VALUE
        private const val REQUEST_CODE = 443
    }

    private lateinit var method: MethodChannel
    private lateinit var event: EventChannel
    private lateinit var context: Context

    private var binding: ActivityPluginBinding? = null
    private var sink: EventSink? = null

    private var scanning = false

    private var call: MethodCall? = null

    private var result: Result? = null
        set(value) {
            if (value != null && field != null) {
                value.error(UNFINISHED_RESULT, "There is an unfinished result.")
            }
            field = value
        }

    private val requestPermissionsResultListener: RequestPermissionsResultListener by lazy {
        RequestPermissionsResultListener { requestCode, _, results ->
            when {
                requestCode != REQUEST_CODE -> false
                results.any { result -> result != PackageManager.PERMISSION_GRANTED } -> {
                    result!!.error(REQUEST_PERMISSION_FAILED, "Request permission failed.")
                    result = null
                    true
                }
                else -> {
                    val data = call!!.arguments<ByteArray>()
                    val arguments = DiscoverArguments.parseFrom(data)
                    val code = startScan(arguments.servicesList)
                    if (code == NO_ERROR) {
                        result!!.success()
                    } else {
                        result!!.error(code, "Scan start failed with code: $code.")
                    }
                    call = null
                    result = null
                    true
                }
            }
        }
    }

    private val adapter: BluetoothAdapter by lazy {
        Log.d(TAG, "adapter: created")
        val manager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        manager.adapter
    }

    private val stateChangedReceiver: BroadcastReceiver by lazy {
        object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent == null)
                    return
                val oldState = intent.getIntExtra(BluetoothAdapter.EXTRA_PREVIOUS_STATE, UNKNOWN)
                val newState = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, UNKNOWN)
                Log.d(TAG, "Bluetooth adapter old state: $oldState; new state: $newState")
                val state = when (newState) {
                    BluetoothAdapter.STATE_OFF -> BluetoothState.POWERED_OFF
                    BluetoothAdapter.STATE_TURNING_ON -> BluetoothState.POWERED_OFF
                    BluetoothAdapter.STATE_ON -> BluetoothState.POWERED_ON
                    BluetoothAdapter.STATE_TURNING_OFF -> BluetoothState.POWERED_ON
                    else -> BluetoothState.UNRECOGNIZED
                }
                val message = Message.newBuilder()
                        .setCategory(BLUETOOTH_STATE)
                        .setState(state)
                        .build()
                        .toByteArray()
                sink?.success(message)
            }
        }
    }

    private val state: BluetoothState
        get() {
            return when {
                context.missingBluetoothFeature -> BluetoothState.UNSUPPORTED
                context.missingBluetoothPermission -> BluetoothState.UNAUTHORIZED
                else -> when (adapter.state) {
                    BluetoothAdapter.STATE_OFF -> BluetoothState.POWERED_OFF
                    BluetoothAdapter.STATE_TURNING_ON -> BluetoothState.POWERED_OFF
                    BluetoothAdapter.STATE_ON -> BluetoothState.POWERED_ON
                    BluetoothAdapter.STATE_TURNING_OFF -> BluetoothState.POWERED_ON
                    else -> BluetoothState.UNRECOGNIZED
                }
            }
        }

    private val scan18: BluetoothAdapter.LeScanCallback by lazy {
        BluetoothAdapter.LeScanCallback { device, rssi, scanRecord ->
            val discovery = Discovery.newBuilder()
                    .setAddress(device.address)
                    .setRssi(rssi)
                    .putAllAdvertisements(scanRecord.advertisements)
                    .build()
            val message = Message.newBuilder()
                    .setCategory(CENTRAL_DISCOVERED)
                    .setDiscovery(discovery)
                    .build()
                    .toByteArray()
            sink?.success(message)
        }
    }

    private val scan21: ScanCallback by lazy {
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
                        .setAddress(result.device.address)
                        .setRssi(result.rssi)
                if (result.scanRecord != null) {
                    builder.putAllAdvertisements(result.scanRecord?.bytes?.advertisements)
                }
                val discovery = builder.build()
                val message = Message.newBuilder()
                        .setCategory(CENTRAL_DISCOVERED)
                        .setDiscovery(discovery)
                        .build()
                        .toByteArray()
                sink?.success(message)
            }

            override fun onBatchScanResults(results: MutableList<ScanResult>?) {
                super.onBatchScanResults(results)
                results?.forEach { result ->
                    val builder = Discovery.newBuilder()
                            .setAddress(result.device.address)
                            .setRssi(result.rssi)
                    if (result.scanRecord != null) {
                        builder.putAllAdvertisements(result.scanRecord?.bytes?.advertisements)
                    }
                    val discovery = builder.build()
                    val message = Message.newBuilder()
                            .setCategory(CENTRAL_DISCOVERED)
                            .setDiscovery(discovery)
                            .build()
                            .toByteArray()
                    sink?.success(message)
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
                adapter.bluetoothLeScanner.startScan(filters, settings, scan21)
                // TODO: seems there is no way to get success callback when use bluetoothLeScanner#startScan.
                scanning = true
                NO_ERROR
            }
            else -> {
                val uuids = services.map { service -> UUID.fromString(service) }.toTypedArray()
                val succeed = adapter.startLeScan(uuids, scan18)
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
            adapter.bluetoothLeScanner.stopScan(scan21)
        } else {
            adapter.stopLeScan(scan18)
        }
        scanning = false
    }

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onAttachedToEngine")
        method = MethodChannel(binding.binaryMessenger, "$NAMESPACE/method")
        method.setMethodCallHandler(this)
        event = EventChannel(binding.binaryMessenger, "$NAMESPACE/event")
        event.setStreamHandler(this)
        context = binding.applicationContext
        val stateChangedFilter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        context.registerReceiver(stateChangedReceiver, stateChangedFilter)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onDetachedFromEngine")
        if (scanning) stopScan()
        context.unregisterReceiver(stateChangedReceiver)
        event.setStreamHandler(null)
        method.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d(TAG, "onAttachedToActivity")
        this.binding = binding
        this.binding!!.addRequestPermissionsResultListener(requestPermissionsResultListener)
    }

    override fun onDetachedFromActivity() {
        Log.d(TAG, "onDetachedFromActivity")
        binding!!.removeRequestPermissionsResultListener(requestPermissionsResultListener)
        binding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method.category) {
            BLUETOOTH_STATE -> result.success(state.number)
            CENTRAL_START_DISCOVERY -> {
                if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
                    val data = call.arguments<ByteArray>()
                    val arguments = DiscoverArguments.parseFrom(data)
                    val code = startScan(arguments.servicesList)
                    if (code == NO_ERROR) {
                        result.success()
                    } else {
                        result.error(code, "Scan start failed with code: $code.")
                    }
                } else {
                    this.call = call
                    this.result = result
                    val permissions = arrayOf(Manifest.permission.ACCESS_FINE_LOCATION)
                    ActivityCompat.requestPermissions(binding!!.activity, permissions, REQUEST_CODE)
                }
            }
            CENTRAL_STOP_DISCOVERY -> {
                stopScan()
                result.success()
            }
            CENTRAL_DISCOVERED -> result.notImplemented()
            CENTRAL_SCANNING -> result.success(scanning)
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
}

val Any.TAG: String
    get() = this::class.java.simpleName

val String.category: MessageCategory
    get() = valueOf(this)

val Context.missingBluetoothFeature: Boolean
    get() = !packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)

val Context.missingBluetoothPermission: Boolean
    get() {
        val requested = packageManager.getPackageInfo(packageName, PackageManager.GET_PERMISSIONS).requestedPermissions
        return !requested.contains(Manifest.permission.BLUETOOTH) || !requested.contains(Manifest.permission.BLUETOOTH_ADMIN)
    }

fun Result.success() {
    success(null)
}

fun Result.error(code: Int, message: String? = null, details: String? = null) {
    error("$code", message, details)
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