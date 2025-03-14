package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.*
import android.os.Build
import androidx.annotation.RequiresApi
import java.util.*

class BluetoothGattImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
    PigeonApiBluetoothGatt(registrar) {
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

    @RequiresApi(Build.VERSION_CODES.O)
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

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setPreferredPhy(pigeon_instance: BluetoothGatt, txPhy: Long, rxPhy: Long, phyOptions: Long) {
        pigeon_instance.setPreferredPhy(rxPhy.toInt(), rxPhy.toInt(), phyOptions.toInt())
    }

    override fun writeCharacteristic(
        pigeon_instance: BluetoothGatt, characteristic: BluetoothGattCharacteristic, value: ByteArray, writeType: Long
    ): BluetoothStatusCodes {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            pigeon_instance.writeCharacteristic(characteristic, value, writeType.toInt()).bluetoothStatusCodesArgs
        } else {
            characteristic.value = value
            characteristic.writeType = writeType.toInt()
            val writing = pigeon_instance.writeCharacteristic(characteristic)
            if (writing) BluetoothStatusCodes.SUCCESS
            else BluetoothStatusCodes.ERROR_UNKNOWN
        }
    }

    override fun writeDescriptor(
        pigeon_instance: BluetoothGatt, descriptor: BluetoothGattDescriptor, value: ByteArray
    ): BluetoothStatusCodes {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            pigeon_instance.writeDescriptor(descriptor, value).bluetoothStatusCodesArgs
        } else {
            descriptor.value = value
            val writing = pigeon_instance.writeDescriptor(descriptor)
            if (writing) BluetoothStatusCodes.SUCCESS
            else BluetoothStatusCodes.ERROR_UNKNOWN
        }
    }
}

val Int.bluetoothStatusCodesArgs: BluetoothStatusCodes
    get() = when (this) {
        android.bluetooth.BluetoothStatusCodes.ERROR_BLUETOOTH_NOT_ALLOWED -> BluetoothStatusCodes.ERROR_BLUETOOTH_NOT_ALLOWED
        android.bluetooth.BluetoothStatusCodes.ERROR_BLUETOOTH_NOT_ENABLED -> BluetoothStatusCodes.ERROR_BLUETOOTH_NOT_ENABLED
        android.bluetooth.BluetoothStatusCodes.ERROR_DEVICE_NOT_BONDED -> BluetoothStatusCodes.ERROR_DEVICE_NOT_BONDED
        android.bluetooth.BluetoothStatusCodes.ERROR_GATT_WRITE_NOT_ALLOWED -> BluetoothStatusCodes.ERROR_GATT_WRITE_NOT_ALLOWED
        android.bluetooth.BluetoothStatusCodes.ERROR_GATT_WRITE_REQUEST_BUSY -> BluetoothStatusCodes.ERROR_GATT_WRITE_REQUEST_BUSY
        android.bluetooth.BluetoothStatusCodes.ERROR_MISSING_BLUETOOTH_CONNECT_PERMISSION -> BluetoothStatusCodes.ERROR_MISSING_BLUETOOTH_CONNECT_PERMISSION
        android.bluetooth.BluetoothStatusCodes.ERROR_PROFILE_SERVICE_NOT_BOUND -> BluetoothStatusCodes.ERROR_PROFILE_SERVICE_NOT_BOUND
        android.bluetooth.BluetoothStatusCodes.ERROR_UNKNOWN -> BluetoothStatusCodes.ERROR_UNKNOWN
        android.bluetooth.BluetoothStatusCodes.FEATURE_NOT_CONFIGURED -> BluetoothStatusCodes.FEATURE_NOT_CONFIGURED
        android.bluetooth.BluetoothStatusCodes.FEATURE_NOT_SUPPORTED -> BluetoothStatusCodes.FEATURE_NOT_SUPPORTED
        android.bluetooth.BluetoothStatusCodes.FEATURE_SUPPORTED -> BluetoothStatusCodes.FEATURE_SUPPORTED
        android.bluetooth.BluetoothStatusCodes.SUCCESS -> BluetoothStatusCodes.SUCCESS
        else -> BluetoothStatusCodes.ERROR_UNKNOWN
    }