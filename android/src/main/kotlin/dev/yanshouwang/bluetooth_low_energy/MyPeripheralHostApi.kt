package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.util.Log
import dev.yanshouwang.bluetooth_low_energy.pigeon.Messages as Pigeon

object MyPeripheralHostApi : Pigeon.PeripheralHostApi {
    override fun allocate(id: Long, instanceId: Long) {
        Log.d(TAG, "allocate: $id, $instanceId")
        val gatt = instances.remove(instanceId) as BluetoothGatt
        instances[id] = gatt
        identifiers[gatt] = id
    }

    override fun free(id: Long) {
        Log.d(TAG, "free: $id")
        val gatt = instances.remove(id) as BluetoothGatt
        identifiers.remove(gatt)
    }

    override fun disconnect(id: Long, result: Pigeon.Result<Void>) {
        Log.d(TAG, "disconnect: $id")
        val gatt = instances[id] as BluetoothGatt
        gatt.disconnect()
        items["${gatt.hashCode()}/$KEY_DISCONNECT_RESULT"] = result
    }

    override fun discoverServices(id: Long, result: Pigeon.Result<MutableList<ByteArray>>) {
        Log.d(TAG, "discoverServices: $id")
        val gatt = instances[id] as BluetoothGatt
        val succeed = gatt.discoverServices()
        if (succeed) {
            items["${gatt.hashCode()}/$KEY_DISCOVER_SERVICES_RESULT"] = result
        } else {
            val error = BluetoothLowEnergyException("Start discover services failed.")
            result.error(error)
        }
    }
}
