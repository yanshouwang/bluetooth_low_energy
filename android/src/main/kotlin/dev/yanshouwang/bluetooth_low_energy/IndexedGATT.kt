package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt

class IndexedGATT(value: BluetoothGatt, val services: Map<String, IndexedGattService>) : IndexedObject<BluetoothGatt>(value)