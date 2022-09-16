package dev.yanshouwang.bluetooth_low_energy

import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.pm.PackageManager
import android.os.Handler
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

val instances = mutableMapOf<String, Any>()
val activity get() = instances[Activity::class.java.simpleName] as Activity
val centralManagerFlutterApi get() = instances[Api.CentralManagerFlutterApi::class.java.simpleName] as Api.CentralManagerFlutterApi
val peripheralFlutterApi get() = instances[Api.PeripheralFlutterApi::class.java.simpleName] as Api.PeripheralFlutterApi
val gattCharacteristicFlutterApi get() = instances[Api.GattCharacteristicFlutterApi::class.java.simpleName] as Api.GattCharacteristicFlutterApi

val bluetoothManager get() = activity.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
val bluetoothAdapter get() = bluetoothManager.adapter as BluetoothAdapter
val bluetoothAvailable get() = activity.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
val mainHandler get() = Handler(activity.mainLooper)
val mainExecutor get() = ContextCompat.getMainExecutor(activity)

/** BluetoothLowEnergyPlugin */
class BluetoothLowEnergyPlugin : FlutterPlugin, ActivityAware {

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger

        instances[Api.CentralManagerFlutterApi::class.java.simpleName] =
            Api.CentralManagerFlutterApi(binaryMessenger)
        instances[Api.PeripheralFlutterApi::class.java.simpleName] =
            Api.PeripheralFlutterApi(binaryMessenger)
        instances[Api.GattCharacteristicFlutterApi::class.java.simpleName] =
            Api.GattCharacteristicFlutterApi(binaryMessenger)

        Api.CentralManagerHostApi.setup(binaryMessenger, CentralManagerHostApi)
        Api.PeripheralHostApi.setup(binaryMessenger, PeripheralHostApi)
        Api.GattServiceHostApi.setup(binaryMessenger, GattServiceHostApi)
        Api.GattCharacteristicHostApi.setup(binaryMessenger, GattCharacteristicHostApi)
        Api.GattDescriptorHostApi.setup(binaryMessenger, GattDescriptorHostApi)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger

        instances.remove(Api.CentralManagerFlutterApi::class.java.simpleName)
        instances.remove(Api.PeripheralFlutterApi::class.java.simpleName)
        instances.remove(Api.GattCharacteristicFlutterApi::class.java.simpleName)

        Api.CentralManagerHostApi.setup(binaryMessenger, null)
        Api.PeripheralHostApi.setup(binaryMessenger, null)
        Api.GattServiceHostApi.setup(binaryMessenger, null)
        Api.GattCharacteristicHostApi.setup(binaryMessenger, null)
        Api.GattDescriptorHostApi.setup(binaryMessenger, null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        instances[Activity::class.java.simpleName] = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        instances.remove(Activity::class.java.simpleName)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        instances[Activity::class.java.simpleName] = binding.activity
    }

    override fun onDetachedFromActivity() {
        instances.remove(Activity::class.java.simpleName)
    }
}

val Any.TAG get() = this::class.java.simpleName as String

val Any.id get() = hashCode().toString()

inline fun <reified T> MutableMap<String, Any>.remove(key: String): T? {
    return this.remove(key) as T?
}