package dev.hebei.bluetooth_low_energy_android

import android.app.PendingIntent
import android.bluetooth.le.BluetoothLeScanner
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanSettings
import android.os.Build
import androidx.annotation.RequiresApi

class BluetoothLeScannerApi(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiBluetoothLeScanner(registrar) {
    override fun flushPendingScanResults(pigeon_instance: BluetoothLeScanner, callback: ScanCallback) {
        pigeon_instance.flushPendingScanResults(callback)
    }

    override fun startScan1(pigeon_instance: BluetoothLeScanner, callback: ScanCallback) {
        pigeon_instance.startScan(callback)
    }

    override fun startScan2(
        pigeon_instance: BluetoothLeScanner, filters: List<ScanFilter>, settings: ScanSettings, callback: ScanCallback
    ) {
        pigeon_instance.startScan(filters, settings, callback)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun startScan3(
        pigeon_instance: BluetoothLeScanner,
        filters: List<ScanFilter>?,
        settings: ScanSettings?,
        callbackIntent: PendingIntent
    ) {
        pigeon_instance.startScan(filters, settings, callbackIntent)
    }

    override fun stopScan1(pigeon_instance: BluetoothLeScanner, callback: ScanCallback) {
        pigeon_instance.stopScan(callback)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun stopScan2(pigeon_instance: BluetoothLeScanner, callbackIntent: PendingIntent) {
        pigeon_instance.stopScan(callbackIntent)
    }
}