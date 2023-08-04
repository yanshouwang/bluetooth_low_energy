package dev.yanshouwang.bluetooth_low_energy

import io.flutter.plugin.common.BinaryMessenger

class BluetoothGattCallbackApi(binaryMessenger: BinaryMessenger, private val instanceManager: InstanceManager) : BluetoothGattCallbackHostApi {
    private val api = BluetoothGattCallbackFlutterApi(binaryMessenger)

    override fun newInstance(): Long {
        val callback = MyBluetoothGattCallback(api, instanceManager)
        return instanceManager.allocate(callback)
    }
}