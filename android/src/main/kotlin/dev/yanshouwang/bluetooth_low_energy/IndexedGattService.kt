package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGattService

class IndexedGattService(value: BluetoothGattService, val characteristics: Map<String, IndexedGattCharacteristic>) : IndexedObject<BluetoothGattService>(value)