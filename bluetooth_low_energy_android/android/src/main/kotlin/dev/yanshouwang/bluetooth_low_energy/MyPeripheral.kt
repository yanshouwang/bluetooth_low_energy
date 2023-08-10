package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import java.util.UUID

class MyPeripheral(val device: BluetoothDevice, private val instanceManager: MyInstanceManager) : MyObject(device) {
    lateinit var gatt: BluetoothGatt

    fun toArgs(): MyPeripheralArgs {
        val key = hashCode()
        instanceManager.allocate(key, this)
        val hashCode = key.toLong()
        val uuidValue = device.uuid.toString()
        return MyPeripheralArgs(hashCode, uuidValue)
    }
}

private val BluetoothDevice.uuid: UUID
    get() {
        val node = address.filter { char -> char != ':' }
        // We don't know the timestamp of the bluetooth device, use nil UUID as prefix.
        return UUID.fromString("00000000-0000-0000-$node")
    }