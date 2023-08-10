package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothProfile
import java.util.concurrent.Executor

class MyBluetoothGattCallback(private val instanceManager: MyInstanceManager, private val api: MyCentralControllerFlutterApi, private val executor: Executor) : BluetoothGattCallback() {
    val connectCallbacks = mutableMapOf<Int, (Result<Unit>) -> Unit>()
    val disconnectCallbacks = mutableMapOf<Int, (Result<Unit>) -> Unit>()
    val discoverGattCallbacks = mutableMapOf<Int, (Result<Unit>) -> Unit>()
    val readCharacteristicCallbacks = mutableMapOf<Int, (Result<ByteArray>) -> Unit>()
    val writeCharacteristicCallbacks = mutableMapOf<Int, (Result<Unit>) -> Unit>()
    val readDescriptorCallbacks = mutableMapOf<Int, (Result<ByteArray>) -> Unit>()
    val writeDescriptorCallbacks = mutableMapOf<Int, (Result<Unit>) -> Unit>()

    override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
        super.onConnectionStateChange(gatt, status, newState)
        if (newState != BluetoothProfile.STATE_CONNECTED) {
            gatt.close()
        }
        val device = gatt.device
        val myPeripheralKey = device.hashCode()
        val myPeripheral = instanceManager.instanceOf(myPeripheralKey) as MyPeripheral
        val key = gatt.hashCode()
        val connectCallback = connectCallbacks.remove(key)
        val disconnectCallback = disconnectCallbacks.remove(key)
        if (connectCallback == null && disconnectCallback == null) {
            // State changed.
            val peripheralArgs = myPeripheral.toArgs()
            val state = newState == BluetoothProfile.STATE_CONNECTED
            val errorMessage = if (state) null
            else "Connection lost with status: $status"
            api.onPeripheralStateChanged(peripheralArgs, state, errorMessage) {}
        } else {
            if (connectCallback != null) {
                if (status == BluetoothGatt.GATT_SUCCESS) {
                    // Connect succeed.
                    connectCallback(Result.success(Unit))
                    val peripheralArgs = myPeripheral.toArgs()
                    api.onPeripheralStateChanged(peripheralArgs, true, null) {}
                } else {
                    // Connect failed.
                    val exception = IllegalStateException("Connect failed with status: $status")
                    connectCallback(Result.failure(exception))
                }
            }
            if (disconnectCallback != null) {
                if (status == BluetoothGatt.GATT_SUCCESS) {
                    // Disconnect succeed.
                    disconnectCallback(Result.success(Unit))
                    val peripheralArgs = myPeripheral.toArgs()
                    api.onPeripheralStateChanged(peripheralArgs, false, null) {}
                } else {
                    // Disconnect failed.
                    val exception = IllegalStateException("Connect failed with status: $status")
                    disconnectCallback(Result.failure(exception))
                }
            }
        }
    }

    override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
        super.onServicesDiscovered(gatt, status)
        val key = gatt.hashCode()
        val callback = discoverGattCallbacks.remove(key) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val exception = IllegalStateException("Discover GATT failed with status: $status")
            callback(Result.failure(exception))
        }
    }

    override fun onCharacteristicRead(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int) {
        super.onCharacteristicRead(gatt, characteristic, status)
        val key = characteristic.hashCode()
        val callback = readCharacteristicCallbacks.remove(key) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val value = characteristic.value
            callback(Result.success(value))
        } else {
            val exception = IllegalStateException("Read characteristic failed with status: $status.")
            callback(Result.failure(exception))
        }
    }

    override fun onCharacteristicWrite(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int) {
        super.onCharacteristicWrite(gatt, characteristic, status)
        val key = characteristic.hashCode()
        val callback = writeCharacteristicCallbacks.remove(key) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val exception = IllegalStateException("Write characteristic failed with status: $status.")
            callback(Result.failure(exception))
        }
    }

    override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic) {
        super.onCharacteristicChanged(gatt, characteristic)
        val key = characteristic.hashCode()
        val instance = instanceManager.instanceOf(key)
        val myCharacteristic = if (instance is MyGattCharacteristic) instance
        else MyGattCharacteristic(gatt, characteristic, instanceManager)
        val characteristicArgs = myCharacteristic.toArgs()
        val value = characteristic.value
        executor.execute {
            api.onCharacteristicValueChanged(characteristicArgs, value) {}
        }
    }

    override fun onDescriptorRead(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
        super.onDescriptorRead(gatt, descriptor, status)
        val key = descriptor.hashCode()
        val callback = readDescriptorCallbacks.remove(key) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            val value = descriptor.value
            callback(Result.success(value))
        } else {
            val exception = IllegalStateException("Read descriptor failed with status: $status.")
            callback(Result.failure(exception))
        }
    }

    override fun onDescriptorWrite(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
        super.onDescriptorWrite(gatt, descriptor, status)
        val key = descriptor.hashCode()
        val callback = writeDescriptorCallbacks.remove(key) ?: return
        if (status == BluetoothGatt.GATT_SUCCESS) {
            callback(Result.success(Unit))
        } else {
            val exception = IllegalStateException("Write descriptor failed with status: $status.")
            callback(Result.failure(exception))
        }
    }
}