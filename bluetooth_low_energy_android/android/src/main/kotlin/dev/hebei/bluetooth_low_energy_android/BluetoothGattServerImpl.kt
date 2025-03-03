package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattServer
import android.bluetooth.BluetoothGattService
import android.os.Build
import androidx.annotation.RequiresApi
import java.util.*

class BluetoothGattServerImpl(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiBluetoothGattServer(registrar) {
    override fun addService(pigeon_instance: BluetoothGattServer, service: BluetoothGattService): Boolean {
        return pigeon_instance.addService(service)
    }

    override fun cancelConnection(pigeon_instance: BluetoothGattServer, device: BluetoothDevice) {
        pigeon_instance.cancelConnection(device)
    }

    override fun clearServices(pigeon_instance: BluetoothGattServer) {
        pigeon_instance.clearServices()
    }

    override fun close(pigeon_instance: BluetoothGattServer) {
        pigeon_instance.close()
    }

    override fun connect(pigeon_instance: BluetoothGattServer, device: BluetoothDevice, autoConnect: Boolean): Boolean {
        return pigeon_instance.connect(device, autoConnect)
    }

    override fun getService(pigeon_instance: BluetoothGattServer, uuid: UUID): BluetoothGattService {
        return pigeon_instance.getService(uuid)
    }

    override fun getServices(pigeon_instance: BluetoothGattServer): List<BluetoothGattService> {
        return pigeon_instance.services
    }

    override fun notifyCharacteristicChanged(
        pigeon_instance: BluetoothGattServer,
        device: BluetoothDevice,
        characteristic: BluetoothGattCharacteristic,
        confirm: Boolean,
        value: ByteArray
    ): BluetoothStatusCodesArgs {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            pigeon_instance.notifyCharacteristicChanged(device, characteristic, confirm, value).bluetoothStatusCodesArgs
        } else {
            characteristic.value = value
            val notifying = pigeon_instance.notifyCharacteristicChanged(device, characteristic, confirm)
            if (notifying) BluetoothStatusCodesArgs.SUCCESS
            else BluetoothStatusCodesArgs.ERROR_UNKNOWN
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun readPhy(pigeon_instance: BluetoothGattServer, device: BluetoothDevice) {
        pigeon_instance.readPhy(device)
    }

    override fun removeService(pigeon_instance: BluetoothGattServer, service: BluetoothGattService): Boolean {
        return pigeon_instance.removeService(service)
    }

    override fun sendResponse(
        pigeon_instance: BluetoothGattServer,
        device: BluetoothDevice,
        requestId: Long,
        status: Long,
        offset: Long,
        value: ByteArray
    ): Boolean {
        return pigeon_instance.sendResponse(device, requestId.toInt(), status.toInt(), offset.toInt(), value)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setPreferredPhy(
        pigeon_instance: BluetoothGattServer, device: BluetoothDevice, txPhy: Long, rxPhy: Long, phyOptions: Long
    ) {
        pigeon_instance.setPreferredPhy(device, txPhy.toInt(), rxPhy.toInt(), phyOptions.toInt())
    }
}