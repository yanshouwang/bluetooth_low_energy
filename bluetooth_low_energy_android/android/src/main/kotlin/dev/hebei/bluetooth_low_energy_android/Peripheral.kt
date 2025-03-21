package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothDevice

class Peripheral internal constructor(obj: BluetoothDevice) : BluetoothLowEnergyPeer(obj)