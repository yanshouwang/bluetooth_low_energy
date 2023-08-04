package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.le.ScanResult
import android.os.Build
import androidx.annotation.RequiresApi

class ScanResultApi(private val instanceManager: InstanceManager) : ScanResultHostApi {
    override fun getDevice(hashCode: Long): Long {
        val result = instanceManager.valueOf(hashCode) as ScanResult
        val device = result.device
        return instanceManager.allocate(device)
    }

    override fun getRSSI(hashCode: Long): Long {
        val result = instanceManager.valueOf(hashCode) as ScanResult
        return result.rssi.toLong()
    }

    override fun getScanRecord(hashCode: Long): Long? {
        val result = instanceManager.valueOf(hashCode) as ScanResult
        val record = result.scanRecord
        return if (record == null) null
        else instanceManager.allocate(record)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getAdvertisingSId(hashCode: Long): Long {
        val result = instanceManager.valueOf(hashCode) as ScanResult
        return result.advertisingSid.toLong()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getDataStatus(hashCode: Long): Long {
        val result = instanceManager.valueOf(hashCode) as ScanResult
        return result.dataStatus.toLong()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getPeriodicAdvertisingInterval(hashCode: Long): Long {
        val result = instanceManager.valueOf(hashCode) as ScanResult
        return result.periodicAdvertisingInterval.toLong()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getPrimaryPhy(hashCode: Long): Long {
        val result = instanceManager.valueOf(hashCode) as ScanResult
        return result.primaryPhy.toLong()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getSecondaryPhy(hashCode: Long): Long {
        val result = instanceManager.valueOf(hashCode) as ScanResult
        return result.secondaryPhy.toLong()
    }

    override fun getTimestampNanos(hashCode: Long): Long {
        val result = instanceManager.valueOf(hashCode) as ScanResult
        return result.timestampNanos
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getTxPower(hashCode: Long): Long {
        val result = instanceManager.valueOf(hashCode) as ScanResult
        return result.txPower.toLong()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getIsConnectable(hashCode: Long): Boolean {
        val result = instanceManager.valueOf(hashCode) as ScanResult
        return result.isConnectable
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getIsLegacy(hashCode: Long): Boolean {
        val result = instanceManager.valueOf(hashCode) as ScanResult
        return result.isLegacy
    }
}