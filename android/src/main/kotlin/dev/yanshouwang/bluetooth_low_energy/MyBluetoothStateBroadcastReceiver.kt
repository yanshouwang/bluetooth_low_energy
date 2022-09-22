package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothAdapter
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

object MyBluetoothStateBroadcastReceiver : BroadcastReceiver() {
    private const val STATE_UNKNOWN = -1

    override fun onReceive(context: Context, intent: Intent) {
        val previousState =
            intent.getIntExtra(BluetoothAdapter.EXTRA_PREVIOUS_STATE, STATE_UNKNOWN).bluetoothState
        val state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, STATE_UNKNOWN).bluetoothState
        if (state == previousState) return
        val stateNumber = state.number.toLong()
        centralManagerFlutterApi.notifyState(stateNumber) {}
    }
}
