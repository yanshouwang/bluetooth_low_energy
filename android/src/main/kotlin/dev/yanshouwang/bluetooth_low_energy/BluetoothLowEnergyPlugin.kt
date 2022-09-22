package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.pm.PackageManager
import android.os.Handler
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api
import dev.yanshouwang.bluetooth_low_energy.proto.BluetoothState
import dev.yanshouwang.bluetooth_low_energy.proto.UUID
import dev.yanshouwang.bluetooth_low_energy.proto.uUID
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.util.concurrent.Executor

/** BluetoothLowEnergyPlugin */
class BluetoothLowEnergyPlugin : FlutterPlugin, ActivityAware {
    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger

        items[KEY_CENTRAL_MANAGER_FLUTTER_API] = Api.CentralManagerFlutterApi(binaryMessenger)
        items[KEY_PERIPHERAL_FLUTTER_API] = Api.PeripheralFlutterApi(binaryMessenger)
        items[KEY_GATT_CHARACTERISTIC_FLUTTER_API] = Api.GattCharacteristicFlutterApi(binaryMessenger)

        Api.CentralManagerHostApi.setup(binaryMessenger, MyCentralManagerHostApi)
        Api.PeripheralHostApi.setup(binaryMessenger, MyPeripheralHostApi)
        Api.GattServiceHostApi.setup(binaryMessenger, MyGattServiceHostApi)
        Api.GattCharacteristicHostApi.setup(binaryMessenger, MyGattCharacteristicHostApi)
        Api.GattDescriptorHostApi.setup(binaryMessenger, MyGattDescriptorHostApi)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger

        items.remove(KEY_CENTRAL_MANAGER_FLUTTER_API)
        items.remove(KEY_PERIPHERAL_FLUTTER_API)
        items.remove(KEY_GATT_CHARACTERISTIC_FLUTTER_API)

        Api.CentralManagerHostApi.setup(binaryMessenger, null)
        Api.PeripheralHostApi.setup(binaryMessenger, null)
        Api.GattServiceHostApi.setup(binaryMessenger, null)
        Api.GattCharacteristicHostApi.setup(binaryMessenger, null)
        Api.GattDescriptorHostApi.setup(binaryMessenger, null)
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

const val BLUETOOTH_LOW_ENERGY_ERROR = "BLUETOOTH_LOW_ENERGY_ERROR"
const val KEY_CENTRAL_MANAGER_FLUTTER_API = "KEY_CENTRAL_MANAGER_FLUTTER_API"
const val KEY_PERIPHERAL_FLUTTER_API = "KEY_PERIPHERAL_FLUTTER_API"
const val KEY_GATT_CHARACTERISTIC_FLUTTER_API = "KEY_GATT_CHARACTERISTIC_FLUTTER_API"
const val KEY_ACTIVITY_PLUGIN_BINDING = "KEY_ACTIVITY_PLUGIN_BINDING"

val items = mutableMapOf<String, Any>()
val instances = mutableMapOf<Long, Any>()
val identifiers = mutableMapOf<Any, Long>()

val activity get() = (items[KEY_ACTIVITY_PLUGIN_BINDING] as ActivityPluginBinding).activity
val centralManagerFlutterApi get() = items[KEY_CENTRAL_MANAGER_FLUTTER_API] as Api.CentralManagerFlutterApi
val peripheralFlutterApi get() = items[KEY_PERIPHERAL_FLUTTER_API] as Api.PeripheralFlutterApi
val gattCharacteristicFlutterApi get() = items[KEY_GATT_CHARACTERISTIC_FLUTTER_API] as Api.GattCharacteristicFlutterApi

val bluetoothManager get() = activity.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
val bluetoothAdapter get() = bluetoothManager.adapter as BluetoothAdapter
val bluetoothAvailable get() = activity.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
val mainHandler get() = Handler(activity.mainLooper)
val mainExecutor: Executor get() = ContextCompat.getMainExecutor(activity)

val Int.bluetoothState
    get() = when (this) {
        BluetoothAdapter.STATE_OFF -> BluetoothState.BLUETOOTH_STATE_POWERED_OFF
        BluetoothAdapter.STATE_TURNING_ON -> BluetoothState.BLUETOOTH_STATE_POWERED_OFF
        BluetoothAdapter.STATE_ON -> BluetoothState.BLUETOOTH_STATE_POWERED_ON
        BluetoothAdapter.STATE_TURNING_OFF -> BluetoothState.BLUETOOTH_STATE_POWERED_ON
        else -> throw IllegalArgumentException()
    }

val BluetoothDevice.uuid: UUID
    get() {
        val node = address.filter { char -> char != ':' }.lowercase()
        // We don't know the timestamp of the bluetooth device, use nil UUID as prefix.
        return uUID {
            this.value = "00000000-0000-0000-$node"
        }
    }

val UUID.address: String get() = value.takeLast(12).chunked(2).joinToString(":").uppercase()