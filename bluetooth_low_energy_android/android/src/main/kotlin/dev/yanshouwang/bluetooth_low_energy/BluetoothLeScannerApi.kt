package dev.yanshouwang.bluetooth_low_energy

import android.app.PendingIntent
import android.bluetooth.le.BluetoothLeScanner
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanSettings
import android.os.Build
import androidx.annotation.RequiresApi

class BluetoothLeScannerApi(private val instanceManager: InstanceManager) : BluetoothLeScannerHostApi {
    override fun startScan(hashCode: Long, callbackHashCode: Long) {
        val scanner = instanceManager.valueOf(hashCode) as BluetoothLeScanner
        val callback = instanceManager.valueOf(callbackHashCode) as ScanCallback
        scanner.startScan(callback)
    }

    override fun startScan1(hashCode: Long, filterHashCodes: List<Long>, settingsHashCode: Long, callbackHashCode: Long) {
        val scanner = instanceManager.valueOf(hashCode) as BluetoothLeScanner
        val filters = filterHashCodes.map { filterHashCode -> instanceManager.valueOf(filterHashCode) as ScanFilter }
        val settings = instanceManager.valueOf(settingsHashCode) as ScanSettings
        val callback = instanceManager.valueOf(callbackHashCode) as ScanCallback
        scanner.startScan(filters, settings, callback)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun startScan2(hashCode: Long, filterHashCodes: List<Long>, settingsHashCode: Long, callbackIntentHashCode: Long) {
        val scanner = instanceManager.valueOf(hashCode) as BluetoothLeScanner
        val filters = filterHashCodes.map { filterHashCode -> instanceManager.valueOf(filterHashCode) as ScanFilter }
        val settings = instanceManager.valueOf(settingsHashCode) as ScanSettings
        val callbackIntent = instanceManager.valueOf(callbackIntentHashCode) as PendingIntent
        scanner.startScan(filters, settings, callbackIntent)
    }

    override fun stopScan(hashCode: Long, callbackHashCode: Long) {
        val scanner = instanceManager.valueOf(hashCode) as BluetoothLeScanner
        val callback = instanceManager.valueOf(callbackHashCode) as ScanCallback
        scanner.stopScan(callback)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun stopScan1(hashCode: Long, callbackIntentHashCode: Long) {
        val scanner = instanceManager.valueOf(hashCode) as BluetoothLeScanner
        val callbackIntent = instanceManager.valueOf(callbackIntentHashCode) as PendingIntent
        scanner.stopScan(callbackIntent)
    }

    override fun flushPendingScanResults(hashCode: Long, callbackHashCode: Long) {
        val scanner = instanceManager.valueOf(hashCode) as BluetoothLeScanner
        val callback = instanceManager.valueOf(callbackHashCode) as ScanCallback
        scanner.flushPendingScanResults(callback)
    }
}