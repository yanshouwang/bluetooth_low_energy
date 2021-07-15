package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGattCharacteristic

class NativeGattCharacteristic(value: BluetoothGattCharacteristic, val descriptors: Map<String, NativeGattDescriptor>) : NativeValue<BluetoothGattCharacteristic>(value)