package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothDevice
import android.bluetooth.le.ScanRecord
import android.bluetooth.le.ScanResult
import android.os.Build
import androidx.annotation.RequiresApi

class ScanResultApi(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) : PigeonApiScanResult(registrar) {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun getAdvertisingSid(pigeon_instance: ScanResult): Long {
        return pigeon_instance.advertisingSid.toLong()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getDataStatus(pigeon_instance: ScanResult): Long {
        return pigeon_instance.dataStatus.toLong()
    }

    override fun getDevice(pigeon_instance: ScanResult): BluetoothDevice {
        return pigeon_instance.device
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getPeriodicAdvertisingInterval(pigeon_instance: ScanResult): Long {
        return pigeon_instance.periodicAdvertisingInterval.toLong()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getPrimaryPhy(pigeon_instance: ScanResult): Long {
        return pigeon_instance.primaryPhy.toLong()
    }

    override fun getRssi(pigeon_instance: ScanResult): Long {
        return pigeon_instance.rssi.toLong()
    }

    override fun getScanRecord(pigeon_instance: ScanResult): ScanRecord? {
        return pigeon_instance.scanRecord
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getSecondaryPhy(pigeon_instance: ScanResult): Long {
        return pigeon_instance.secondaryPhy.toLong()
    }

    override fun getTimestampNanos(pigeon_instance: ScanResult): Long {
        return pigeon_instance.timestampNanos
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getTxPower(pigeon_instance: ScanResult): Long {
        return pigeon_instance.txPower.toLong()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun isConnectable(pigeon_instance: ScanResult): Boolean {
        return pigeon_instance.isConnectable
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun isLegacy(pigeon_instance: ScanResult): Boolean {
        return pigeon_instance.isLegacy
    }
}