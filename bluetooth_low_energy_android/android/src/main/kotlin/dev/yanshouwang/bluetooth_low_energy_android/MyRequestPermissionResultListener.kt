package dev.yanshouwang.bluetooth_low_energy_android

import io.flutter.plugin.common.PluginRegistry

class MyRequestPermissionResultListener(manager: MyBluetoothLowEnergyManager) : PluginRegistry.RequestPermissionsResultListener {
    private val mManager: MyBluetoothLowEnergyManager

    init {
        mManager = manager
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, results: IntArray): Boolean {
        return mManager.onRequestPermissionsResult(requestCode, permissions, results)
    }
}