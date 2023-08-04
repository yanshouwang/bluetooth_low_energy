package dev.yanshouwang.bluetooth_low_energy

import io.flutter.plugin.common.BinaryMessenger

class ScanCallbackApi(binaryMessenger: BinaryMessenger, private val instanceManager: InstanceManager) : ScanCallbackHostApi {
    private val api = ScanCallbackFlutterApi(binaryMessenger)

    override fun newInstance(): Long {
        val callback = MyScanCallback(api, instanceManager)
        return instanceManager.allocate(callback)
    }
}