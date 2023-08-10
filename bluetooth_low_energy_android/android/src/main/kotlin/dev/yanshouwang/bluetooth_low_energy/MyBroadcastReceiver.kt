package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothAdapter
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class MyBroadcastReceiver(private val api: MyCentralControllerFlutterApi) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.STATE_OFF)
        val stateArgs = state.toMyCentralControllerStateArgs()
        val stateNumber = stateArgs.raw.toLong()
        api.onStateChanged(stateNumber) {}
    }
}

private fun Int.toMyCentralControllerStateArgs(): MyCentralControllerStateArgs {
    return when (this) {
        BluetoothAdapter.STATE_ON -> MyCentralControllerStateArgs.POWEREDON
        else -> MyCentralControllerStateArgs.POWEREDOFF
    }
}
