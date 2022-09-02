package dev.yanshouwang.bluetooth_low_energy_android

import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanSettings
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.ParcelUuid

internal class CentralController(private val adapter: BluetoothAdapter) {
    private val activity get() = instances[InstanceIds.activity] as Activity

    private val scanCallback = object : ScanCallback() {

    }

    private val stateChangedReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            TODO("Not yet implemented")
        }
    }

    fun getState(): Int {
        return adapter.state
    }

    fun subscribeStateChanged() {
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        activity.registerReceiver(stateChangedReceiver, filter)
    }

    fun unsubscribeStateChanged() {
        activity.unregisterReceiver(stateChangedReceiver)
    }

    fun startScan(uuids: List<String>) {
        val filters = uuids.map {
            val uuid = ParcelUuid.fromString(it)
            ScanFilter.Builder().setServiceUuid(uuid).build()
        }
        val settings = ScanSettings.Builder().build()
        adapter.bluetoothLeScanner.startScan(filters, settings, scanCallback)
    }

    fun stopScan() {
        adapter.bluetoothLeScanner.stopScan(scanCallback)
    }
}