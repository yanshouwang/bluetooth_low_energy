package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGattServerCallback
import android.bluetooth.BluetoothManager
import android.content.Context
import androidx.core.content.ContextCompat

class BluetoothManagerApi(private val context: Context, private val instanceManager: InstanceManager) : BluetoothManagerHostApi {
    override fun getInstance(): Long {
        val manager = ContextCompat.getSystemService(context, BluetoothManager::class.java) as BluetoothManager
        return instanceManager.allocate(manager)
    }

    override fun getAdapter(hashCode: Long): Long {
        val manager = instanceManager.valueOf(hashCode) as BluetoothManager
        val adapter = manager.adapter
        return instanceManager.allocate(adapter)
    }

    override fun getConnectionState(hashCode: Long, deviceHashCode: Long, profile: Long): Long {
        val manager = instanceManager.valueOf(hashCode) as BluetoothManager
        val device = instanceManager.valueOf(deviceHashCode) as BluetoothDevice
        val profile1 = profile.toInt()
        val connectionState = manager.getConnectionState(device, profile1)
        return connectionState.toLong()
    }

    override fun getConnectedDevices(hashCode: Long, profile: Long): List<Long> {
        val manager = instanceManager.valueOf(hashCode) as BluetoothManager
        val profile1 = profile.toInt()
        return manager.getConnectedDevices(profile1).map { device -> instanceManager.allocate(device) }
    }

    override fun getDevicesMatchingConnectionStates(hashCode: Long, profile: Long, states: List<Long>): List<Long> {
        val manager = instanceManager.valueOf(hashCode) as BluetoothManager
        val profile1 = profile.toInt()
        val states1 = states.map { state -> state.toInt() }.toIntArray()
        return manager.getDevicesMatchingConnectionStates(profile1, states1).map { device -> instanceManager.allocate(device) }
    }

    override fun openGattServer(hashCode: Long, callbackHashCode: Long): Long {
        val manager = instanceManager.valueOf(hashCode) as BluetoothManager
        val callback = instanceManager.valueOf(callbackHashCode) as BluetoothGattServerCallback
        val server = manager.openGattServer(context, callback)
        return instanceManager.allocate(server)
    }
}