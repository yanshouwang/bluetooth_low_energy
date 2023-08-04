package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.os.Build
import androidx.annotation.RequiresApi
import java.util.UUID

class BluetoothGattApi(private val instanceManager: InstanceManager) : BluetoothGattHostApi {
    override fun getDevice(hashCode: Long): Long {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        val device = gatt.device
        return instanceManager.allocate(device)
    }

    override fun getConnectedDevices(hashCode: Long): List<Long> {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        return gatt.connectedDevices.map { device -> instanceManager.allocate(device) }
    }

    override fun getServices(hashCode: Long): List<Long> {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        return gatt.services.map { service -> instanceManager.allocate(service) }
    }

    override fun connect(hashCode: Long): Boolean {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        return gatt.connect()
    }

    override fun discoverServices(hashCode: Long): Boolean {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        return gatt.discoverServices()
    }

    override fun getService(hashCode: Long, uuidHashCode: Long): Long {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        val uuid = instanceManager.valueOf(uuidHashCode) as UUID
        val service = gatt.getService(uuid)
        return instanceManager.allocate(service)
    }

    override fun beginReliableWrite(hashCode: Long): Boolean {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        return gatt.beginReliableWrite()
    }

    override fun executeReliableWrite(hashCode: Long): Boolean {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        return gatt.executeReliableWrite()
    }

    override fun abortReliableWrite(hashCode: Long) {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        return gatt.abortReliableWrite()
    }

    override fun disconnect(hashCode: Long) {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        return gatt.disconnect()
    }

    override fun close(hashCode: Long) {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        return gatt.close()
    }

    override fun readCharacteristic(hashCode: Long, characteristicHashCode: Long): Boolean {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        val characteristic = instanceManager.valueOf(characteristicHashCode) as BluetoothGattCharacteristic
        return gatt.readCharacteristic(characteristic)
    }

    override fun writeCharacteristic(hashCode: Long, characteristicHashCode: Long): Boolean {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        val characteristic = instanceManager.valueOf(characteristicHashCode) as BluetoothGattCharacteristic
        return gatt.writeCharacteristic(characteristic)
    }

    override fun setCharacteristicNotification(hashCode: Long, characteristicHashCode: Long, enable: Boolean): Boolean {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        val characteristic = instanceManager.valueOf(characteristicHashCode) as BluetoothGattCharacteristic
        return gatt.setCharacteristicNotification(characteristic, enable)
    }

    override fun readDescriptor(hashCode: Long, descriptorHashCode: Long): Boolean {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        val descriptor = instanceManager.valueOf(descriptorHashCode) as BluetoothGattDescriptor
        return gatt.readDescriptor(descriptor)
    }

    override fun writeDescriptor(hashCode: Long, descriptorHashCode: Long): Boolean {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        val descriptor = instanceManager.valueOf(descriptorHashCode) as BluetoothGattDescriptor
        return gatt.writeDescriptor(descriptor)
    }

    override fun readRemoteRssi(hashCode: Long): Boolean {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        return gatt.readRemoteRssi()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun readPhy(hashCode: Long) {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        gatt.readPhy()
    }

    override fun requestMtu(hashCode: Long, mtu: Long): Boolean {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        val mtu1 = mtu.toInt()
        return gatt.requestMtu(mtu1)
    }

    override fun requestConnectionPriority(hashCode: Long, connectionPriority: Long): Boolean {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        val connectionPriority1 = connectionPriority.toInt()
        return gatt.requestConnectionPriority(connectionPriority1)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setPreferredPhy(hashCode: Long, txPhy: Long, rxPhy: Long, phyOptions: Long) {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        val txPhy1 = txPhy.toInt()
        val rxPhy1 = rxPhy.toInt()
        val phyOptions1 = phyOptions.toInt()
        return gatt.setPreferredPhy(txPhy1, rxPhy1, phyOptions1)
    }

    override fun getConnectionState(hashCode: Long, deviceHashCode: Long): Long {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        val device = instanceManager.valueOf(deviceHashCode) as BluetoothDevice
        return gatt.getConnectionState(device).toLong()
    }

    override fun getDevicesMatchingConnectionStates(hashCode: Long, states: List<Long>): List<Long> {
        val gatt = instanceManager.valueOf(hashCode) as BluetoothGatt
        val states1 = states.map { state -> state.toInt() }.toIntArray()
        return gatt.getDevicesMatchingConnectionStates(states1).map { device -> instanceManager.allocate(device) }
    }
}