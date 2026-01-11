package dev.zeekr.bluetooth_low_energy_android

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class BroadcastReceiverImpl(manager: BluetoothLowEnergyManagerImpl) : BroadcastReceiver() {
    private val mManager: BluetoothLowEnergyManagerImpl

    init {
        mManager = manager
    }

    override fun onReceive(context: Context, intent: Intent) {
        mManager.onReceive(context, intent)
    }
}
