package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.bluetooth.le.ScanRecord
import android.content.Context
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Handler
import android.util.Log
import androidx.core.content.ContextCompat
import dev.yanshouwang.bluetooth_low_energy.proto.BluetoothState
import dev.yanshouwang.bluetooth_low_energy.proto.UUID
import dev.yanshouwang.bluetooth_low_energy.proto.uUID
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.util.concurrent.Executor
import dev.yanshouwang.bluetooth_low_energy.pigeon.Messages as Pigeon

/** BluetoothLowEnergyPlugin */
class BluetoothLowEnergyPlugin : FlutterPlugin, ActivityAware {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger

        instances[KEY_CENTRAL_MANAGER_FLUTTER_API] = Pigeon.CentralManagerFlutterApi(binaryMessenger)
        instances[KEY_PERIPHERAL_FLUTTER_API] = Pigeon.PeripheralFlutterApi(binaryMessenger)
        instances[KEY_GATT_CHARACTERISTIC_FLUTTER_API] = Pigeon.GattCharacteristicFlutterApi(binaryMessenger)

        Pigeon.CentralManagerHostApi.setup(binaryMessenger, MyCentralManagerHostApi)
        Pigeon.PeripheralHostApi.setup(binaryMessenger, MyPeripheralHostApi)
        Pigeon.GattServiceHostApi.setup(binaryMessenger, MyGattServiceHostApi)
        Pigeon.GattCharacteristicHostApi.setup(binaryMessenger, MyGattCharacteristicHostApi)
        Pigeon.GattDescriptorHostApi.setup(binaryMessenger, MyGattDescriptorHostApi)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger

        instances.remove(KEY_CENTRAL_MANAGER_FLUTTER_API)
        instances.remove(KEY_PERIPHERAL_FLUTTER_API)
        instances.remove(KEY_GATT_CHARACTERISTIC_FLUTTER_API)

        Pigeon.CentralManagerHostApi.setup(binaryMessenger, null)
        Pigeon.PeripheralHostApi.setup(binaryMessenger, null)
        Pigeon.GattServiceHostApi.setup(binaryMessenger, null)
        Pigeon.GattCharacteristicHostApi.setup(binaryMessenger, null)
        Pigeon.GattDescriptorHostApi.setup(binaryMessenger, null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        instances[KEY_ACTIVITY_PLUGIN_BINDING] = binding
        binding.addRequestPermissionsResultListener(MyRequestPermissionsResultListener)
        // Register the central manager state changed receiver.
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        activity.registerReceiver(MyBroadcastReceiver, filter)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        // Unregister the central manager state changed receiver.
        activity.unregisterReceiver(MyBroadcastReceiver)

        val binding = instances.remove(KEY_ACTIVITY_PLUGIN_BINDING) as ActivityPluginBinding
        binding.removeRequestPermissionsResultListener(MyRequestPermissionsResultListener)
    }
}

const val KEY_CENTRAL_MANAGER_FLUTTER_API = "KEY_CENTRAL_MANAGER_FLUTTER_API"
const val KEY_PERIPHERAL_FLUTTER_API = "KEY_PERIPHERAL_FLUTTER_API"
const val KEY_GATT_CHARACTERISTIC_FLUTTER_API = "KEY_GATT_CHARACTERISTIC_FLUTTER_API"
const val KEY_ACTIVITY_PLUGIN_BINDING = "KEY_ACTIVITY_PLUGIN_BINDING"
const val KEY_COUNT = "KEY_COUNT"
const val KEY_DEVICE = "KEY_DEVICE"
const val KEY_GATT = "KEY_GATT"
const val KEY_SERVICE = "KEY_SERVICE"
const val KEY_CHARACTERISTIC = "KEY_CHARACTERISTIC"
const val KEY_DESCRIPTOR = "KEY_DESCRIPTOR"
const val KEY_AUTHORIZE_RESULT = "KEY_AUTHORIZE_RESULT"
const val KEY_START_SCAN_ERROR = "KEY_START_SCAN_ERROR"
const val KEY_CONNECT_RESULT = "KEY_CONNECT_RESULT"
const val KEY_DISCONNECT_RESULT = "KEY_DISCONNECT_RESULT"
const val KEY_REQUEST_MTU_RESULT = "KEY_REQUEST_MTU_RESULT"
const val KEY_DISCOVER_SERVICES_RESULT = "KEY_DISCOVER_SERVICES_RESULT"
const val KEY_READ_RESULT = "KEY_READ_RESULT"
const val KEY_WRITE_RESULT = "KEY_WRITE_RESULT"

