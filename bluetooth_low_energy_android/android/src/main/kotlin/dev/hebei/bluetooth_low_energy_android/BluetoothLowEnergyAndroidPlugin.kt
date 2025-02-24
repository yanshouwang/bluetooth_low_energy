package dev.hebei.bluetooth_low_energy_android

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** BluetoothLowEnergyAndroidPlugin */
class BluetoothLowEnergyAndroidPlugin : FlutterPlugin, ActivityAware {
    private lateinit var mCentralManager: MyCentralManager
    private lateinit var mPeripheralManager: MyPeripheralManager
    private lateinit var registrar: BluetoothLowEnergyPigeonProxyApiRegistrar

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val context = binding.applicationContext
        val binaryMessenger = binding.binaryMessenger
        mCentralManager = MyCentralManager(context, binaryMessenger)
        mPeripheralManager = MyPeripheralManager(context, binaryMessenger)
        MyCentralManagerHostAPI.setUp(binaryMessenger, mCentralManager)
        MyPeripheralManagerHostAPI.setUp(binaryMessenger, mPeripheralManager)
        registrar = BluetoothLowEnergyRegistrar(binding.binaryMessenger)
        registrar.setUp()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger
        MyCentralManagerHostAPI.setUp(binaryMessenger, null)
        MyPeripheralManagerHostAPI.setUp(binaryMessenger, null)
        registrar.tearDown()
        registrar.instanceManager.stopFinalizationListener()
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
