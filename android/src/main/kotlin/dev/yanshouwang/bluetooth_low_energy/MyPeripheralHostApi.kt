package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api

object MyPeripheralHostApi : Api.PeripheralHostApi {
    const val KEY_DISCONNECT_RESULT = "DISCONNECT_RESULT"
    const val KEY_DISCOVER_SERVICES_RESULT = "DISCOVER_SERVICES_RESULT"

    override fun allocate(id: Long, instanceId: Long) {
        val instance = instances.remove(instanceId) as BluetoothGatt
        instances[id] = instance
        identifiers[instance] = id
    }

    override fun free(id: Long) {
        val instance = instances.remove(id) as BluetoothGatt
        identifiers.remove(instance)
    }

    override fun disconnect(id: Long, result: Api.Result<Void>) {
        val instance = instances[id] as BluetoothGatt
        instance.disconnect()
        items["${instance.hashCode()}/$KEY_DISCONNECT_RESULT"] = result
    }

    override fun discoverServices(id: Long, result: Api.Result<MutableList<ByteArray>>) {
        val instance = instances[id] as BluetoothGatt
        val started = instance.discoverServices()
        if (started) {
            items["${instance.hashCode()}/$KEY_DISCOVER_SERVICES_RESULT"] = result
        } else {
            val error = Throwable("Start discover services failed.")
            result.error(error)
        }
    }
}
