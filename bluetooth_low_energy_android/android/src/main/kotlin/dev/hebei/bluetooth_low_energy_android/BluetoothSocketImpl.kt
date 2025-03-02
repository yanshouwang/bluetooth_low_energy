package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import java.io.InputStream
import java.io.OutputStream

class BluetoothSocketImpl(registrar: BluetoothLowEnergyPigeonProxyApiRegistrar) : PigeonApiBluetoothSocket(registrar) {
    override fun close(pigeon_instance: BluetoothSocket) {
        pigeon_instance.close()
    }

    override fun connect(pigeon_instance: BluetoothSocket) {
        pigeon_instance.connect()
    }

    override fun getConnectionType(pigeon_instance: BluetoothSocket): Long {
        return pigeon_instance.connectionType.toLong()
    }

    override fun getInputStream(pigeon_instance: BluetoothSocket): InputStream {
        return pigeon_instance.inputStream
    }

    override fun getMaxReceivePacketSize(pigeon_instance: BluetoothSocket): Long {
        return pigeon_instance.maxReceivePacketSize.toLong()
    }

    override fun getMaxTransmitPacketSize(pigeon_instance: BluetoothSocket): Long {
        return pigeon_instance.maxTransmitPacketSize.toLong()
    }

    override fun getOutputStream(pigeon_instance: BluetoothSocket): OutputStream {
        return pigeon_instance.outputStream
    }

    override fun getRemoteDevice(pigeon_instance: BluetoothSocket): BluetoothDevice {
        return pigeon_instance.remoteDevice
    }

    override fun isConnected(pigeon_instance: BluetoothSocket): Boolean {
        return pigeon_instance.isConnected
    }
}