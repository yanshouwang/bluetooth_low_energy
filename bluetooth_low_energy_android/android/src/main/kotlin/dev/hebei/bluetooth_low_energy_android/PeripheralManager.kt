package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattServerCallback
import android.bluetooth.BluetoothGattService
import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseSettings
import android.bluetooth.le.BluetoothLeAdvertiser
import android.os.Build

class PeripheralManager(contextUtil: ContextUtil, activityUtil: ActivityUtil) :
    BluetoothLowEnergyManager(contextUtil, activityUtil) {
    private val connectionStateChangedListeners = mutableListOf<ConnectionStateChangedListener>()
    private val mtuChangedListeners = mutableListOf<MTUChangedListener>()
    private val characteristicReadRequestedListeners = mutableListOf<CharacteristicReadRequestedListener>()
    private val characteristicWriteRequestedListeners = mutableListOf<CharacteristicWriteRequestedListener>()
    private val characteristicNotifyStateChangedListeners = mutableListOf<CharacteristicNotifyStateChangedListener>()
    private val descriptorReadRequestedListeners = mutableListOf<DescriptorReadRequestedListener>()
    private val descriptorWriteRequestedListeners = mutableListOf<DescriptorWriteRequestedListener>()

    private val bluetoothLeAdvertiser: BluetoothLeAdvertiser get() = bluetoothAdapter.bluetoothLeAdvertiser

    private val advertiseCallback = object : AdvertiseCallback() {
        override fun onStartSuccess(settingsInEffect: AdvertiseSettings?) {
            super.onStartSuccess(settingsInEffect)
        }

        override fun onStartFailure(errorCode: Int) {
            super.onStartFailure(errorCode)
        }
    }

    private val bluetoothGattServerCallback = object : BluetoothGattServerCallback() {
        override fun onServiceAdded(status: Int, service: BluetoothGattService?) {
            super.onServiceAdded(status, service)
        }

        override fun onConnectionStateChange(device: BluetoothDevice?, status: Int, newState: Int) {
            super.onConnectionStateChange(device, status, newState)
        }

        override fun onMtuChanged(device: BluetoothDevice?, mtu: Int) {
            super.onMtuChanged(device, mtu)
        }

        override fun onCharacteristicReadRequest(
            device: BluetoothDevice?, requestId: Int, offset: Int, characteristic: BluetoothGattCharacteristic?
        ) {
            super.onCharacteristicReadRequest(device, requestId, offset, characteristic)
        }

        override fun onCharacteristicWriteRequest(
            device: BluetoothDevice?,
            requestId: Int,
            characteristic: BluetoothGattCharacteristic?,
            preparedWrite: Boolean,
            responseNeeded: Boolean,
            offset: Int,
            value: ByteArray?
        ) {
            super.onCharacteristicWriteRequest(
                device, requestId, characteristic, preparedWrite, responseNeeded, offset, value
            )
        }

        override fun onDescriptorReadRequest(
            device: BluetoothDevice?, requestId: Int, offset: Int, descriptor: BluetoothGattDescriptor?
        ) {
            super.onDescriptorReadRequest(device, requestId, offset, descriptor)
        }

        override fun onDescriptorWriteRequest(
            device: BluetoothDevice?,
            requestId: Int,
            descriptor: BluetoothGattDescriptor?,
            preparedWrite: Boolean,
            responseNeeded: Boolean,
            offset: Int,
            value: ByteArray?
        ) {
            super.onDescriptorWriteRequest(device, requestId, descriptor, preparedWrite, responseNeeded, offset, value)
        }

        override fun onExecuteWrite(device: BluetoothDevice?, requestId: Int, execute: Boolean) {
            super.onExecuteWrite(device, requestId, execute)
        }

        override fun onNotificationSent(device: BluetoothDevice?, status: Int) {
            super.onNotificationSent(device, status)
        }

        override fun onPhyRead(device: BluetoothDevice?, txPhy: Int, rxPhy: Int, status: Int) {
            super.onPhyRead(device, txPhy, rxPhy, status)
        }

        override fun onPhyUpdate(device: BluetoothDevice?, txPhy: Int, rxPhy: Int, status: Int) {
            super.onPhyUpdate(device, txPhy, rxPhy, status)
        }
    }

    override val permissions: Array<String>
        get() = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) arrayOf(
            android.Manifest.permission.BLUETOOTH_ADVERTISE,
            android.Manifest.permission.BLUETOOTH_CONNECT,
        ) else arrayOf(
            android.Manifest.permission.ACCESS_COARSE_LOCATION,
            android.Manifest.permission.ACCESS_FINE_LOCATION,
        )
    override val requestCode: Int get() = 445

    fun addConnectionStateChangedListener(listener: ConnectionStateChangedListener) {
        connectionStateChangedListeners.add(listener)
    }

    fun removeConnectionStateChangedListener(listener: ConnectionStateChangedListener) {
        connectionStateChangedListeners.remove(listener)
    }

    fun addMTUChangedListener(listener: MTUChangedListener) {
        mtuChangedListeners.add(listener)
    }

    fun removeMTUChangedListener(listener: MTUChangedListener) {
        mtuChangedListeners.remove(listener)
    }

    fun addCharacteristicReadRequestedListener(listener: CharacteristicReadRequestedListener) {
        characteristicReadRequestedListeners.add(listener)
    }

    fun removeCharacteristicReadRequestedListener(listener: CharacteristicReadRequestedListener) {
        characteristicReadRequestedListeners.remove(listener)
    }

    fun addCharacteristicWriteRequestedListener(listener: CharacteristicWriteRequestedListener) {
        characteristicWriteRequestedListeners.add(listener)
    }

    fun removeCharacteristicWriteRequestedListener(listener: CharacteristicWriteRequestedListener) {
        characteristicWriteRequestedListeners.remove(listener)
    }

    fun addCharacteristicNotifyStateChangedListener(listener: CharacteristicNotifyStateChangedListener) {
        characteristicNotifyStateChangedListeners.add(listener)
    }

    fun removeCharacteristicNotifyStateChangedListener(listener: CharacteristicNotifyStateChangedListener) {
        characteristicNotifyStateChangedListeners.remove(listener)
    }

    fun addDescriptorReadRequestedListener(listener: DescriptorReadRequestedListener) {
        descriptorReadRequestedListeners.add(listener)
    }

    fun removeDescriptorReadRequestedListener(listener: DescriptorReadRequestedListener) {
        descriptorReadRequestedListeners.remove(listener)
    }

    fun addDescriptorWriteRequestedListener(listener: DescriptorWriteRequestedListener) {
        descriptorWriteRequestedListeners.add(listener)
    }

    fun removeDescriptorWriteRequestedListener(listener: DescriptorWriteRequestedListener) {
        descriptorWriteRequestedListeners.remove(listener)
    }

    interface ConnectionStateChangedListener {
        fun onChanged(central: Central, state: ConnectionState)
    }

    interface MTUChangedListener {
        fun onChanged(central: Central, mtu: Int)
    }

    interface CharacteristicReadRequestedListener {
        fun onRequested(characteristic: GATTCharacteristic, central: Central, request: GATTReadRequest)
    }

    interface CharacteristicWriteRequestedListener {
        fun onRequested(characteristic: GATTCharacteristic, central: Central, request: GATTWriteRequest)
    }

    interface CharacteristicNotifyStateChangedListener {
        fun onChanged(characteristic: GATTCharacteristic, central: Central, state: Boolean)
    }

    interface DescriptorReadRequestedListener {
        fun onRequested(descriptor: GATTDescriptor, central: Central, request: GATTReadRequest)
    }

    interface DescriptorWriteRequestedListener {
        fun onRequested(descriptor: GATTDescriptor, central: Central, request: GATTWriteRequest)
    }
}