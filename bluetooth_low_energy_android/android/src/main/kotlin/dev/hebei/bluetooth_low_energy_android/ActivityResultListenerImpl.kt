package dev.hebei.bluetooth_low_energy_android

import android.content.Intent
import io.flutter.plugin.common.PluginRegistry

class ActivityResultListenerImpl(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiActivityResultListener(registrar) {
    override fun pigeon_defaultConstructor(): PluginRegistry.ActivityResultListener {
        return object : PluginRegistry.ActivityResultListener {
            override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
                this@ActivityResultListenerImpl.onActivityResult(
                    this, requestCode.toLong(), resultCode.toLong(), data
                ) {}
                return true
            }
        }
    }
}