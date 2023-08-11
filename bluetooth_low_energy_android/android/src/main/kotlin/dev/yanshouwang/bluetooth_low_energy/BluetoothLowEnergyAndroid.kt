package dev.yanshouwang.bluetooth_low_energy

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** BluetoothLowEnergyAndroid */
class BluetoothLowEnergyAndroid : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val context = binding.applicationContext
        val binaryMessenger = binding.binaryMessenger
        val centralController = MyCentralController(context, binaryMessenger)
        MyCentralControllerHostApi.setUp(binaryMessenger, centralController)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger
        MyCentralControllerHostApi.setUp(binaryMessenger, null)
    }
}
