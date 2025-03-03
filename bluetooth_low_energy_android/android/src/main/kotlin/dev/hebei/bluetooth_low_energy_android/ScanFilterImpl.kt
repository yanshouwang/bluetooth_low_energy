package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.os.ParcelUuid

class ScanFilterImpl(registrar: BluetoothLowEnergyPigeonProxyApiRegistrar) : PigeonApiScanFilter(registrar) {
    override fun getAdvertisingData(pigeon_instance: ScanFilter): ByteArray? {
        return pigeon_instance.advertisingData
    }

    override fun getAdvertisingDataMask(pigeon_instance: ScanFilter): ByteArray? {
        return pigeon_instance.advertisingDataMask
    }

    override fun getAdvertisingDataType(pigeon_instance: ScanFilter): Long {
        return pigeon_instance.advertisingDataType.toLong()
    }

    override fun getDeviceAddress(pigeon_instance: ScanFilter): String? {
        return pigeon_instance.deviceAddress
    }

    override fun getDeviceName(pigeon_instance: ScanFilter): String? {
        return pigeon_instance.deviceName
    }

    override fun getManufacturerData(pigeon_instance: ScanFilter): ByteArray? {
        return pigeon_instance.manufacturerData
    }

    override fun getManufacturerDataMask(pigeon_instance: ScanFilter): ByteArray? {
        return pigeon_instance.manufacturerDataMask
    }

    override fun getManufacturerId(pigeon_instance: ScanFilter): Long {
        return pigeon_instance.manufacturerId.toLong()
    }

    override fun getServiceData(pigeon_instance: ScanFilter): ByteArray? {
        return pigeon_instance.serviceData
    }

    override fun getServiceDataMask(pigeon_instance: ScanFilter): ByteArray? {
        return pigeon_instance.serviceDataMask
    }

    override fun getServiceDataUuid(pigeon_instance: ScanFilter): ParcelUuid? {
        return pigeon_instance.serviceDataUuid
    }

    override fun getServiceSolicitationUuid(pigeon_instance: ScanFilter): ParcelUuid? {
        return pigeon_instance.serviceSolicitationUuid
    }

    override fun getServiceSolicitationUuidMask(pigeon_instance: ScanFilter): ParcelUuid? {
        return pigeon_instance.serviceSolicitationUuidMask
    }

    override fun getServiceUuid(pigeon_instance: ScanFilter): ParcelUuid? {
        return pigeon_instance.serviceUuid
    }

    override fun getServiceUuidMask(pigeon_instance: ScanFilter): ParcelUuid? {
        return pigeon_instance.serviceUuidMask
    }

    override fun matches(pigeon_instance: ScanFilter, scanResult: ScanResult): Boolean {
        return pigeon_instance.matches(scanResult)
    }
}