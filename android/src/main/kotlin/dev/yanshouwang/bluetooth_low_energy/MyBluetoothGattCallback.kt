package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.*
import android.bluetooth.BluetoothGattCallback
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api
import dev.yanshouwang.bluetooth_low_energy.proto.bluetoothLowEnergyException
import dev.yanshouwang.bluetooth_low_energy.proto.gattService
import dev.yanshouwang.bluetooth_low_energy.proto.peripheral
import dev.yanshouwang.bluetooth_low_energy.proto.uUID

object MyBluetoothGattCallback : BluetoothGattCallback() {
    override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
        super.onConnectionStateChange(gatt, status, newState)
        if (status == BluetoothGatt.GATT_SUCCESS) {
            if (newState == BluetoothProfile.STATE_CONNECTED) {
                // Connect succeed.
                val requested = gatt.requestMtu(512)
                if (!requested) {
                    gatt.disconnect()
                }
            } else {
                // Maybe disconnect succeed, connection failed or connection lost.
                gatt.close()
                val connectResult = items.remove("${gatt.hashCode()}/${KEY_CONNECT_RESULT}") as Api.Result<ByteArray>?
                if (connectResult == null) {
                    val disconnectResult = items.remove("${gatt.hashCode()}/${KEY_DISCONNECT_RESULT}") as Api.Result<Void>?
                    if (disconnectResult == null) {
                        val id = identifiers[gatt] as Long
                        val errorBuffer = bluetoothLowEnergyException {
                            this.message = "GATT connection lost."
                        }.toByteArray()
                        mainExecutor.execute {
                            peripheralFlutterApi.notifyConnectionLost(id, errorBuffer) {}
                        }
                    } else {
                        disconnectResult.success(null)
                    }
                } else {
                    val errorMessage = "GATT connection lost."
                    val error = BluetoothLowEnergyException(errorMessage)
                    connectResult.error(error)
                }
            }
        } else {
            // Maybe connect failed, disconnect failed or connection lost.
            gatt.close()
            val connectResult = items.remove("${gatt.hashCode()}/${KEY_CONNECT_RESULT}") as Api.Result<ByteArray>?
            if (connectResult == null) {
                val disconnectResult = items.remove("${gatt.hashCode()}/${KEY_DISCONNECT_RESULT}") as Api.Result<Void>?
                if (disconnectResult == null) {
                    val id = identifiers[gatt] as Long
                    val errorBuffer = bluetoothLowEnergyException {
                        this.message = "GATT error with status: $status"
                    }.toByteArray()
                    mainExecutor.execute {
                        peripheralFlutterApi.notifyConnectionLost(id, errorBuffer) {}
                    }
                } else {
                    val error = BluetoothLowEnergyException("GATT error with status: $status")
                    disconnectResult.error(error)
                }
            } else {
                val error = BluetoothLowEnergyException("GATT error with status: $status")
                connectResult.error(error)
            }
        }
    }

    override fun onMtuChanged(gatt: BluetoothGatt, mtu: Int, status: Int) {
        super.onMtuChanged(gatt, mtu, status)
        when (status) {
            BluetoothGatt.GATT_SUCCESS -> {
                val connectResult = items.remove("${gatt.hashCode()}/${KEY_CONNECT_RESULT}") as Api.Result<ByteArray>
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
        val result = items.remove("${gatt.hashCode()}/${KEY_DISCOVER_SERVICES_RESULT}") as Api.Result<MutableList<ByteArray>>
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
        val result = items.remove("${characteristic.hashCode()}/${KEY_READ_RESULT}") as Api.Result<ByteArray>
        if (status == BluetoothGatt.GATT_SUCCESS) {
            result.success(characteristic.value)
        } else {
            val error = BluetoothLowEnergyException("GATT read characteristic failed with status: $status.")
            result.error(error)
        }
    }

    override fun onCharacteristicWrite(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int) {
        super.onCharacteristicWrite(gatt, characteristic, status)
        val result = items.remove("${characteristic.hashCode()}/${KEY_WRITE_RESULT}") as Api.Result<Void>
        if (status == BluetoothGatt.GATT_SUCCESS) {
            result.success(null)
        } else {
            val error = BluetoothLowEnergyException("GATT write characteristic failed with status: $status.")
            result.error(error)
        }
    }

    override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic) {
        super.onCharacteristicChanged(gatt, characteristic)
        val id = identifiers[characteristic] as Long
        val value = characteristic.value
        mainExecutor.execute {
            characteristicFlutterApi.notifyValue(id, value) {}
        }
    }

    override fun onDescriptorRead(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
        super.onDescriptorRead(gatt, descriptor, status)
        val result = items.remove("${descriptor.hashCode()}/${KEY_READ_RESULT}") as Api.Result<ByteArray>
        if (status == BluetoothGatt.GATT_SUCCESS) {
            result.success(descriptor.value)
        } else {
            val error = BluetoothLowEnergyException("GATT read descriptor failed with status: $status.")
            result.error(error)
        }
    }

    override fun onDescriptorWrite(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
        super.onDescriptorWrite(gatt, descriptor, status)
        val result = items.remove("${descriptor.hashCode()}/${KEY_WRITE_RESULT}") as Api.Result<Void>
        if (status == BluetoothGatt.GATT_SUCCESS) {
            result.success(null)
        } else {
            val error = BluetoothLowEnergyException("GATT write descriptor failed with status: $status.")
            result.error(error)
        }
    }
}
