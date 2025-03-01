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
    private lateinit var _applicationContext: Context
    private lateinit var _registrar: BluetoothLowEnergyPigeonProxyApiRegistrar
    private var _binding: ActivityPluginBinding? = null
    private val _requestPermissionsResultListeners = mutableListOf<PluginRegistry.RequestPermissionsResultListener>()
    private val _activityResultListeners = mutableListOf<PluginRegistry.ActivityResultListener>()

    val applicationContext: Context get() = _applicationContext

    fun gatActivity(): Activity? {
        return _binding?.activity
    }

    fun addRequestPermissionsResultListener(listener: PluginRegistry.RequestPermissionsResultListener) {
        _requestPermissionsResultListeners.add(listener)
    }

    fun removeRequestPermissionsResultListener(listener: PluginRegistry.RequestPermissionsResultListener) {
        _requestPermissionsResultListeners.remove(listener)
    }

    fun addActivityResultListener(listener: PluginRegistry.ActivityResultListener) {
        _activityResultListeners.add(listener)
    }

    fun removeActivityResultListener(listener: PluginRegistry.ActivityResultListener) {
        _activityResultListeners.remove(listener)
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        _applicationContext = binding.applicationContext
        _registrar = BluetoothLowEnergyRegistrar(binding.binaryMessenger, this)
        _registrar.setUp()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        _registrar.tearDown()
        _registrar.instanceManager.stopFinalizationListener()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addRequestPermissionsResultListener(this)
        binding.addActivityResultListener(this)
        _binding = binding
    }

    override fun onDetachedFromActivity() {
        val binding = _binding ?: return
        binding.removeRequestPermissionsResultListener(this)
        binding.removeActivityResultListener(this)
        _binding = null
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
        for (listener in _requestPermissionsResultListeners) {
            listener.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
        return true
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        for (listener in _activityResultListeners) {
            listener.onActivityResult(requestCode, resultCode, data)
        }
        return true
    }
}
