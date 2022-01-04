package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothGatt

class IndexedGATT(`object`: BluetoothGatt, val indexedServices: Map<String, IndexedGattService>) :
    IndexedObject<BluetoothGatt>(`object`)