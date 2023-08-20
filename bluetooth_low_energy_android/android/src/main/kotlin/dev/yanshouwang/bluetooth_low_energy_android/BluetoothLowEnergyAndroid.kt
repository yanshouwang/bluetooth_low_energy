package dev.yanshouwang.bluetooth_low_energy_android

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** BluetoothLowEnergyAndroid */
class BluetoothLowEnergyAndroid : FlutterPlugin, ActivityAware {
    private lateinit var centralController: MyCentralController

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val context = binding.applicationContext
        val binaryMessenger = binding.binaryMessenger
        centralController = MyCentralController(context, binaryMessenger)
        MyCentralControllerHostApi.setUp(binaryMessenger, centralController)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger
        MyCentralControllerHostApi.setUp(binaryMessenger, null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        centralController.onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        centralController.onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        centralController.onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        centralController.onDetachedFromActivity()
    }
}
