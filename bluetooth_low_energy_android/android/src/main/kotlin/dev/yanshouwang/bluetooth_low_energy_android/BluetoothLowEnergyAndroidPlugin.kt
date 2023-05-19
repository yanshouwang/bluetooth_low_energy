package dev.yanshouwang.bluetooth_low_energy_android

import CentralManagerHostApi
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** BluetoothLowEnergyAndroidPlugin */
class BluetoothLowEnergyAndroidPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val api = PigeonCentralManager(binding.applicationContext, binding.binaryMessenger)
        CentralManagerHostApi.setUp(binding.binaryMessenger, api)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        CentralManagerHostApi.setUp(binding.binaryMessenger, null)
    }
}