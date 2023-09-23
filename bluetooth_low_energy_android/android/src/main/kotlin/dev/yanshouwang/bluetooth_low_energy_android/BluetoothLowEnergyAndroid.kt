package dev.yanshouwang.bluetooth_low_energy_android

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** BluetoothLowEnergyAndroid */
class BluetoothLowEnergyAndroid : FlutterPlugin, ActivityAware {
    private lateinit var centralManager: MyCentralManager
    private lateinit var peripheralManager: MyPeripheralManager

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val context = binding.applicationContext
        val binaryMessenger = binding.binaryMessenger
        centralManager = MyCentralManager(context, binaryMessenger)
        peripheralManager = MyPeripheralManager(context, binaryMessenger)
        MyCentralManagerHostApi.setUp(binaryMessenger, centralManager)
        MyPeripheralManagerHostApi.setUp(binaryMessenger, peripheralManager)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger
        MyCentralManagerHostApi.setUp(binaryMessenger, null)
        MyPeripheralManagerHostApi.setUp(binaryMessenger, null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        centralManager.onAttachedToActivity(binding)
        peripheralManager.onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        centralManager.onDetachedFromActivity()
        peripheralManager.onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }
}
