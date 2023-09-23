package dev.yanshouwang.bluetooth_low_energy_android

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class MyBroadcastReceiver(private val myBluetoothLowEnergyManager: MyBluetoothLowEnergyManager) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        myBluetoothLowEnergyManager.onReceive(intent)
    }
}
