package dev.hebei.bluetooth_low_energy_android

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class BroadcastReceiverApi(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiBroadcastReceiver(registrar) {
    override fun pigeon_defaultConstructor(): BroadcastReceiver {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                this@BroadcastReceiverApi.onReceive(this, context, intent) {}
            }
        }
    }
}