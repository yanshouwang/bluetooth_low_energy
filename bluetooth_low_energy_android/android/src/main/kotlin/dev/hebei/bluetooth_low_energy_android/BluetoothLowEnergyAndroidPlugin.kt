package dev.hebei.bluetooth_low_energy_android

import CentralManagerImpl
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

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val context = binding.applicationContext
        val messenger = binding.binaryMessenger
        contextUtil = ContextUtil(context)
        activityUtil = ActivityUtil()
        val centralManagerApi = CentralManagerImpl(messenger, contextUtil, activityUtil)
        CentralManagerHostApi.setUp(messenger, centralManagerApi)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val messenger = binding.binaryMessenger
        CentralManagerHostApi.setUp(messenger, null)
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
