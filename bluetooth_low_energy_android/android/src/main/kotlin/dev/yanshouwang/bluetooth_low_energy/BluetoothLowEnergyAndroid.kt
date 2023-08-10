package dev.yanshouwang.bluetooth_low_energy

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** BluetoothLowEnergyPlugin */
class BluetoothLowEnergyAndroid : FlutterPlugin, ActivityAware {
    private lateinit var centralController: MyCentralController

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val context = binding.applicationContext
        val binaryMessenger = binding.binaryMessenger
        centralController = MyCentralController(context, binaryMessenger).apply {
            setUp()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        centralController.tearDown()
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
