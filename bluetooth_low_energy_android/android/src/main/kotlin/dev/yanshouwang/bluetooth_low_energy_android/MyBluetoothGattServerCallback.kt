package dev.yanshouwang.bluetooth_low_energy_android

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattServerCallback
import android.bluetooth.BluetoothGattService
import java.util.concurrent.Executor

class MyBluetoothGattServerCallback(private val peripheralManager: MyPeripheralManager, private val executor: Executor) : BluetoothGattServerCallback() {
    override fun onServiceAdded(status: Int, service: BluetoothGattService) {
        super.onServiceAdded(status, service)
        executor.execute {
            peripheralManager.onServiceAdded(status, service)
        }
    }

    override fun onConnectionStateChange(device: BluetoothDevice, status: Int, newState: Int) {
        super.onConnectionStateChange(device, status, newState)
        executor.execute {
            peripheralManager.onConnectionStateChange(device, status, newState)
        }
    }

    override fun onMtuChanged(device: BluetoothDevice, mtu: Int) {
        super.onMtuChanged(device, mtu)
        executor.execute {
            peripheralManager.onMtuChanged(device, mtu)
        }
    }

    override fun onCharacteristicReadRequest(device: BluetoothDevice, requestId: Int, offset: Int, characteristic: BluetoothGattCharacteristic) {
        super.onCharacteristicReadRequest(device, requestId, offset, characteristic)
        executor.execute {
            peripheralManager.onCharacteristicReadRequest(device, requestId, offset, characteristic)
        }
    }

    override fun onCharacteristicWriteRequest(device: BluetoothDevice, requestId: Int, characteristic: BluetoothGattCharacteristic, preparedWrite: Boolean, responseNeeded: Boolean, offset: Int, value: ByteArray) {
        super.onCharacteristicWriteRequest(device, requestId, characteristic, preparedWrite, responseNeeded, offset, value)
        executor.execute {
            peripheralManager.onCharacteristicWriteRequest(device, requestId, characteristic, preparedWrite, responseNeeded, offset, value)
        }
    }

    override fun onExecuteWrite(device: BluetoothDevice, requestId: Int, execute: Boolean) {
        super.onExecuteWrite(device, requestId, execute)
        executor.execute {
            peripheralManager.onExecuteWrite(device, requestId, execute)
        }
    }

    override fun onNotificationSent(device: BluetoothDevice, status: Int) {
        super.onNotificationSent(device, status)
        executor.execute {
            peripheralManager.onNotificationSent(device, status)
        }
    }

    override fun onDescriptorReadRequest(device: BluetoothDevice, requestId: Int, offset: Int, descriptor: BluetoothGattDescriptor) {
        super.onDescriptorReadRequest(device, requestId, offset, descriptor)
        executor.execute {
            peripheralManager.onDescriptorReadRequest(device, requestId, offset, descriptor)
        }
    }

    override fun onDescriptorWriteRequest(device: BluetoothDevice, requestId: Int, descriptor: BluetoothGattDescriptor, preparedWrite: Boolean, responseNeeded: Boolean, offset: Int, value: ByteArray) {
        super.onDescriptorWriteRequest(device, requestId, descriptor, preparedWrite, responseNeeded, offset, value)
        executor.execute {
            peripheralManager.onDescriptorWriteRequest(device, requestId, descriptor, preparedWrite, responseNeeded, offset, value)
        }
    }
}