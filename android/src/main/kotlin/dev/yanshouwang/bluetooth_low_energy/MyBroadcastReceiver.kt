package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothAdapter
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

object MyBroadcastReceiver : BroadcastReceiver() {
    private const val STATE_UNKNOWN = -1

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "onReceive: $context, $intent")
        val previousStateNumber =
            intent.getIntExtra(BluetoothAdapter.EXTRA_PREVIOUS_STATE, STATE_UNKNOWN).stateNumber
        val stateNumber = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, STATE_UNKNOWN).stateNumber
        if (stateNumber == previousStateNumber) return
        centralFlutterApi.onStateChanged(stateNumber) {}
    }
}