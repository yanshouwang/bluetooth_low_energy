package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothDevice

abstract class BluetoothLowEnergyPeer(internal val obj: BluetoothDevice) {
    val address: String get() = obj.address

    override fun equals(other: Any?): Boolean {
        if (other === this) return true
        return other is BluetoothLowEnergyPeer && other.obj == obj
    }

    override fun hashCode(): Int {
        return obj.hashCode()
    }
}