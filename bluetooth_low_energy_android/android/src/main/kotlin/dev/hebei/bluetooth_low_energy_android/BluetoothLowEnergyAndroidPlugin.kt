package dev.hebei.bluetooth_low_energy_android

import android.app.Activity
import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry

/** BluetoothLowEnergyAndroidPlugin */
class BluetoothLowEnergyAndroidPlugin : FlutterPlugin, ActivityAware {
    private lateinit var contextUtil: ContextUtil
    private lateinit var activityUtil: ActivityUtil
    private lateinit var registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        contextUtil = ContextUtil(binding.applicationContext)
        activityUtil = ActivityUtil()
        registrar = BluetoothLowEnergyAndroidRegistrar(binding.binaryMessenger, contextUtil, activityUtil)
        registrar.setUp()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        registrar.tearDown()
        registrar.instanceManager.stopFinalizationListener()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityUtil.onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        activityUtil.onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }
}
