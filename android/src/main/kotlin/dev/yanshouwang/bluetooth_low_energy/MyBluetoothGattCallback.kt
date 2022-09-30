package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.*
import android.util.Log
import dev.yanshouwang.bluetooth_low_energy.pigeon.Messages as Pigeon
import dev.yanshouwang.bluetooth_low_energy.proto.gattService
import dev.yanshouwang.bluetooth_low_energy.proto.uUID

// TODO: Clear results when connection state changed or central manager state changed.

object MyBluetoothGattCallback : BluetoothGattCallback() {
    override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
        super.onConnectionStateChange(gatt, status, newState)
        Log.d(TAG, "onConnectionStateChange: $gatt, $status, $newState")
        val id = gatt.device.hashCode().toString()
        if (status == BluetoothGatt.GATT_SUCCESS) {
            if (newState == BluetoothProfile.STATE_CONNECTED) {
                // Must be connected.
                val result = instances.remove("$id/$KEY_CONNECT_RESULT") as Pigeon.Result<Void>
                result.success(null)
            } else {
                // Must be disconnected.
                gatt.close()
                val result = instances.remove("$id/$KEY_DISCONNECT_RESULT") as Pigeon.Result<Void>
                result.success(null)
            }
        } else {
            gatt.close()
            val result = instances.remove("$id/$KEY_CONNECT_RESULT") as Pigeon.Result<Void>?
            if (result == null) {
                // Connection lost.
                val errorMessage = "GATT error with status: $status."
                mainExecutor.execute {
                    peripheralFlutterApi.onConnectionLost(id, errorMessage) {}
                }
            } else {
                // Connect failed.
                val error = BluetoothLowEnergyException("GATT error with status: $status.")
                result.error(error)
            }
        }
    }

    override fun onMtuChanged(gatt: BluetoothGatt, mtu: Int, status: Int) {
        super.onMtuChanged(gatt, mtu, status)
        Log.d(TAG, "onMtuChanged: $gatt, $mtu, $status")
        val id = gatt.device.hashCode().toString()
        // Maybe triggered in response to a connection event.
        val result = instances.remove("$id/$KEY_REQUEST_MTU_RESULT") as Pigeon.Result<Long>? ?: return
        when (status) {
            BluetoothGatt.GATT_SUCCESS -> {
                val maximumWriteLength = (mtu - 3).toLong()
                result.success(maximumWriteLength)
            }
            else -> {
                val error = BluetoothLowEnergyException("GATT request MTU failed with status: $status")
                result.error(error)
            }
        }
    }

    override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
        super.onServicesDiscovered(gatt, status)
        Log.d(TAG, "onServicesDiscovered: $gatt, $status")
        val id = gatt.device.hashCode().toString()
        val result = instances.remove("$id/$KEY_DISCOVER_SERVICES_RESULT") as Pigeon.Result<MutableList<ByteArray>>
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val serviceValues = mutableListOf<ByteArray>()
            for (service in gatt.services) {
                val serviceValue = registerService(gatt, service)
                serviceValues.add(serviceValue)
            }
            result.success(serviceValues)
        } else {
            val error = BluetoothLowEnergyException("GATT discover services failed with status: $status")
            result.error(error)
        }
    }

    private fun registerService(gatt: BluetoothGatt, service: BluetoothGattService): ByteArray {
        val id = service.hashCode().toString()
        val items = register(id)
        items[KEY_GATT] = gatt
        items[KEY_SERVICE] = service
        return gattService {
            this.id = id
            this.uuid = uUID {
                this.value = service.uuid.toString()
            }
        }.toByteArray()
    }

    override fun onCharacteristicRead(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int) {
        super.onCharacteristicRead(gatt, characteristic, status)
        Log.d(TAG, "onCharacteristicRead: $gatt, $characteristic, $status")
        val id = characteristic.hashCode().toString()
        val result = instances.remove("$id/$KEY_READ_RESULT") as Pigeon.Result<ByteArray>
        if (status == BluetoothGatt.GATT_SUCCESS) {
            result.success(characteristic.value)
        } else {
            val error = BluetoothLowEnergyException("GATT read characteristic failed with status: $status.")
            result.error(error)
        }
    }

    override fun onCharacteristicWrite(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int) {
        super.onCharacteristicWrite(gatt, characteristic, status)
        Log.d(TAG, "onCharacteristicWrite: $gatt, $characteristic, $status")
        val id = characteristic.hashCode().toString()
        val result = instances.remove("$id/$KEY_WRITE_RESULT") as Pigeon.Result<Void>
        if (status == BluetoothGatt.GATT_SUCCESS) {
            result.success(null)
        } else {
            val error = BluetoothLowEnergyException("GATT write characteristic failed with status: $status.")
            result.error(error)
        }
    }

    override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic) {
        super.onCharacteristicChanged(gatt, characteristic)
        Log.d(TAG, "onCharacteristicChanged: $gatt, $characteristic")
        val id = characteristic.hashCode().toString()
        val value = characteristic.value
        mainExecutor.execute {
            characteristicFlutterApi.onValueChanged(id, value) {}
        }
    }

    override fun onDescriptorRead(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
        super.onDescriptorRead(gatt, descriptor, status)
        Log.d(TAG, "onDescriptorRead: $gatt, $descriptor, $status")
        val id = descriptor.hashCode().toString()
        val result = instances.remove("$id/$KEY_READ_RESULT") as Pigeon.Result<ByteArray>
        if (status == BluetoothGatt.GATT_SUCCESS) {
            result.success(descriptor.value)
        } else {
            val error = BluetoothLowEnergyException("GATT read descriptor failed with status: $status.")
            result.error(error)
        }
    }

    override fun onDescriptorWrite(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
        super.onDescriptorWrite(gatt, descriptor, status)
        Log.d(TAG, "onDescriptorWrite: $gatt, $descriptor, $status")
        val id = descriptor.hashCode().toString()
        val result = instances.remove("$id/$KEY_WRITE_RESULT") as Pigeon.Result<Void>
        if (status == BluetoothGatt.GATT_SUCCESS) {
            result.success(null)
        } else {
            val error = BluetoothLowEnergyException("GATT write descriptor failed with status: $status.")
            result.error(error)
        }
    }

    override fun onPhyRead(gatt: BluetoothGatt, txPhy: Int, rxPhy: Int, status: Int) {
        super.onPhyRead(gatt, txPhy, rxPhy, status)
        Log.d(TAG, "onPhyRead: $gatt, $txPhy, $rxPhy, $status")
    }

    override fun onPhyUpdate(gatt: BluetoothGatt, txPhy: Int, rxPhy: Int, status: Int) {
        super.onPhyUpdate(gatt, txPhy, rxPhy, status)
        Log.d(TAG, "onPhyUpdate: $gatt, $txPhy, $rxPhy, $status")
    }

    override fun onReadRemoteRssi(gatt: BluetoothGatt, rssi: Int, status: Int) {
        super.onReadRemoteRssi(gatt, rssi, status)
        Log.d(TAG, "onReadRemoteRssi: $gatt, $rssi, $status")
    }

    override fun onReliableWriteCompleted(gatt: BluetoothGatt, status: Int) {
        super.onReliableWriteCompleted(gatt, status)
        Log.d(TAG, "onReliableWriteCompleted: $gatt, $status")
    }

    override fun onServiceChanged(gatt: BluetoothGatt) {
        super.onServiceChanged(gatt)
        Log.d(TAG, "onServiceChanged: $gatt")
    }
}
