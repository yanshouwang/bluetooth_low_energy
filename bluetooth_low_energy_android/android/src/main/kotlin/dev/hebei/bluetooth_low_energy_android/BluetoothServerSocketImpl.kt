package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothServerSocket
import android.bluetooth.BluetoothSocket
import android.os.Build
import androidx.annotation.RequiresApi

class BluetoothServerSocketImpl(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiBluetoothServerSocket(registrar) {
    override fun accept1(pigeon_instance: BluetoothServerSocket): BluetoothSocket {
        return pigeon_instance.accept()
    }

    override fun accept2(pigeon_instance: BluetoothServerSocket, timeout: Long): BluetoothSocket {
        return pigeon_instance.accept(timeout.toInt())
    }

    override fun close(pigeon_instance: BluetoothServerSocket) {
        pigeon_instance.close()
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun getPsm(pigeon_instance: BluetoothServerSocket): Long {
        return pigeon_instance.psm.toLong()
    }
}