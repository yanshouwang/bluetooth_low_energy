package dev.yanshouwang.bluetooth_low_energy_android

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** BluetoothLowEnergyAndroid */
class BluetoothLowEnergyAndroid : FlutterPlugin, ActivityAware {
    private lateinit var mCentralManager: MyCentralManager
    private lateinit var mPeripheralManager: MyPeripheralManager

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val context = binding.applicationContext
        val binaryMessenger = binding.binaryMessenger
        mCentralManager = MyCentralManager(context, binaryMessenger)
        mPeripheralManager = MyPeripheralManager(context, binaryMessenger)
        MyCentralManagerHostApi.setUp(binaryMessenger, mCentralManager)
        MyPeripheralManagerHostApi.setUp(binaryMessenger, mPeripheralManager)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger
        MyCentralManagerHostApi.setUp(binaryMessenger, null)
        MyPeripheralManagerHostApi.setUp(binaryMessenger, null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mCentralManager.onAttachedToActivity(binding)
        mPeripheralManager.onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        mCentralManager.onDetachedFromActivity()
        mPeripheralManager.onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }
}
