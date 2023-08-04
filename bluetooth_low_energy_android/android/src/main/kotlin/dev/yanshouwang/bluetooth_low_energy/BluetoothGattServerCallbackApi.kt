package dev.yanshouwang.bluetooth_low_energy

import io.flutter.plugin.common.BinaryMessenger

class BluetoothGattServerCallbackApi(binaryMessenger: BinaryMessenger, private val instanceManager: InstanceManager) : BluetoothGattServerCallbackHostApi {
    private val api = BluetoothGattServerCallbackFlutterApi(binaryMessenger)

    override fun newInstance(): Long {
        val callback = MyBluetoothGattServerCallback(api, instanceManager)
        return instanceManager.allocate(callback)
    }
}