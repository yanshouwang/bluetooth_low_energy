package dev.yanshouwang.bluetooth_low_energy_android

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class MyBroadcastReceiver(manager: MyBluetoothLowEnergyManager) : BroadcastReceiver() {
    private val mManager: MyBluetoothLowEnergyManager

    init {
        mManager = manager
    }

    override fun onReceive(context: Context, intent: Intent) {
        mManager.onReceive(context, intent)
    }
}
