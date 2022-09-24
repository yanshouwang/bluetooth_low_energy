package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.*
import android.bluetooth.BluetoothGattCallback
import android.util.Log
import dev.yanshouwang.bluetooth_low_energy.pigeon.Messages as Messages
import dev.yanshouwang.bluetooth_low_energy.proto.gattService
import dev.yanshouwang.bluetooth_low_energy.proto.peripheral
import dev.yanshouwang.bluetooth_low_energy.proto.uUID

// TODO: Clear results when connection state changed or central manager state changed.

object MyBluetoothGattCallback : BluetoothGattCallback() {
    override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
        super.onConnectionStateChange(gatt, status, newState)
        Log.d(TAG, "onConnectionStateChange: $status, $newState")
        if (status == BluetoothGatt.GATT_SUCCESS) {
            if (newState == BluetoothProfile.STATE_CONNECTED) {
                // Connect succeed.
                val mtu = 512
                Log.d(TAG, "requestMtu: $mtu")
                val succeed = gatt.requestMtu(mtu)
                if (!succeed) {
                    gatt.disconnect()
                }
            } else {
                // Maybe disconnect succeed, connection failed or connection lost.
                gatt.close()
                val connectResult = items.remove("${gatt.hashCode()}/${KEY_CONNECT_RESULT}") as Messages.Result<ByteArray>?
                if (connectResult == null) {
                    val disconnectResult = items.remove("${gatt.hashCode()}/${KEY_DISCONNECT_RESULT}") as Messages.Result<Void>?
                    if (disconnectResult == null) {
                        val id = identifiers[gatt] as Long
                        val errorMessage = "GATT disconnected without error message."
                        mainExecutor.execute {
                            peripheralFlutterApi.notifyConnectionLost(id, errorMessage) {}
                        }
                    } else {
                        disconnectResult.success(null)
                    }
                } else {
                    val errorMessage = "GATT connect failed without error message."
                    val error = BluetoothLowEnergyException(errorMessage)
                    connectResult.error(error)
                }
            }
        } else {
            // Maybe connect failed, disconnect failed or connection lost.
            gatt.close()
            val connectResult = items.remove("${gatt.hashCode()}/${KEY_CONNECT_RESULT}") as Messages.Result<ByteArray>?
            if (connectResult == null) {
                val disconnectResult = items.remove("${gatt.hashCode()}/${KEY_DISCONNECT_RESULT}") as Messages.Result<Void>?
                if (disconnectResult == null) {
                    val id = identifiers[gatt] as Long
                    val errorMessage = "GATT error with status: $status."
                    mainExecutor.execute {
                        peripheralFlutterApi.notifyConnectionLost(id, errorMessage) {}
                    }
                } else {
                    val error = BluetoothLowEnergyException("GATT error with status: $status.")
                    disconnectResult.error(error)
                }
            } else {
                val error = BluetoothLowEnergyException("GATT error with status: $status.")
                connectResult.error(error)
            }
        }
    }

    override fun onMtuChanged(gatt: BluetoothGatt, mtu: Int, status: Int) {
        super.onMtuChanged(gatt, mtu, status)
        Log.d(TAG, "onMtuChanged: $mtu, $status")
        when (status) {
            BluetoothGatt.GATT_SUCCESS -> {
                // Maybe called one or more times after connected.
                val connectResult = items.remove("${gatt.hashCode()}/${KEY_CONNECT_RESULT}") as Messages.Result<ByteArray>? ?: return
                val gattId = gatt.hashCode().toLong()
                instances[gattId] = gatt
                val peripheralValue = peripheral {
                    this.id = gattId
                    this.maximumWriteLength = mtu - 3
                }.toByteArray()
                connectResult.success(peripheralValue)
            }
            else -> {
                gatt.disconnect()
            }
        }
    }

    override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
        super.onServicesDiscovered(gatt, status)
        Log.d(TAG, "onServicesDiscovered: $status")
        val result = items.remove("${gatt.hashCode()}/${KEY_DISCOVER_SERVICES_RESULT}") as Messages.Result<MutableList<ByteArray>>
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val serviceValues = mutableListOf<ByteArray>()
            for (service in gatt.services) {
                val serviceId = service.hashCode().toLong()
                instances[serviceId] = listOf(gatt, service)
                val serviceValue = gattService {
                    this.id = serviceId
                    this.uuid = uUID {
                        this.value = service.uuid.toString()
                    }
                }.toByteArray()
                serviceValues.add(serviceValue)
            }
            result.success(serviceValues)
        } else {
            val error = BluetoothLowEnergyException("GATT discover services failed with status: $status")
            result.error(error)
        }
    }

    override fun onCharacteristicRead(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int) {
        super.onCharacteristicRead(gatt, characteristic, status)
        Log.d(TAG, "onCharacteristicRead: $status")
        val result = items.remove("${characteristic.hashCode()}/${KEY_READ_RESULT}") as Messages.Result<ByteArray>
        if (status == BluetoothGatt.GATT_SUCCESS) {
            result.success(characteristic.value)
        } else {
            val error = BluetoothLowEnergyException("GATT read characteristic failed with status: $status.")
            result.error(error)
        }
    }

    override fun onCharacteristicWrite(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int) {
        super.onCharacteristicWrite(gatt, characteristic, status)
        Log.d(TAG, "onCharacteristicWrite: $status")
        val result = items.remove("${characteristic.hashCode()}/${KEY_WRITE_RESULT}") as Messages.Result<Void>
        if (status == BluetoothGatt.GATT_SUCCESS) {
            result.success(null)
        } else {
            val error = BluetoothLowEnergyException("GATT write characteristic failed with status: $status.")
            result.error(error)
        }
    }

    override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic) {
        super.onCharacteristicChanged(gatt, characteristic)
        Log.d(TAG, "onCharacteristicChanged: $characteristic")
        val id = identifiers[characteristic] as Long
        val value = characteristic.value
        mainExecutor.execute {
            characteristicFlutterApi.notifyValue(id, value) {}
        }
    }

    override fun onDescriptorRead(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
        super.onDescriptorRead(gatt, descriptor, status)
        Log.d(TAG, "onDescriptorRead: $status")
        val result = items.remove("${descriptor.hashCode()}/${KEY_READ_RESULT}") as Messages.Result<ByteArray>
        if (status == BluetoothGatt.GATT_SUCCESS) {
            result.success(descriptor.value)
        } else {
            val error = BluetoothLowEnergyException("GATT read descriptor failed with status: $status.")
            result.error(error)
        }
    }

    override fun onDescriptorWrite(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
        super.onDescriptorWrite(gatt, descriptor, status)
        Log.d(TAG, "onDescriptorWrite: $status")
        val result = items.remove("${descriptor.hashCode()}/${KEY_WRITE_RESULT}") as Messages.Result<Void>
        if (status == BluetoothGatt.GATT_SUCCESS) {
            result.success(null)
        } else {
            val error = BluetoothLowEnergyException("GATT write descriptor failed with status: $status.")
            result.error(error)
        }
    }

    override fun onPhyRead(gatt: BluetoothGatt?, txPhy: Int, rxPhy: Int, status: Int) {
        super.onPhyRead(gatt, txPhy, rxPhy, status)
        Log.d(TAG, "onPhyRead: $txPhy, $txPhy, $status")
    }

    override fun onPhyUpdate(gatt: BluetoothGatt?, txPhy: Int, rxPhy: Int, status: Int) {
        super.onPhyUpdate(gatt, txPhy, rxPhy, status)
        Log.d(TAG, "onPhyUpdate: $txPhy, $rxPhy, $status")
    }

    override fun onReadRemoteRssi(gatt: BluetoothGatt?, rssi: Int, status: Int) {
        super.onReadRemoteRssi(gatt, rssi, status)
        Log.d(TAG, "onReadRemoteRssi: $rssi, $status")
    }

    override fun onReliableWriteCompleted(gatt: BluetoothGatt?, status: Int) {
        super.onReliableWriteCompleted(gatt, status)
        Log.d(TAG, "onReliableWriteCompleted: $status")
    }

    override fun onServiceChanged(gatt: BluetoothGatt) {
        super.onServiceChanged(gatt)
        Log.d(TAG, "onServiceChanged: $gatt")
    }
}
