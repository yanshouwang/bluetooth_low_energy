package dev.yanshouwang.bluetooth_low_energy

import io.flutter.plugin.common.BinaryMessenger

class BroadcastReceiverApi(binaryMessenger: BinaryMessenger, private val instanceManager: InstanceManager) : BroadcastReceiverHostApi {
    private val api = BroadcastReceiverFlutterApi(binaryMessenger)

    override fun newInstance(): Long {
        val receiver = MyBroadcastReceiver(api, instanceManager)
        return instanceManager.allocate(receiver)
    }
}