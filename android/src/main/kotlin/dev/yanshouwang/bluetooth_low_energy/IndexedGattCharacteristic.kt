package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGattCharacteristic

class IndexedGattCharacteristic(
    `object`: BluetoothGattCharacteristic,
    val indexedDescriptors: Map<String, IndexedGattDescriptor>
) : IndexedObject<BluetoothGattCharacteristic>(`object`)