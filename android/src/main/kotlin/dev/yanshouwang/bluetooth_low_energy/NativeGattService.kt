package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGattService

class NativeGattService(value: BluetoothGattService, val characteristics: Map<String, NativeGattCharacteristic>) : NativeValue<BluetoothGattService>(value)