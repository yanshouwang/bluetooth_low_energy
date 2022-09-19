package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api

object PeripheralHostApi : Api.PeripheralHostApi {
    const val KEY_DISCONNECT_RESULT = "DISCONNECT_RESULT"
    const val KEY_DISCOVER_SERVICES_RESULT = "DISCOVER_SERVICES_RESULT"

    override fun allocate(newId: String, oldId: String) {
        InstanceManager[newId] = InstanceManager.freeNotNull(oldId)
    }

    override fun free(id: String) {
        InstanceManager.remove(id)
    }

    override fun disconnect(id: String, result: Api.Result<Void>) {
        val gatt = InstanceManager.findNotNull<BluetoothGatt>(id)
        gatt.disconnect()
        InstanceManager["${gatt.id}/$KEY_DISCONNECT_RESULT"] = result
    }

    override fun discoverServices(id: String, result: Api.Result<MutableList<ByteArray>>) {
        val gatt = InstanceManager.findNotNull<BluetoothGatt>(id)
        val started = gatt.discoverServices()
        if (started) {
            InstanceManager["${gatt.id}/$KEY_DISCOVER_SERVICES_RESULT"] = result
        } else {
            val error = Throwable("Start discover services failed.")
            result.error(error)
        }
    }
}
