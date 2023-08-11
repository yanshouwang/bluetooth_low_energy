package dev.yanshouwang.bluetooth_low_energy

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class MyBroadcastReceiver(private val myCentralController: MyCentralController) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        myCentralController.onReceive(intent)
    }
}
