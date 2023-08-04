package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattServerCallback
import android.bluetooth.BluetoothGattService

class MyBluetoothGattServerCallback(private val api: BluetoothGattServerCallbackFlutterApi, private val instanceManager: InstanceManager) : BluetoothGattServerCallback() {
    override fun onConnectionStateChange(device: BluetoothDevice, status: Int, newState: Int) {
        super.onConnectionStateChange(device, status, newState)
        val deviceHashCode = instanceManager.allocate(device)
        val status1 = status.toLong()
        val newState1 = newState.toLong()
        api.onConnectionStateChange(hashCode1, deviceHashCode, status1, newState1) {}
    }

    override fun onServiceAdded(status: Int, service: BluetoothGattService) {
        super.onServiceAdded(status, service)
        val status1 = status.toLong()
        val serviceHashCode = instanceManager.allocate(service)
        api.onServiceAdded(hashCode1, status1, serviceHashCode) {}
    }

    override fun onCharacteristicReadRequest(device: BluetoothDevice, requestId: Int, offset: Int, characteristic: BluetoothGattCharacteristic) {
        super.onCharacteristicReadRequest(device, requestId, offset, characteristic)
        val deviceHashCode = instanceManager.allocate(device)
        val requestId1 = requestId.toLong()
        val offset1 = offset.toLong()
        val characteristicHashCode = instanceManager.allocate(characteristic)
        api.onCharacteristicReadRequest(hashCode1, deviceHashCode, requestId1, offset1, characteristicHashCode) {}
    }

    override fun onCharacteristicWriteRequest(device: BluetoothDevice, requestId: Int, characteristic: BluetoothGattCharacteristic, preparedWrite: Boolean, responseNeeded: Boolean, offset: Int, value: ByteArray) {
        super.onCharacteristicWriteRequest(device, requestId, characteristic, preparedWrite, responseNeeded, offset, value)
        val deviceHashCode = instanceManager.allocate(device)
        val requestId1 = requestId.toLong()
        val characteristicHashCode = instanceManager.allocate(characteristic)
        val offset1 = offset.toLong()
        api.onCharacteristicWriteRequest(hashCode1, deviceHashCode, requestId1, characteristicHashCode, preparedWrite, responseNeeded, offset1, value) {}
    }

    override fun onDescriptorReadRequest(device: BluetoothDevice, requestId: Int, offset: Int, descriptor: BluetoothGattDescriptor) {
        super.onDescriptorReadRequest(device, requestId, offset, descriptor)
        val deviceHashCode = instanceManager.allocate(device)
        val requestId1 = requestId.toLong()
        val offset1 = offset.toLong()
        val descriptorHashCode = instanceManager.allocate(descriptor)
        api.onDescriptorReadRequest(hashCode1, deviceHashCode, requestId1, offset1, descriptorHashCode) {}
    }

    override fun onDescriptorWriteRequest(device: BluetoothDevice, requestId: Int, descriptor: BluetoothGattDescriptor, preparedWrite: Boolean, responseNeeded: Boolean, offset: Int, value: ByteArray) {
        super.onDescriptorWriteRequest(device, requestId, descriptor, preparedWrite, responseNeeded, offset, value)
        val deviceHashCode = instanceManager.allocate(device)
        val requestId1 = requestId.toLong()
        val descriptorHashCode = instanceManager.allocate(descriptor)
        val offset1 = offset.toLong()
        api.onDescriptorWriteRequest(hashCode1, deviceHashCode, requestId1, descriptorHashCode, preparedWrite, responseNeeded, offset1, value) {}
    }

    override fun onExecuteWrite(device: BluetoothDevice, requestId: Int, execute: Boolean) {
        super.onExecuteWrite(device, requestId, execute)
        val deviceHashCode = instanceManager.allocate(device)
        val requestId1 = requestId.toLong()
        api.onExecuteWrite(hashCode1, deviceHashCode, requestId1, execute) {}
    }

    override fun onNotificationSent(device: BluetoothDevice, status: Int) {
        super.onNotificationSent(device, status)
        val deviceHashCode = instanceManager.allocate(device)
        val status1 = status.toLong()
        api.onNotificationSent(hashCode1, deviceHashCode, status1) {}
    }

    override fun onMtuChanged(device: BluetoothDevice, mtu: Int) {
        super.onMtuChanged(device, mtu)
        val deviceHashCode = instanceManager.allocate(device)
        val mtu1 = mtu.toLong()
        api.onMtuChanged(hashCode1, deviceHashCode, mtu1) {}
    }

    override fun onPhyUpdate(device: BluetoothDevice, txPhy: Int, rxPhy: Int, status: Int) {
        super.onPhyUpdate(device, txPhy, rxPhy, status)
        val deviceHashCode = instanceManager.allocate(device)
        val txPhy1 = txPhy.toLong()
        val rxPhy1 = rxPhy.toLong()
        val status1 = status.toLong()
        api.onPhyUpdate(hashCode1, deviceHashCode, txPhy1, rxPhy1, status1) {}
    }

    override fun onPhyRead(device: BluetoothDevice, txPhy: Int, rxPhy: Int, status: Int) {
        super.onPhyRead(device, txPhy, rxPhy, status)
        val deviceHashCode = instanceManager.allocate(device)
        val txPhy1 = txPhy.toLong()
        val rxPhy1 = rxPhy.toLong()
        val status1 = status.toLong()
        api.onPhyRead(hashCode1, deviceHashCode, txPhy1, rxPhy1, status1) {}
    }
}