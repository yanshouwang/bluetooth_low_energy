package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGattService

class IndexedGattService(
    `object`: BluetoothGattService,
    val indexedCharacteristics: Map<String, IndexedGattCharacteristic>
) : IndexedObject<BluetoothGattService>(`object`)