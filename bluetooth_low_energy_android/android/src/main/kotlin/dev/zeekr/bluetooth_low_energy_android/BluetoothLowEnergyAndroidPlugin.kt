package dev.zeekr.bluetooth_low_energy_android

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** BluetoothLowEnergyAndroidPlugin */
class BluetoothLowEnergyAndroidPlugin : FlutterPlugin, ActivityAware {
    private var mCentralManager: CentralManagerImpl? = null
    private var mPeripheralManager: PeripheralManagerImpl? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val context = binding.applicationContext
        val binaryMessenger = binding.binaryMessenger
        val centralManager = CentralManagerImpl(context, binaryMessenger)
        val peripheralManager = PeripheralManagerImpl(context, binaryMessenger)
        CentralManagerHostApi.setUp(binaryMessenger, centralManager)
        PeripheralManagerHostApi.setUp(binaryMessenger, peripheralManager)
        this.mCentralManager = centralManager
        this.mPeripheralManager = peripheralManager
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger
        CentralManagerHostApi.setUp(binaryMessenger, null)
        PeripheralManagerHostApi.setUp(binaryMessenger, null)
        // Dropping the references is not enough: both managers hold platform
        // resources (GATT clients, an advertiser, a GATT server, an adapter-state
        // receiver registered against the application context) that outlive the
        // engine. Left running they keep the radio busy and push events at a
        // messenger that is already detached.
        this.mCentralManager?.tearDown()
        this.mPeripheralManager?.tearDown()
        this.mCentralManager = null
        this.mPeripheralManager = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.mCentralManager?.onAttachedToActivity(binding)
        this.mPeripheralManager?.onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        this.mCentralManager?.onDetachedFromActivity()
        this.mPeripheralManager?.onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        this.onDetachedFromActivity()
    }
}
