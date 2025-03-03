package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.*

class BluetoothGattServerCallbackImpl(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiBluetoothGattServerCallback(registrar) {
    override fun pigeon_defaultConstructor(): BluetoothGattServerCallback {
        return object : BluetoothGattServerCallback() {
            override fun onCharacteristicReadRequest(
                device: BluetoothDevice, requestId: Int, offset: Int, characteristic: BluetoothGattCharacteristic
            ) {
                super.onCharacteristicReadRequest(device, requestId, offset, characteristic)
                this@BluetoothGattServerCallbackImpl.onCharacteristicReadRequest(
                    this, device, requestId.toLong(), offset.toLong(), characteristic
                ) {}
            }

            override fun onCharacteristicWriteRequest(
                device: BluetoothDevice,
                requestId: Int,
                characteristic: BluetoothGattCharacteristic,
                preparedWrite: Boolean,
                responseNeeded: Boolean,
                offset: Int,
                value: ByteArray
            ) {
                super.onCharacteristicWriteRequest(
                    device, requestId, characteristic, preparedWrite, responseNeeded, offset, value
                )
                this@BluetoothGattServerCallbackImpl.onCharacteristicWriteRequest(
                    this,
                    device,
                    requestId.toLong(),
                    characteristic,
                    preparedWrite,
                    responseNeeded,
                    offset.toLong(),
                    value
                ) {}
            }

            override fun onConnectionStateChange(device: BluetoothDevice, status: Int, newState: Int) {
                super.onConnectionStateChange(device, status, newState)
                this@BluetoothGattServerCallbackImpl.onConnectionStateChange(
                    this, device, status.toLong(), newState.toLong()
                ) {}
            }

            override fun onDescriptorReadRequest(
                device: BluetoothDevice, requestId: Int, offset: Int, descriptor: BluetoothGattDescriptor
            ) {
                super.onDescriptorReadRequest(device, requestId, offset, descriptor)
                this@BluetoothGattServerCallbackImpl.onDescriptorReadRequest(
                    this, device, requestId.toLong(), offset.toLong(), descriptor
                ) {}
            }

            override fun onDescriptorWriteRequest(
                device: BluetoothDevice,
                requestId: Int,
                descriptor: BluetoothGattDescriptor,
                preparedWrite: Boolean,
                responseNeeded: Boolean,
                offset: Int,
                value: ByteArray
            ) {
                super.onDescriptorWriteRequest(
                    device, requestId, descriptor, preparedWrite, responseNeeded, offset, value
                )
                this@BluetoothGattServerCallbackImpl.onDescriptorWriteRequest(
                    this, device, requestId.toLong(), descriptor, preparedWrite, responseNeeded, offset.toLong(), value
                ) {}
            }

            override fun onExecuteWrite(device: BluetoothDevice, requestId: Int, execute: Boolean) {
                super.onExecuteWrite(device, requestId, execute)
                this@BluetoothGattServerCallbackImpl.onExecuteWrite(this, device, requestId.toLong(), execute) {}
            }

            override fun onMtuChanged(device: BluetoothDevice, mtu: Int) {
                super.onMtuChanged(device, mtu)
                this@BluetoothGattServerCallbackImpl.onMtuChanged(this, device, mtu.toLong()) {}
            }

            override fun onNotificationSent(device: BluetoothDevice, status: Int) {
                super.onNotificationSent(device, status)
                this@BluetoothGattServerCallbackImpl.onNotificationSent(this, device, status.toLong()) {}
            }

            override fun onPhyRead(device: BluetoothDevice, txPhy: Int, rxPhy: Int, status: Int) {
                super.onPhyRead(device, txPhy, rxPhy, status)
                this@BluetoothGattServerCallbackImpl.onPhyRead(
                    this, device, txPhy.toLong(), rxPhy.toLong(), status.toLong()
                ) {}
            }

            override fun onPhyUpdate(device: BluetoothDevice, txPhy: Int, rxPhy: Int, status: Int) {
                super.onPhyUpdate(device, txPhy, rxPhy, status)
                this@BluetoothGattServerCallbackImpl.onPhyUpdate(
                    this, device, txPhy.toLong(), rxPhy.toLong(), status.toLong()
                ) {}
            }

            override fun onServiceAdded(status: Int, service: BluetoothGattService) {
                super.onServiceAdded(status, service)
                this@BluetoothGattServerCallbackImpl.onServiceAdded(this, status.toLong(), service) {}
            }
        }
    }
}