package dev.yanshouwang.bluetooth_low_energy_android

import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener

class MyRequestPermissionResultListener(private val bluetoothLowEnergyManager: MyBluetoothLowEnergyManager) : RequestPermissionsResultListener {
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, results: IntArray): Boolean {
        return bluetoothLowEnergyManager.onRequestPermissionsResult(requestCode, results)
    }
}