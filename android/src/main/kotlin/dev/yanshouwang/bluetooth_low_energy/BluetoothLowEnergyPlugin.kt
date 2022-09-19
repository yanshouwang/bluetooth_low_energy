package dev.yanshouwang.bluetooth_low_energy

import androidx.annotation.NonNull
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** BluetoothLowEnergyPlugin */
class BluetoothLowEnergyPlugin : FlutterPlugin, ActivityAware {
    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger

        instances[Api.CentralManagerFlutterApi::class.java.simpleName] = Api.CentralManagerFlutterApi(binaryMessenger)
        instances[Api.PeripheralFlutterApi::class.java.simpleName] = Api.PeripheralFlutterApi(binaryMessenger)
        instances[Api.GattCharacteristicFlutterApi::class.java.simpleName] = Api.GattCharacteristicFlutterApi(binaryMessenger)

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
        instances[ActivityPluginBinding::class.java.simpleName] = binding
        binding.addRequestPermissionsResultListener(RequestPermissionsResultListener)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        val binding = instances.freeNotNull<ActivityPluginBinding>(ActivityPluginBinding::class.java.simpleName)
        binding.removeRequestPermissionsResultListener(RequestPermissionsResultListener)
    }
}

val Any.id get() = hashCode().toString()
