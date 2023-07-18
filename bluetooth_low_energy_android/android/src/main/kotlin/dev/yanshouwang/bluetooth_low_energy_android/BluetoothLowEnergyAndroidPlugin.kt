package dev.yanshouwang.bluetooth_low_energy_android

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** BluetoothLowEnergyAndroidPlugin */
class BluetoothLowEnergyAndroidPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val context = binding.applicationContext
        val binaryMessenger = binding.binaryMessenger
        val myCentralManagerApi = MyCentralManagerApi(context, binaryMessenger)
        MyCentralManagerHostApi.setUp(binaryMessenger, myCentralManagerApi)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger
        MyCentralManagerHostApi.setUp(binaryMessenger, null)
    }
}