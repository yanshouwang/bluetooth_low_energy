package dev.hebei.bluetooth_low_energy_android

import android.content.pm.PackageManager
import io.flutter.plugin.common.PluginRegistry

class RequestPermissionsResultListenerImpl(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiRequestPermissionsResultListener(registrar) {
    override fun pigeon_defaultConstructor(): PluginRegistry.RequestPermissionsResultListener {
        return object : PluginRegistry.RequestPermissionsResultListener {
            override fun onRequestPermissionsResult(
                requestCode: Int, permissions: Array<out String>, grantResults: IntArray
            ): Boolean {
                val result = grantResults.all { it == PackageManager.PERMISSION_GRANTED }
                this@RequestPermissionsResultListenerImpl.onRequestPermissionsResult(
                    this, requestCode.toLong(), result
                ) {}
                return true
            }
        }
    }
}