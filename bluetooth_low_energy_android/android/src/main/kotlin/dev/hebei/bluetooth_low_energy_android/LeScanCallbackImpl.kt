package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice

class LeScanCallbackImpl(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiLeScanCallback(registrar) {
    override fun pigeon_defaultConstructor(): BluetoothAdapter.LeScanCallback {
        return object : BluetoothAdapter.LeScanCallback {
            override fun onLeScan(device: BluetoothDevice, rssi: Int, scanRecord: ByteArray) {
                this@LeScanCallbackImpl.onLeScan(this, device, rssi.toLong(), scanRecord) {}
            }
        }
    }
}