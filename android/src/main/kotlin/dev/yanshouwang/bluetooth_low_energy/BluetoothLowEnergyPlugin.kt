package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.bluetooth.le.ScanRecord
import android.content.Context
import android.content.pm.PackageManager
import android.os.Handler
import androidx.core.content.ContextCompat
import dev.yanshouwang.bluetooth_low_energy.proto.BluetoothState
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.util.concurrent.Executor
import dev.yanshouwang.bluetooth_low_energy.pigeon.Messages as Pigeon

/** BluetoothLowEnergyPlugin */
class BluetoothLowEnergyPlugin : FlutterPlugin, ActivityAware {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger

        items[KEY_CENTRAL_MANAGER_FLUTTER_API] = Pigeon.CentralManagerFlutterApi(binaryMessenger)
        items[KEY_PERIPHERAL_FLUTTER_API] = Pigeon.PeripheralFlutterApi(binaryMessenger)
        items[KEY_GATT_CHARACTERISTIC_FLUTTER_API] = Pigeon.GattCharacteristicFlutterApi(binaryMessenger)

        Pigeon.CentralManagerHostApi.setup(binaryMessenger, MyCentralManagerHostApi)
        Pigeon.PeripheralHostApi.setup(binaryMessenger, MyPeripheralHostApi)
        Pigeon.GattServiceHostApi.setup(binaryMessenger, MyGattServiceHostApi)
        Pigeon.GattCharacteristicHostApi.setup(binaryMessenger, MyGattCharacteristicHostApi)
        Pigeon.GattDescriptorHostApi.setup(binaryMessenger, MyGattDescriptorHostApi)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger

        items.remove(KEY_CENTRAL_MANAGER_FLUTTER_API)
        items.remove(KEY_PERIPHERAL_FLUTTER_API)
        items.remove(KEY_GATT_CHARACTERISTIC_FLUTTER_API)

        Pigeon.CentralManagerHostApi.setup(binaryMessenger, null)
        Pigeon.PeripheralHostApi.setup(binaryMessenger, null)
        Pigeon.GattServiceHostApi.setup(binaryMessenger, null)
        Pigeon.GattCharacteristicHostApi.setup(binaryMessenger, null)
        Pigeon.GattDescriptorHostApi.setup(binaryMessenger, null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        items[KEY_ACTIVITY_PLUGIN_BINDING] = binding
        binding.addRequestPermissionsResultListener(MyRequestPermissionsResultListener)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        val binding = items.remove(KEY_ACTIVITY_PLUGIN_BINDING) as ActivityPluginBinding
        binding.removeRequestPermissionsResultListener(MyRequestPermissionsResultListener)
    }
}

const val KEY_CENTRAL_MANAGER_FLUTTER_API = "KEY_CENTRAL_MANAGER_FLUTTER_API"
const val KEY_PERIPHERAL_FLUTTER_API = "KEY_PERIPHERAL_FLUTTER_API"
const val KEY_GATT_CHARACTERISTIC_FLUTTER_API = "KEY_GATT_CHARACTERISTIC_FLUTTER_API"
const val KEY_ACTIVITY_PLUGIN_BINDING = "KEY_ACTIVITY_PLUGIN_BINDING"
const val REQUEST_CODE = 443
const val KEY_AUTHORIZE_RESULT = "KEY_AUTHORIZE_RESULT"
const val KEY_START_SCAN_ERROR = "KEY_START_SCAN_ERROR"
const val KEY_CONNECT_RESULT = "KEY_CONNECT_RESULT"
const val KEY_DISCONNECT_RESULT = "KEY_DISCONNECT_RESULT"
const val KEY_DISCOVER_SERVICES_RESULT = "KEY_DISCOVER_SERVICES_RESULT"
const val KEY_READ_RESULT = "KEY_READ_RESULT"
const val KEY_WRITE_RESULT = "KEY_WRITE_RESULT"
const val DATA_TYPE_MANUFACTURER_SPECIFIC_DATA = 0xFF

val items = mutableMapOf<String, Any>()
val instances = mutableMapOf<Long, Any>()
val identifiers = mutableMapOf<Any, Long>()

val activity get() = (items[KEY_ACTIVITY_PLUGIN_BINDING] as ActivityPluginBinding).activity
val centralFlutterApi get() = items[KEY_CENTRAL_MANAGER_FLUTTER_API] as Pigeon.CentralManagerFlutterApi
val peripheralFlutterApi get() = items[KEY_PERIPHERAL_FLUTTER_API] as Pigeon.PeripheralFlutterApi
val characteristicFlutterApi get() = items[KEY_GATT_CHARACTERISTIC_FLUTTER_API] as Pigeon.GattCharacteristicFlutterApi

val bluetoothManager get() = activity.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
val bluetoothAdapter get() = bluetoothManager.adapter as BluetoothAdapter
val bluetoothAvailable get() = activity.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
val mainHandler get() = Handler(activity.mainLooper)
val mainExecutor: Executor get() = ContextCompat.getMainExecutor(activity)

val Any.TAG: String get() = this::class.java.simpleName

val Int.bluetoothState
    get() = when (this) {
        BluetoothAdapter.STATE_OFF -> BluetoothState.BLUETOOTH_STATE_POWERED_OFF
        BluetoothAdapter.STATE_TURNING_ON -> BluetoothState.BLUETOOTH_STATE_POWERED_OFF
        BluetoothAdapter.STATE_ON -> BluetoothState.BLUETOOTH_STATE_POWERED_ON
        BluetoothAdapter.STATE_TURNING_OFF -> BluetoothState.BLUETOOTH_STATE_POWERED_ON
        else -> throw IllegalArgumentException()
    }

val BluetoothDevice.uuidString: String
    get() {
        val node = address.filter { char -> char != ':' }.lowercase()
        // We don't know the timestamp of the bluetooth device, use nil UUID as prefix.
        return "00000000-0000-0000-$node"
    }

val String.address: String
    get() = takeLast(12).chunked(2).joinToString(":").uppercase()

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
            if (type == DATA_TYPE_MANUFACTURER_SPECIFIC_DATA) {
                return bytes.slice(begin until end).toByteArray()
            }
            begin = end
        }
        return null
    }