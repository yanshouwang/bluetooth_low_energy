package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothDevice
import android.bluetooth.le.ScanRecord
import android.bluetooth.le.ScanResult

class ScanResultImpl(registrar: BluetoothLowEnergyPigeonProxyApiRegistrar) : PigeonApiScanResult(registrar) {
    override fun getAdvertisingSid(pigeon_instance: ScanResult): Long {
        return pigeon_instance.advertisingSid.toLong()
    }

    override fun getDataStatus(pigeon_instance: ScanResult): Long {
        return pigeon_instance.dataStatus.toLong()
    }

    override fun getDevice(pigeon_instance: ScanResult): BluetoothDevice {
        return pigeon_instance.device
    }

    override fun getPeriodicAdvertisingInterval(pigeon_instance: ScanResult): Long {
        return pigeon_instance.periodicAdvertisingInterval.toLong()
    }

    override fun getPrimaryPhy(pigeon_instance: ScanResult): Long {
        return pigeon_instance.primaryPhy.toLong()
    }

    override fun getRssi(pigeon_instance: ScanResult): Long {
        return pigeon_instance.rssi.toLong()
    }

    override fun getScanRecord(pigeon_instance: ScanResult): ScanRecord? {
        return pigeon_instance.scanRecord
    }

    override fun getSecondaryPhy(pigeon_instance: ScanResult): Long {
        return pigeon_instance.secondaryPhy.toLong()
    }

    override fun getTimestampNanos(pigeon_instance: ScanResult): Long {
        return pigeon_instance.timestampNanos
    }

    override fun getTxPower(pigeon_instance: ScanResult): Long {
        return pigeon_instance.txPower.toLong()
    }

    override fun isConnectable(pigeon_instance: ScanResult): Boolean {
        return pigeon_instance.isConnectable
    }

    override fun isLegacy(pigeon_instance: ScanResult): Boolean {
        return pigeon_instance.isLegacy
    }
}