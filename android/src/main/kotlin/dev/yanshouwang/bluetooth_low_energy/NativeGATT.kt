package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt

class NativeGATT(value: BluetoothGatt, val services: Map<String, NativeGattService>) : NativeValue<BluetoothGatt>(value)