package dev.yanshouwang.bluetooth_low_energy

import io.flutter.plugin.common.BinaryMessenger

class BluetoothProfileServiceListenerApi(binaryMessenger: BinaryMessenger, private val instanceManager: InstanceManager) : BluetoothProfileServiceListenerHostApi {
    private val api = BluetoothProfileServiceListenerFlutterApi(binaryMessenger)

    override fun newInstance(): Long {
        val listener = MyBluetoothProfileServiceListener(api, instanceManager)
        return instanceManager.allocate(listener)
    }
}