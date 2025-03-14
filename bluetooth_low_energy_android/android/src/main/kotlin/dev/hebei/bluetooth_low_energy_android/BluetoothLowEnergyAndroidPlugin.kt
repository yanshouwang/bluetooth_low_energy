package dev.hebei.bluetooth_low_energy_android

import android.app.Activity
import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry

/** BluetoothLowEnergyAndroidPlugin */
class BluetoothLowEnergyAndroidPlugin : FlutterPlugin, ActivityAware, PluginRegistry.RequestPermissionsResultListener,
    PluginRegistry.ActivityResultListener {
    private lateinit var applicationContext: Context
    private lateinit var registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar
    private var binding: ActivityPluginBinding? = null
    private val requestPermissionsResultListeners = mutableListOf<PluginRegistry.RequestPermissionsResultListener>()
    private val activityResultListeners = mutableListOf<PluginRegistry.ActivityResultListener>()

    val context: Context get() = applicationContext

    fun gatActivity(): Activity? {
        return binding?.activity
    }

    fun addRequestPermissionsResultListener(listener: PluginRegistry.RequestPermissionsResultListener) {
        requestPermissionsResultListeners.add(listener)
    }

    fun removeRequestPermissionsResultListener(listener: PluginRegistry.RequestPermissionsResultListener) {
        requestPermissionsResultListeners.remove(listener)
    }

    fun addActivityResultListener(listener: PluginRegistry.ActivityResultListener) {
        activityResultListeners.add(listener)
    }

    fun removeActivityResultListener(listener: PluginRegistry.ActivityResultListener) {
        activityResultListeners.remove(listener)
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = binding.applicationContext
        registrar = BluetoothLowEnergyAndroidRegistrar(binding.binaryMessenger, this)
        registrar.setUp()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        registrar.tearDown()
        registrar.instanceManager.stopFinalizationListener()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addRequestPermissionsResultListener(this)
        binding.addActivityResultListener(this)
        this.binding = binding
    }

    override fun onDetachedFromActivity() {
        val binding = binding ?: return
        binding.removeRequestPermissionsResultListener(this)
        binding.removeActivityResultListener(this)
        this.binding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, grantResults: IntArray
    ): Boolean {
        for (listener in requestPermissionsResultListeners) {
            listener.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
        return true
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        for (listener in activityResultListeners) {
            listener.onActivityResult(requestCode, resultCode, data)
        }
        return true
    }
}
