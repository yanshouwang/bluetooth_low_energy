package dev.yanshouwang.bluetooth_low_energy_android

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.os.Build
import java.util.concurrent.Executor

class MyBluetoothGattCallback(private val myCentralManager: MyCentralManager, private val executor: Executor) : BluetoothGattCallback() {
    override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
        super.onConnectionStateChange(gatt, status, newState)
        executor.execute {
            myCentralManager.onConnectionStateChange(gatt, status, newState)
        }
    }

    override fun onMtuChanged(gatt: BluetoothGatt, mtu: Int, status: Int) {
        super.onMtuChanged(gatt, mtu, status)
        executor.execute {
            myCentralManager.onMtuChanged(gatt, mtu, status)
        }
    }

    override fun onReadRemoteRssi(gatt: BluetoothGatt, rssi: Int, status: Int) {
        super.onReadRemoteRssi(gatt, rssi, status)
        executor.execute {
            myCentralManager.onReadRemoteRssi(gatt, rssi, status)
        }
    }

    override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
        super.onServicesDiscovered(gatt, status)
        executor.execute {
            myCentralManager.onServicesDiscovered(gatt, status)
        }
    }

    override fun onCharacteristicRead(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, value: ByteArray, status: Int) {
        super.onCharacteristicRead(gatt, characteristic, value, status)
        executor.execute {
            myCentralManager.onCharacteristicRead(characteristic, status, value)
        }
    }

    // TODO: remove this override when minSdkVersion >= 33
    override fun onCharacteristicRead(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int) {
        super.onCharacteristicRead(gatt, characteristic, status)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return
        }
        val value = characteristic.value
        executor.execute {
            myCentralManager.onCharacteristicRead(characteristic, status, value)
        }
    }

    override fun onCharacteristicWrite(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int) {
        super.onCharacteristicWrite(gatt, characteristic, status)
        executor.execute {
            myCentralManager.onCharacteristicWrite(characteristic, status)
        }
    }

    override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, value: ByteArray) {
        super.onCharacteristicChanged(gatt, characteristic, value)
        executor.execute {
            myCentralManager.onCharacteristicChanged(characteristic, value)
        }
    }

    // TODO: remove this override when minSdkVersion >= 33
    override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic) {
        super.onCharacteristicChanged(gatt, characteristic)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return
        }
        val value = characteristic.value
        executor.execute {
            myCentralManager.onCharacteristicChanged(characteristic, value)
        }
    }

    override fun onDescriptorRead(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int, value: ByteArray) {
        super.onDescriptorRead(gatt, descriptor, status, value)
        executor.execute {
            myCentralManager.onDescriptorRead(descriptor, status, value)
        }
    }

    // TODO: remove this override when minSdkVersion >= 33
    override fun onDescriptorRead(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
        super.onDescriptorRead(gatt, descriptor, status)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return
        }
        val value = descriptor.value
        executor.execute {
            myCentralManager.onDescriptorRead(descriptor, status, value)
        }
    }

    override fun onDescriptorWrite(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
        super.onDescriptorWrite(gatt, descriptor, status)
        executor.execute {
            myCentralManager.onDescriptorWrite(descriptor, status)
        }
    }
}