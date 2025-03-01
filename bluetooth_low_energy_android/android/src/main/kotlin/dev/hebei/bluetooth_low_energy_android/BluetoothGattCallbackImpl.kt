package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor

class BluetoothGattCallbackImpl(registrar: BluetoothLowEnergyPigeonProxyApiRegistrar) :
    PigeonApiBluetoothGattCallback(registrar) {
    override fun pigeon_defaultConstructor(): BluetoothGattCallback {
        return object : BluetoothGattCallback() {
            override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic) {
                super.onCharacteristicChanged(gatt, characteristic)
                this@BluetoothGattCallbackImpl.onCharacteristicChanged1(this, gatt, characteristic) {}
            }

            override fun onCharacteristicChanged(
                gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, value: ByteArray
            ) {
                super.onCharacteristicChanged(gatt, characteristic, value)
                this@BluetoothGattCallbackImpl.onCharacteristicChanged2(this, gatt, characteristic, value) {}
            }

            override fun onCharacteristicRead(
                gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int
            ) {
                super.onCharacteristicRead(gatt, characteristic, status)
                this@BluetoothGattCallbackImpl.onCharacteristicRead1(this, gatt, characteristic, status.toLong()) {}
            }

            override fun onCharacteristicRead(
                gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, value: ByteArray, status: Int
            ) {
                super.onCharacteristicRead(gatt, characteristic, value, status)
                this@BluetoothGattCallbackImpl.onCharacteristicRead2(
                    this, gatt, characteristic, value, status.toLong()
                ) {}
            }

            override fun onCharacteristicWrite(
                gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int
            ) {
                super.onCharacteristicWrite(gatt, characteristic, status)
                this@BluetoothGattCallbackImpl.onCharacteristicWrite(this, gatt, characteristic, status.toLong()) {}
            }

            override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
                super.onConnectionStateChange(gatt, status, newState)
                this@BluetoothGattCallbackImpl.onConnectionStateChange(
                    this, gatt, status.toLong(), newState.toLong()
                ) {}
            }

            override fun onDescriptorRead(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
                super.onDescriptorRead(gatt, descriptor, status)
                this@BluetoothGattCallbackImpl.onDescriptorRead1(this, gatt, descriptor, status.toLong()) {}
            }

            override fun onDescriptorRead(
                gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int, value: ByteArray
            ) {
                super.onDescriptorRead(gatt, descriptor, status, value)
                this@BluetoothGattCallbackImpl.onDescriptorRead2(this, gatt, descriptor, status.toLong(), value) {}
            }

            override fun onDescriptorWrite(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
                super.onDescriptorWrite(gatt, descriptor, status)
                this@BluetoothGattCallbackImpl.onDescriptorWrite(this, gatt, descriptor, status.toLong()) {}
            }

            override fun onMtuChanged(gatt: BluetoothGatt, mtu: Int, status: Int) {
                super.onMtuChanged(gatt, mtu, status)
                this@BluetoothGattCallbackImpl.onMtuChanged(this, gatt, mtu.toLong(), status.toLong()) {}
            }

            override fun onPhyRead(gatt: BluetoothGatt, txPhy: Int, rxPhy: Int, status: Int) {
                super.onPhyRead(gatt, txPhy, rxPhy, status)
                this@BluetoothGattCallbackImpl.onPhyRead(this, gatt, txPhy.toLong(), rxPhy.toLong(), status.toLong()) {}
            }

            override fun onPhyUpdate(gatt: BluetoothGatt, txPhy: Int, rxPhy: Int, status: Int) {
                super.onPhyUpdate(gatt, txPhy, rxPhy, status)
                this@BluetoothGattCallbackImpl.onPhyUpdate(
                    this, gatt, txPhy.toLong(), rxPhy.toLong(), status.toLong()
                ) {}
            }

            override fun onReadRemoteRssi(gatt: BluetoothGatt, rssi: Int, status: Int) {
                super.onReadRemoteRssi(gatt, rssi, status)
                this@BluetoothGattCallbackImpl.onReadRemoteRssi(this, gatt, rssi.toLong(), status.toLong()) {}
            }

            override fun onReliableWriteCompleted(gatt: BluetoothGatt, status: Int) {
                super.onReliableWriteCompleted(gatt, status)
                this@BluetoothGattCallbackImpl.onReliableWriteCompleted(this, gatt, status.toLong()) {}
            }

            override fun onServiceChanged(gatt: BluetoothGatt) {
                super.onServiceChanged(gatt)
                this@BluetoothGattCallbackImpl.onServiceChanged(this, gatt) {}
            }

            override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
                super.onServicesDiscovered(gatt, status)
                this@BluetoothGattCallbackImpl.onServicesDiscovered(this, gatt, status.toLong()) {}
            }
        }
    }
}