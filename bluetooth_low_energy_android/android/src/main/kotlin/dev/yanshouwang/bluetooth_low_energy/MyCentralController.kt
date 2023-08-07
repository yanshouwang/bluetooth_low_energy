package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.content.IntentFilter
import androidx.core.content.ContextCompat

class MyCentralController(private val context: Context) : MyObject() {
    private val manager = ContextCompat.getSystemService(context, BluetoothManager::class.java) as BluetoothManager
    private val adapter = manager.adapter
    private val scanner = adapter.bluetoothLeScanner
    private val broadcastReceiver = MyBroadcastReceiver(this)
    private val scanCallback = MyScanCallback()

    override fun onAllocated() {
        super.onAllocated()
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        context.registerReceiver(broadcastReceiver, filter)
    }

    override fun onFreed() {
        super.onFreed()
        context.unregisterReceiver(broadcastReceiver)
    }

    fun getState(): Long {
        return adapter.state.rawState
    }

    fun startDiscovery() {
        val filters = emptyList<ScanFilter>()
        val settings = ScanSettings.Builder().setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY).build()
        scanner.startScan(filters, settings, scanCallback)
    }

    fun stopDiscovery() {
        scanner.stopScan(scanCallback)
    }

    fun connect(peripheral: MyPeripheral) {

    }

    fun disconnect(peripheral: MyPeripheral) {

    }

    fun discoverServices(peripheral: MyPeripheral) {

    }

    fun discoverCharacteristics(service: MyGattService) {

    }

    fun discoverDescriptor(characteristic: MyGattCharacteristic) {

    }
}

private val Int.rawState: Long
    get() {
        val state = when (this) {
            BluetoothAdapter.STATE_ON -> MyCentralControllerState.ON
            else -> MyCentralControllerState.OFF
        }
        return state.raw.toLong()
    }