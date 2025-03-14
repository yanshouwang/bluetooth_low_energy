package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothProfile

class BluetoothProfileImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
    PigeonApiBluetoothProfile(registrar) {
    override fun getConnectedDevices(pigeon_instance: BluetoothProfile): List<BluetoothDevice> {
        return pigeon_instance.connectedDevices
    }

    override fun getConnectionState(pigeon_instance: BluetoothProfile, device: BluetoothDevice): Long {
        return pigeon_instance.getConnectionState(device).toLong()
    }

    override fun getDevicesMatchingConnectionStates(
        pigeon_instance: BluetoothProfile, states: List<Long>
    ): List<BluetoothDevice> {
        return pigeon_instance.getDevicesMatchingConnectionStates(states.map { it.toInt() }.toIntArray())
    }
}