package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.le.ScanRecord
import android.os.Build
import android.os.ParcelUuid
import androidx.annotation.RequiresApi

class ScanRecordApi(private val instanceManager: InstanceManager) : ScanRecordHostApi {
    override fun getManufacturerSpecificData(hashCode: Long): Map<Long, ByteArray> {
        val record = instanceManager.valueOf(hashCode) as ScanRecord
        val data = mutableMapOf<Long, ByteArray>()
        val manufacturerSpecificData = record.manufacturerSpecificData
        val size = manufacturerSpecificData.size()
        for (index in 0 until size) {
            val key = manufacturerSpecificData.keyAt(index).toLong()
            val value = manufacturerSpecificData.valueAt(index)
            data[key] = value
        }
        return data
    }

    override fun getManufacturerSpecificDataWithId(hashCode: Long, manufacturerId: Long): ByteArray? {
        val record = instanceManager.valueOf(hashCode) as ScanRecord
        val manufacturerId1 = manufacturerId.toInt()
        return record.getManufacturerSpecificData(manufacturerId1)
    }

    override fun getBytes(hashCode: Long): ByteArray {
        val record = instanceManager.valueOf(hashCode) as ScanRecord
        return record.bytes
    }

    override fun getServiceData(hashCode: Long): Map<Long, ByteArray> {
        val record = instanceManager.valueOf(hashCode) as ScanRecord
        return record.serviceData.mapKeys { item -> instanceManager.allocate(item.key) }
    }

    override fun getServiceDataWithUUID(hashCode: Long, serviceDataUuidHashCode: Long): ByteArray? {
        val record = instanceManager.valueOf(hashCode) as ScanRecord
        val serviceDataUUID = instanceManager.valueOf(serviceDataUuidHashCode) as ParcelUuid
        return record.getServiceData(serviceDataUUID)
    }

    override fun getAdvertiseFlags(hashCode: Long): Long {
        val record = instanceManager.valueOf(hashCode) as ScanRecord
        return record.advertiseFlags.toLong()
    }

    override fun getDeviceName(hashCode: Long): String? {
        val record = instanceManager.valueOf(hashCode) as ScanRecord
        return record.deviceName
    }

    override fun getServiceUUIDs(hashCode: Long): List<Long> {
        val record = instanceManager.valueOf(hashCode) as ScanRecord
        return record.serviceUuids.map { uuid -> instanceManager.allocate(uuid) }
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun getServiceSolicitationUUIDs(hashCode: Long): List<Long> {
        val record = instanceManager.valueOf(hashCode) as ScanRecord
        return record.serviceSolicitationUuids.map { uuid -> instanceManager.allocate(uuid) }
    }

    override fun getTxPowerLevel(hashCode: Long): Long {
        val record = instanceManager.valueOf(hashCode) as ScanRecord
        return record.txPowerLevel.toLong()
    }
}