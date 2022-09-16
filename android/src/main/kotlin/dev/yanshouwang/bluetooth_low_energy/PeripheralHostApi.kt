package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api

object PeripheralHostApi : Api.PeripheralHostApi {
    const val KEY_DISCONNECT_RESULT = "disconnect-result"
    const val KEY_DISCOVER_SERVICES = "discover-services"

    override fun allocate(newId: String, oldId: String) {
        instances[newId] = instances.remove(oldId) as BluetoothGatt
    }

    override fun free(id: String) {
        instances.remove(id)
    }

    override fun disconnect(id: String, result: Api.Result<Void>) {
        val gatt = instances[id] as BluetoothGatt
        gatt.disconnect()
        instances["${gatt.id}/$KEY_DISCONNECT_RESULT"] = result
    }

    override fun discoverServices(id: String, result: Api.Result<MutableList<ByteArray>>) {
        val gatt = instances[id] as BluetoothGatt
        val started = gatt.discoverServices()
        if (started) {
            instances["${gatt.id}/$KEY_DISCOVER_SERVICES"] = result
        } else {
            val error = Throwable("Start discover services failed.")
            result.error(error)
        }
    }
}
