package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.*
import java.util.*

class BluetoothGattImpl(registrar: BluetoothLowEnergyPigeonProxyApiRegistrar) : PigeonApiBluetoothGatt(registrar) {
    override fun abortReliableWrite(pigeon_instance: BluetoothGatt) {
        pigeon_instance.abortReliableWrite()
    }

    override fun beginReliableWrite(pigeon_instance: BluetoothGatt): Boolean {
        return pigeon_instance.beginReliableWrite()
    }

    override fun close(pigeon_instance: BluetoothGatt) {
        pigeon_instance.close()
    }

    override fun connect(pigeon_instance: BluetoothGatt): Boolean {
        return pigeon_instance.connect()
    }

    override fun disconnect(pigeon_instance: BluetoothGatt) {
        pigeon_instance.disconnect()
    }

    override fun discoverServices(pigeon_instance: BluetoothGatt): Boolean {
        return pigeon_instance.discoverServices()
    }

    override fun executeReliableWrite(pigeon_instance: BluetoothGatt): Boolean {
        return pigeon_instance.executeReliableWrite()
    }

    override fun getDevice(pigeon_instance: BluetoothGatt): BluetoothDevice {
        return pigeon_instance.device
    }

    override fun getService(pigeon_instance: BluetoothGatt, uuid: UUID): BluetoothGattService {
        return pigeon_instance.getService(uuid)
    }

    override fun getServices(pigeon_instance: BluetoothGatt): List<BluetoothGattService> {
        return pigeon_instance.services
    }

    override fun readCharacteristic(
        pigeon_instance: BluetoothGatt, characteristic: BluetoothGattCharacteristic
    ): Boolean {
        return pigeon_instance.readCharacteristic(characteristic)
    }

    override fun readDescriptor(pigeon_instance: BluetoothGatt, descriptor: BluetoothGattDescriptor): Boolean {
        return pigeon_instance.readDescriptor(descriptor)
    }

    override fun readPhy(pigeon_instance: BluetoothGatt) {
        pigeon_instance.readPhy()
    }

    override fun readRemoteRssi(pigeon_instance: BluetoothGatt): Boolean {
        return pigeon_instance.readRemoteRssi()
    }

    override fun requestConnectionPriority(pigeon_instance: BluetoothGatt, connectionPriority: Long): Boolean {
        return pigeon_instance.requestConnectionPriority(connectionPriority.toInt())
    }

    override fun requestMtu(pigeon_instance: BluetoothGatt, mtu: Long): Boolean {
        return pigeon_instance.requestMtu(mtu.toInt())
    }

    override fun setCharacteristicNotification(
        pigeon_instance: BluetoothGatt, characteristic: BluetoothGattCharacteristic, enable: Boolean
    ): Boolean {
        return pigeon_instance.setCharacteristicNotification(characteristic, enable)
    }

    override fun setPreferredPhy(pigeon_instance: BluetoothGatt, txPhy: Long, rxPhy: Long, phyOptions: Long) {
        pigeon_instance.setPreferredPhy(rxPhy.toInt(), rxPhy.toInt(), phyOptions.toInt())
    }

    override fun writeCharacteristic1(
        pigeon_instance: BluetoothGatt, characteristic: BluetoothGattCharacteristic
    ): Boolean {
        return pigeon_instance.writeCharacteristic(characteristic)
    }

    override fun writeCharacteristic2(
        pigeon_instance: BluetoothGatt, characteristic: BluetoothGattCharacteristic, value: ByteArray, writeType: Long
    ): Long {
        return pigeon_instance.writeCharacteristic(characteristic, value, writeType.toInt()).toLong()
    }

    override fun writeDescriptor1(pigeon_instance: BluetoothGatt, descriptor: BluetoothGattDescriptor): Boolean {
        return pigeon_instance.writeDescriptor(descriptor)
    }

    override fun writeDescriptor2(
        pigeon_instance: BluetoothGatt, descriptor: BluetoothGattDescriptor, value: ByteArray
    ): Long {
        return pigeon_instance.writeDescriptor(descriptor, value).toLong()
    }
}