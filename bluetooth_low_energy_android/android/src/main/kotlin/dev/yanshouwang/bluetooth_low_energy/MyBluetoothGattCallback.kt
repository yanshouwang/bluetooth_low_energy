package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor

class MyBluetoothGattCallback(private val api: BluetoothGattCallbackFlutterApi, private val instanceManager: InstanceManager) : BluetoothGattCallback() {
    override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic) {
        super.onCharacteristicChanged(gatt, characteristic)
        val gattHashCode = instanceManager.allocate(gatt)
        val characteristicHashCode = instanceManager.allocate(characteristic)
        api.onCharacteristicChanged(hashCode1, gattHashCode, characteristicHashCode) {}
    }

    override fun onCharacteristicRead(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int) {
        super.onCharacteristicRead(gatt, characteristic, status)
        val gattHashCode = instanceManager.allocate(gatt)
        val characteristicHashCode = instanceManager.allocate(characteristic)
        val status1 = status.toLong()
        api.onCharacteristicRead(hashCode1, gattHashCode, characteristicHashCode, status1) {}
    }

    override fun onCharacteristicWrite(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int) {
        super.onCharacteristicWrite(gatt, characteristic, status)
        val gattHashCode = instanceManager.allocate(gatt)
        val characteristicHashCode = instanceManager.allocate(characteristic)
        val status1 = status.toLong()
        api.onCharacteristicWrite(hashCode1, gattHashCode, characteristicHashCode, status1) {}
    }

    override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
        super.onConnectionStateChange(gatt, status, newState)
        val gattHashCode = instanceManager.allocate(gatt)
        val status1 = status.toLong()
        val newState1 = newState.toLong()
        api.onConnectionStateChange(hashCode1, gattHashCode, status1, newState1) {}
    }

    override fun onDescriptorRead(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
        super.onDescriptorRead(gatt, descriptor, status)
        val gattHashCode = instanceManager.allocate(gatt)
        val descriptorHashCode = instanceManager.allocate(descriptor)
        val status1 = status.toLong()
        api.onDescriptorRead(hashCode1, gattHashCode, descriptorHashCode, status1) {}
    }

    override fun onDescriptorWrite(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
        super.onDescriptorWrite(gatt, descriptor, status)
        val gattHashCode = instanceManager.allocate(gatt)
        val descriptorHashCode = instanceManager.allocate(descriptor)
        val status1 = status.toLong()
        api.onDescriptorWrite(hashCode1, gattHashCode, descriptorHashCode, status1) {}
    }

    override fun onMtuChanged(gatt: BluetoothGatt, mtu: Int, status: Int) {
        super.onMtuChanged(gatt, mtu, status)
        val gattHashCode = instanceManager.allocate(gatt)
        val mtu1 = mtu.toLong()
        val status1 = status.toLong()
        api.onMtuChanged(hashCode1, gattHashCode, mtu1, status1) {}
    }

    override fun onPhyRead(gatt: BluetoothGatt, txPhy: Int, rxPhy: Int, status: Int) {
        super.onPhyRead(gatt, txPhy, rxPhy, status)
        val gattHashCode = instanceManager.allocate(gatt)
        val txPhy1 = txPhy.toLong()
        val rxPhy1 = rxPhy.toLong()
        val status1 = status.toLong()
        api.onPhyRead(hashCode1, gattHashCode, txPhy1, rxPhy1, status1) {}
    }

    override fun onPhyUpdate(gatt: BluetoothGatt, txPhy: Int, rxPhy: Int, status: Int) {
        super.onPhyUpdate(gatt, txPhy, rxPhy, status)
        val gattHashCode = instanceManager.allocate(gatt)
        val txPhy1 = txPhy.toLong()
        val rxPhy1 = rxPhy.toLong()
        val status1 = status.toLong()
        api.onPhyUpdate(hashCode1, gattHashCode, txPhy1, rxPhy1, status1) {}
    }

    override fun onReadRemoteRssi(gatt: BluetoothGatt, rssi: Int, status: Int) {
        super.onReadRemoteRssi(gatt, rssi, status)
        val gattHashCode = instanceManager.allocate(gatt)
        val rssi1 = rssi.toLong()
        val status1 = status.toLong()
        api.onReadRemoteRssi(hashCode1, gattHashCode, rssi1, status1) {}
    }

    override fun onReliableWriteCompleted(gatt: BluetoothGatt, status: Int) {
        super.onReliableWriteCompleted(gatt, status)
        val gattHashCode = instanceManager.allocate(gatt)
        val status1 = status.toLong()
        api.onReliableWriteCompleted(hashCode1, gattHashCode, status1) {}
    }

    override fun onServiceChanged(gatt: BluetoothGatt) {
        super.onServiceChanged(gatt)
        val gattHashCode = instanceManager.allocate(gatt)
        api.onServiceChanged(hashCode1, gattHashCode) {}
    }

    override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
        super.onServicesDiscovered(gatt, status)
        val gattHashCode = instanceManager.allocate(gatt)
        val status1 = status.toLong()
        api.onServicesDiscovered(hashCode1, gattHashCode, status1) {}
    }
}