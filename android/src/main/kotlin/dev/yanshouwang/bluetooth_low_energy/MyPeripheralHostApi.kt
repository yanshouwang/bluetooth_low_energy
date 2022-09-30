package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.os.Build
import android.util.Log
import dev.yanshouwang.bluetooth_low_energy.pigeon.Messages as Pigeon

object MyPeripheralHostApi : Pigeon.PeripheralHostApi {
    override fun free(id: String) {
        Log.d(TAG, "free: $id")
        unregister(id)
    }

    override fun connect(id: String, result: Pigeon.Result<Void>) {
        Log.d(TAG, "connect: $id")
        val items = instances[id] as MutableMap<String, Any>
        val device = items[KEY_DEVICE] as BluetoothDevice
        val autoConnect = false
        val gatt = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val transport = BluetoothDevice.TRANSPORT_LE
            device.connectGatt(activity, autoConnect, MyBluetoothGattCallback, transport)
        } else {
            device.connectGatt(activity, autoConnect, MyBluetoothGattCallback)
        }
        items[KEY_GATT] = gatt
        instances["$id/$KEY_CONNECT_RESULT"] = result
    }

    override fun disconnect(id: String, result: Pigeon.Result<Void>) {
        Log.d(TAG, "disconnect: $id")
        val items = instances[id] as MutableMap<String, Any>
        val gatt = items[KEY_GATT] as BluetoothGatt
        gatt.disconnect()
        instances["$id/$KEY_DISCONNECT_RESULT"] = result
    }

    override fun requestMtu(id: String, result: Pigeon.Result<Long>) {
        Log.d(TAG, "requestMtu: $id")
        val items = instances[id] as MutableMap<String, Any>
        val gatt = items[KEY_GATT] as BluetoothGatt
        val succeed = gatt.requestMtu(512)
        if (succeed) {
            instances["$id/$KEY_REQUEST_MTU_RESULT"] = result
        } else {
            val error = BluetoothLowEnergyException("GATT request MTU failed.")
            result.error(error)
        }
    }

    override fun discoverServices(id: String, result: Pigeon.Result<MutableList<ByteArray>>) {
        Log.d(TAG, "discoverServices: $id")
        val items = instances[id] as MutableMap<String, Any>
        val gatt = items[KEY_GATT] as BluetoothGatt
        val succeed = gatt.discoverServices()
        if (succeed) {
            instances["$id/$KEY_DISCOVER_SERVICES_RESULT"] = result
        } else {
            val error = BluetoothLowEnergyException("GATT discover services failed.")
            result.error(error)
        }
    }
}
