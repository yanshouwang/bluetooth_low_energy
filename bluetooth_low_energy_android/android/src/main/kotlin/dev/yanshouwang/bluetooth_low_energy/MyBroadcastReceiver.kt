package dev.yanshouwang.bluetooth_low_energy

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class MyBroadcastReceiver(private val api: BroadcastReceiverFlutterApi, private val instanceManager: InstanceManager) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val intentHashCode = instanceManager.allocate(intent)
        api.onReceive(hashCode1, intentHashCode) {}
    }
}