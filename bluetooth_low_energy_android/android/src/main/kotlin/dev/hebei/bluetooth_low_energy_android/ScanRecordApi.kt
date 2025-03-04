package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.ScanRecord
import android.os.Build
import android.os.ParcelUuid
import androidx.annotation.RequiresApi

class ScanRecordApi(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) : PigeonApiScanRecord(registrar) {
    override fun getAdvertiseFlags(pigeon_instance: ScanRecord): Long {
        return pigeon_instance.advertiseFlags.toLong()
    }

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun getAdvertisingDataMap(pigeon_instance: ScanRecord): Map<Long, ByteArray> {
        return pigeon_instance.advertisingDataMap.mapKeys { it.key.toLong() }
    }

    override fun getBytes(pigeon_instance: ScanRecord): ByteArray {
        return pigeon_instance.bytes
    }

    override fun getDeviceName(pigeon_instance: ScanRecord): String? {
        return pigeon_instance.deviceName
    }

    override fun getManufacturerSpecificData1(pigeon_instance: ScanRecord): Map<Long, ByteArray> {
        return pigeon_instance.manufacturerSpecificData.args
    }

    override fun getManufacturerSpecificData2(pigeon_instance: ScanRecord, manufacturerId: Long): ByteArray? {
        return pigeon_instance.getManufacturerSpecificData(manufacturerId.toInt())
    }

    override fun getServiceData1(pigeon_instance: ScanRecord): Map<ParcelUuid, ByteArray> {
        return pigeon_instance.serviceData
    }

    override fun getServiceData2(pigeon_instance: ScanRecord, serviceDataUuid: ParcelUuid): ByteArray? {
        return pigeon_instance.getServiceData(serviceDataUuid)
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun getServiceSolicitationUuids(pigeon_instance: ScanRecord): List<ParcelUuid> {
        return pigeon_instance.serviceSolicitationUuids
    }

    override fun getServiceUuids(pigeon_instance: ScanRecord): List<ParcelUuid> {
        return pigeon_instance.serviceUuids
    }

    override fun getTxPowerLevel(pigeon_instance: ScanRecord): Long {
        return pigeon_instance.txPowerLevel.toLong()
    }
}