package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api

object MyPeripheralHostApi : Api.PeripheralHostApi {
    override fun allocate(id: Long, instanceId: Long) {
        val gatt = instances.remove(instanceId) as BluetoothGatt
        instances[id] = gatt
        identifiers[gatt] = id
    }

    override fun free(id: Long) {
        val gatt = instances.remove(id) as BluetoothGatt
        identifiers.remove(gatt)
    }

    override fun disconnect(id: Long, result: Api.Result<Void>) {
        val gatt = instances[id] as BluetoothGatt
        gatt.disconnect()
        items["${gatt.hashCode()}/$KEY_DISCONNECT_RESULT"] = result
    }

    override fun discoverServices(id: Long, result: Api.Result<MutableList<ByteArray>>) {
        val gatt = instances[id] as BluetoothGatt
        val started = gatt.discoverServices()
        if (started) {
            items["${gatt.hashCode()}/$KEY_DISCOVER_SERVICES_RESULT"] = result
        } else {
            val error = BluetoothLowEnergyException("Start discover services failed.")
            result.error(error)
        }
    }
}
