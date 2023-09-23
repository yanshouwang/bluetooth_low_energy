package dev.yanshouwang.bluetooth_low_energy_android

import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener

class MyRequestPermissionResultListener(private val myBluetoothLowEnergyManager: MyBluetoothLowEnergyManager) : RequestPermissionsResultListener {
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, results: IntArray): Boolean {
        return myBluetoothLowEnergyManager.onRequestPermissionsResult(requestCode, results)
    }
}