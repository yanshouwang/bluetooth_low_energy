package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGattCharacteristic

class IndexedGattCharacteristic(value: BluetoothGattCharacteristic, val descriptors: Map<String, IndexedGattDescriptor>) : IndexedObject<BluetoothGattCharacteristic>(value)