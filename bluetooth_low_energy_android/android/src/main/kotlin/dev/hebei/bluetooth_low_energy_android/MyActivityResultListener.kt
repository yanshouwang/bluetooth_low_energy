package dev.hebei.bluetooth_low_energy_android

import android.content.Intent
import io.flutter.plugin.common.PluginRegistry

class MyActivityResultListener(manager: MyBluetoothLowEnergyManager) : PluginRegistry.ActivityResultListener {
    private val mManager: MyBluetoothLowEnergyManager

    init {
        mManager = manager
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        return mManager.onActivityResult(requestCode, resultCode, data)
    }
}