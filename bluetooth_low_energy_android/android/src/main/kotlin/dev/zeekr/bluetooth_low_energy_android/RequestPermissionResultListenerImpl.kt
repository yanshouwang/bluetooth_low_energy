package dev.zeekr.bluetooth_low_energy_android

import io.flutter.plugin.common.PluginRegistry

class RequestPermissionResultListenerImpl(manager: BluetoothLowEnergyManagerImpl) :
    PluginRegistry.RequestPermissionsResultListener {
    private val mManager: BluetoothLowEnergyManagerImpl

    init {
        mManager = manager
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        results: IntArray
    ): Boolean {
        return mManager.onRequestPermissionsResult(requestCode, permissions, results)
    }
}