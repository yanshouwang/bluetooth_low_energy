package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.*
import android.content.Context

class BluetoothManagerImpl(registrar: BluetoothLowEnergyPigeonProxyApiRegistrar) :
    PigeonApiBluetoothManager(registrar) {
    override fun getAdapter(pigeon_instance: BluetoothManager): BluetoothAdapter {
        return pigeon_instance.adapter
    }

    override fun getConnectedDevices(pigeon_instance: BluetoothManager, profile: Long): List<BluetoothDevice> {
        return pigeon_instance.getConnectedDevices(profile.toInt())
    }

    override fun getConnectionState(pigeon_instance: BluetoothManager, device: BluetoothDevice, profile: Long): Long {
        return pigeon_instance.getConnectionState(device, profile.toInt()).toLong()
    }

    override fun getDevicesMatchingConnectionStates(
        pigeon_instance: BluetoothManager, profile: Long, states: List<Long>
    ): List<BluetoothDevice> {
        return pigeon_instance.getDevicesMatchingConnectionStates(
            profile.toInt(), states.map { it.toInt() }.toIntArray()
        )
    }

    override fun openGattServer(
        pigeon_instance: BluetoothManager, context: Context, callback: BluetoothGattServerCallback
    ): BluetoothGattServer {
        return pigeon_instance.openGattServer(context, callback)
    }
}