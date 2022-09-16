package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothProfile
import android.util.Log
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api
import dev.yanshouwang.bluetooth_low_energy.proto.peripheral

object BluetoothGattCallback : BluetoothGattCallback() {
    override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
        super.onConnectionStateChange(gatt, status, newState)
        if (status == BluetoothGatt.GATT_SUCCESS) {
            if (newState == BluetoothProfile.STATE_CONNECTED) {
                // Must be connect succeed.
                val requested = gatt.requestMtu(512)
                if (!requested) {
                    gatt.disconnect()
                }
            } else {
                // Maybe disconnect succeed, connection failed or connection lost.
                gatt.close()
                val connectResult =
                    instances.remove<Api.Result<ByteArray>>("${gatt.id}/${CentralManagerHostApi.KEY_CONNECT_RESULT}")
                if (connectResult == null) {
                    val disconnectResult =
                        instances.remove<Api.Result<Void>>("${gatt.id}/${PeripheralHostApi.KEY_DISCONNECT_RESULT}")
                    if (disconnectResult == null) {
                        val id = instances.firstNotNullOf { entry ->
                            return@firstNotNullOf if (entry.value === gatt) {
                                entry.key
                            } else {
                                null
                            }
                        }
                        val errorMessage = "GATT error with status: $status"
                        peripheralFlutterApi.notifyConnectionLost(id, errorMessage) {}
                    } else {
                        disconnectResult.success(null)
                    }
                } else {
                    val errorMessage = "GATT error with status: $status"
                    val error = Throwable(errorMessage)
                    connectResult.error(error)
                }
            }
        } else {
            // Maybe connect failed, disconnect failed or connection lost.
            gatt.close()
            val errorMessage = "GATT error with status: $status"
            val error = Throwable(errorMessage)
            val connectResult =
                instances.remove<Api.Result<ByteArray>>("${gatt.id}/${CentralManagerHostApi.KEY_CONNECT_RESULT}")
            if (connectResult == null) {
                val disconnectResult =
                    instances.remove<Api.Result<Void>>("${gatt.id}/${PeripheralHostApi.KEY_DISCONNECT_RESULT}")
                if (disconnectResult == null) {
                    val id = instances.firstNotNullOf { entry ->
                        return@firstNotNullOf if (entry.value === gatt) {
                            entry.key
                        } else {
                            null
                        }
                    }
                    peripheralFlutterApi.notifyConnectionLost(id, errorMessage) {}
                } else {
                    disconnectResult.error(error)
                }
            } else {
                connectResult.error(error)
            }
        }
    }

    override fun onMtuChanged(gatt: BluetoothGatt, mtu: Int, status: Int) {
        super.onMtuChanged(gatt, mtu, status)
        when (status) {
            BluetoothGatt.GATT_SUCCESS -> {
                val connect = instances.remove<Api.Result<ByteArray>>("${gatt.id}/connect")
                if (connect == null) {
                    Log.e(TAG, "onMtuChanged: Api.Result is not found from the instances.")
                } else {
                    instances[gatt.id] = gatt
                    val peripheralValue = peripheral {
                        this.id = gatt.id
                        this.maximumWriteLength = mtu - 3
                    }.toByteArray()
                    connect.success(peripheralValue)
                }
            }
            else -> {
                gatt.disconnect()
            }
        }
    }
}
