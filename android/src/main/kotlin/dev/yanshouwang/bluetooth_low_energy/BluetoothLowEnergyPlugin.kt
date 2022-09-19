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

val activity get() = InstanceManager.findNotNull<ActivityPluginBinding>(ActivityPluginBinding::class.java.simpleName).activity
val centralManagerFlutterApi get() = InstanceManager.findNotNull<Api.CentralManagerFlutterApi>(Api.CentralManagerFlutterApi::class.java.simpleName)
val peripheralFlutterApi get() = InstanceManager.findNotNull<Api.PeripheralFlutterApi>(Api.PeripheralFlutterApi::class.java.simpleName)
val gattCharacteristicFlutterApi get() = InstanceManager.findNotNull<Api.GattCharacteristicFlutterApi>(Api.GattCharacteristicFlutterApi::class.java.simpleName)

val bluetoothManager get() = activity.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
val bluetoothAdapter get() = bluetoothManager.adapter as BluetoothAdapter
val bluetoothAvailable get() = activity.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
val mainHandler get() = Handler(activity.mainLooper)
val mainExecutor get() = ContextCompat.getMainExecutor(activity)

/** BluetoothLowEnergyPlugin */
class BluetoothLowEnergyPlugin : FlutterPlugin, ActivityAware {
    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger

        InstanceManager[Api.CentralManagerFlutterApi::class.java.simpleName] = Api.CentralManagerFlutterApi(binaryMessenger)
        InstanceManager[Api.PeripheralFlutterApi::class.java.simpleName] = Api.PeripheralFlutterApi(binaryMessenger)
        InstanceManager[Api.GattCharacteristicFlutterApi::class.java.simpleName] = Api.GattCharacteristicFlutterApi(binaryMessenger)

        Api.CentralManagerHostApi.setup(binaryMessenger, CentralManagerHostApi)
        Api.PeripheralHostApi.setup(binaryMessenger, PeripheralHostApi)
        Api.GattServiceHostApi.setup(binaryMessenger, GattServiceHostApi)
        Api.GattCharacteristicHostApi.setup(binaryMessenger, GattCharacteristicHostApi)
        Api.GattDescriptorHostApi.setup(binaryMessenger, GattDescriptorHostApi)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger

        InstanceManager.remove(Api.CentralManagerFlutterApi::class.java.simpleName)
        InstanceManager.remove(Api.PeripheralFlutterApi::class.java.simpleName)
        InstanceManager.remove(Api.GattCharacteristicFlutterApi::class.java.simpleName)

        Api.CentralManagerHostApi.setup(binaryMessenger, null)
        Api.PeripheralHostApi.setup(binaryMessenger, null)
        Api.GattServiceHostApi.setup(binaryMessenger, null)
        Api.GattCharacteristicHostApi.setup(binaryMessenger, null)
        Api.GattDescriptorHostApi.setup(binaryMessenger, null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        InstanceManager[ActivityPluginBinding::class.java.simpleName] = binding
        binding.addRequestPermissionsResultListener(RequestPermissionsResultListener)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        val binding = InstanceManager.freeNotNull<ActivityPluginBinding>(ActivityPluginBinding::class.java.simpleName)
        binding.removeRequestPermissionsResultListener(RequestPermissionsResultListener)
    }
}

val Any.TAG get() = this::class.java.simpleName as String

val Any.id get() = hashCode().toString()
