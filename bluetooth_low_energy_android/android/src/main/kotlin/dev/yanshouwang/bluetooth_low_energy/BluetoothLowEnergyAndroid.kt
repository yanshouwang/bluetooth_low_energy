package dev.yanshouwang.bluetooth_low_energy

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** BluetoothLowEnergyPlugin */
class BluetoothLowEnergyAndroid : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val context = binding.applicationContext
        val binaryMessenger = binding.binaryMessenger
        val myInstanceManager = MyInstanceManager()
        val myInstanceManagerApi = MyInstanceManagerApi(myInstanceManager)

        MyInstanceManagerHostApi.setUp(binaryMessenger, myInstanceManagerApi)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger

        MyInstanceManagerHostApi.setUp(binaryMessenger, null)
    }
}