val instances = mutableMapOf<String, Any>()

val activity get() = (instances[KEY_ACTIVITY_PLUGIN_BINDING] as ActivityPluginBinding).activity
val centralFlutterApi get() = instances[KEY_CENTRAL_MANAGER_FLUTTER_API] as Pigeon.CentralManagerFlutterApi
val peripheralFlutterApi get() = instances[KEY_PERIPHERAL_FLUTTER_API] as Pigeon.PeripheralFlutterApi
val characteristicFlutterApi get() = instances[KEY_GATT_CHARACTERISTIC_FLUTTER_API] as Pigeon.GattCharacteristicFlutterApi

val bluetoothManager get() = activity.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
val bluetoothAdapter get() = bluetoothManager.adapter as BluetoothAdapter
val bluetoothAvailable get() = activity.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
val mainHandler get() = Handler(activity.mainLooper)
val mainExecutor: Executor get() = ContextCompat.getMainExecutor(activity)

fun register(id: String): MutableMap<String, Any> {
    var items = instances[id] as MutableMap<String, Any>?
    if (items == null) {
        items = mutableMapOf()
        instances[id] = items
        Log.d(BluetoothLowEnergyPlugin::class.java.simpleName, "register: $id")
    }
    var count = items[KEY_COUNT] as Int? ?: 0
    count += 1
    items[KEY_COUNT] = count
    return items
}

fun unregister(id: String): MutableMap<String, Any> {
    val items = instances[id] as MutableMap<String, Any>
    var count = items[KEY_COUNT] as Int
    count -= 1
    items[KEY_COUNT] = count
    if (count < 1) {
        instances.remove(id)
        Log.d(BluetoothLowEnergyPlugin::class.java.simpleName, "unregister: $id")
    }
    return items
}

val Any.TAG: String get() = this::class.java.simpleName

val Int.stateNumber: Long
    get() {
        val state = when (this) {
            BluetoothAdapter.STATE_OFF -> BluetoothState.BLUETOOTH_STATE_POWERED_OFF
            BluetoothAdapter.STATE_TURNING_ON -> BluetoothState.BLUETOOTH_STATE_POWERED_OFF
            BluetoothAdapter.STATE_ON -> BluetoothState.BLUETOOTH_STATE_POWERED_ON
            BluetoothAdapter.STATE_TURNING_OFF -> BluetoothState.BLUETOOTH_STATE_POWERED_ON
            else -> throw IllegalArgumentException()
        }
        return state.number.toLong()
    }

val BluetoothAdapter.stateNumber: Long
    get() {
        return if (bluetoothAvailable) {
            state.stateNumber
        } else {
            BluetoothState.BLUETOOTH_STATE_UNSUPPORTED.number.toLong()
        }
    }

val BluetoothDevice.uuid: UUID
    get() {
        val node = address.filter { char -> char != ':' }.lowercase()
        // We don't know the timestamp of the bluetooth device, use nil UUID as prefix.
        return uUID {
            this.value = "00000000-0000-0000-$node"
        }
    }

//val UUID.address: String
//    get() = value.takeLast(12).chunked(2).joinToString(":").uppercase()

val ScanRecord.rawManufacturerSpecificData: ByteArray?
    get() {
        var begin = 0
        while (begin < bytes.size) {
            val length = bytes[begin++].toInt() and 0xff
            if (length == 0) {
                break
            }
            val end = begin + length
            val type = bytes[begin++].toInt() and 0xff
            if (type == MyScanCallback.DATA_TYPE_MANUFACTURER_SPECIFIC_DATA) {
                return bytes.slice(begin until end).toByteArray()
            }
            begin = end
        }
        return null
    }