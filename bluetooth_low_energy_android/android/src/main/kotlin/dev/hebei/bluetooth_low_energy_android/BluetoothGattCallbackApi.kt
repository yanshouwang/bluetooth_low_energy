package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.os.Build

class BluetoothGattCallbackApi(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiBluetoothGattCallback(registrar) {
    override fun pigeon_defaultConstructor(): BluetoothGattCallback {
        return object : BluetoothGattCallback() {
            @Deprecated("Deprecated in Java")
            override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic) {
                super.onCharacteristicChanged(gatt, characteristic)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    return
                }
                val value = characteristic.value
                this@BluetoothGattCallbackApi.onCharacteristicChanged(this, gatt, characteristic, value) {}
            }

            override fun onCharacteristicChanged(
                gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, value: ByteArray
            ) {
                super.onCharacteristicChanged(gatt, characteristic, value)
                this@BluetoothGattCallbackApi.onCharacteristicChanged(this, gatt, characteristic, value) {}
            }

            @Deprecated("Deprecated in Java")
            override fun onCharacteristicRead(
                gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int
            ) {
                super.onCharacteristicRead(gatt, characteristic, status)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    return
                }
                val value = characteristic.value
                this@BluetoothGattCallbackApi.onCharacteristicRead(
                    this, gatt, characteristic, value, status.toLong()
                ) {}
            }

            override fun onCharacteristicRead(
                gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, value: ByteArray, status: Int
            ) {
                super.onCharacteristicRead(gatt, characteristic, value, status)
                this@BluetoothGattCallbackApi.onCharacteristicRead(
                    this, gatt, characteristic, value, status.toLong()
                ) {}
            }

            override fun onCharacteristicWrite(
                gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int
            ) {
                super.onCharacteristicWrite(gatt, characteristic, status)
                this@BluetoothGattCallbackApi.onCharacteristicWrite(this, gatt, characteristic, status.toLong()) {}
            }

            override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
                super.onConnectionStateChange(gatt, status, newState)
                this@BluetoothGattCallbackApi.onConnectionStateChange(
                    this, gatt, status.toLong(), newState.toLong()
                ) {}
            }

            @Deprecated("Deprecated in Java")
            override fun onDescriptorRead(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
                super.onDescriptorRead(gatt, descriptor, status)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    return
                }
                val value = descriptor.value
                this@BluetoothGattCallbackApi.onDescriptorRead(this, gatt, descriptor, status.toLong(), value) {}
            }

            override fun onDescriptorRead(
                gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int, value: ByteArray
            ) {
                super.onDescriptorRead(gatt, descriptor, status, value)
                this@BluetoothGattCallbackApi.onDescriptorRead(this, gatt, descriptor, status.toLong(), value) {}
            }

            override fun onDescriptorWrite(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
                super.onDescriptorWrite(gatt, descriptor, status)
                this@BluetoothGattCallbackApi.onDescriptorWrite(this, gatt, descriptor, status.toLong()) {}
            }

            override fun onMtuChanged(gatt: BluetoothGatt, mtu: Int, status: Int) {
                super.onMtuChanged(gatt, mtu, status)
                this@BluetoothGattCallbackApi.onMtuChanged(this, gatt, mtu.toLong(), status.toLong()) {}
            }

            override fun onPhyRead(gatt: BluetoothGatt, txPhy: Int, rxPhy: Int, status: Int) {
                super.onPhyRead(gatt, txPhy, rxPhy, status)
                this@BluetoothGattCallbackApi.onPhyRead(this, gatt, txPhy.toLong(), rxPhy.toLong(), status.toLong()) {}
            }

            override fun onPhyUpdate(gatt: BluetoothGatt, txPhy: Int, rxPhy: Int, status: Int) {
                super.onPhyUpdate(gatt, txPhy, rxPhy, status)
                this@BluetoothGattCallbackApi.onPhyUpdate(
                    this, gatt, txPhy.toLong(), rxPhy.toLong(), status.toLong()
                ) {}
            }

            override fun onReadRemoteRssi(gatt: BluetoothGatt, rssi: Int, status: Int) {
                super.onReadRemoteRssi(gatt, rssi, status)
                this@BluetoothGattCallbackApi.onReadRemoteRssi(this, gatt, rssi.toLong(), status.toLong()) {}
            }

            override fun onReliableWriteCompleted(gatt: BluetoothGatt, status: Int) {
                super.onReliableWriteCompleted(gatt, status)
                this@BluetoothGattCallbackApi.onReliableWriteCompleted(this, gatt, status.toLong()) {}
            }

            override fun onServiceChanged(gatt: BluetoothGatt) {
                super.onServiceChanged(gatt)
                this@BluetoothGattCallbackApi.onServiceChanged(this, gatt) {}
            }

            override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
                super.onServicesDiscovered(gatt, status)
                this@BluetoothGattCallbackApi.onServicesDiscovered(this, gatt, status.toLong()) {}
            }
        }
    }
}