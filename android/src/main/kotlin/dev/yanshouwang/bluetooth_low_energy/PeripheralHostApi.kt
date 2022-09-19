package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api

object PeripheralHostApi : Api.PeripheralHostApi {
    const val KEY_DISCONNECT_RESULT = "DISCONNECT_RESULT"
    const val KEY_DISCOVER_SERVICES_RESULT = "DISCOVER_SERVICES_RESULT"

    override fun allocate(newId: String, oldId: String) {
        val instance = instances.freeNotNull<Any>(oldId)
        instances[newId] = instance
        ids[instance] = newId
    }

    override fun free(id: String) {
        val instance = instances.freeNotNull<Any>(id)
        ids.remove(instance)
    }

    override fun disconnect(id: String, result: Api.Result<Void>) {
        val gatt = instances.findNotNull<BluetoothGatt>(id)
        gatt.disconnect()
        instances["${gatt.id}/$KEY_DISCONNECT_RESULT"] = result
    }

    override fun discoverServices(id: String, result: Api.Result<MutableList<ByteArray>>) {
        val gatt = instances.findNotNull<BluetoothGatt>(id)
        val started = gatt.discoverServices()
        if (started) {
            instances["${gatt.id}/$KEY_DISCOVER_SERVICES_RESULT"] = result
        } else {
            val error = Throwable("Start discover services failed.")
            result.error(error)
        }
    }
}
