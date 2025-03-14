package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.ScanFilter
import android.os.Build
import android.os.ParcelUuid
import androidx.annotation.RequiresApi

class ScanFilterBuilderImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
    PigeonApiScanFilterBuilder(registrar) {
    override fun pigeon_defaultConstructor(): ScanFilter.Builder {
        return ScanFilter.Builder()
    }

    override fun build(pigeon_instance: ScanFilter.Builder): ScanFilter {
        return pigeon_instance.build()
    }

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun setAdvertisingDataType(
        pigeon_instance: ScanFilter.Builder, advertisingDataType: Long
    ): ScanFilter.Builder {
        return pigeon_instance.setAdvertisingDataType(advertisingDataType.toInt())
    }

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun setAdvertisingDataTypeWithData(
        pigeon_instance: ScanFilter.Builder,
        advertisingDataType: Long,
        advertisingData: ByteArray,
        advertisingDataMask: ByteArray
    ): ScanFilter.Builder {
        return pigeon_instance.setAdvertisingDataTypeWithData(
            advertisingDataType.toInt(), advertisingData, advertisingDataMask
        )
    }

    override fun setDeviceAddress(pigeon_instance: ScanFilter.Builder, deviceAddress: String): ScanFilter.Builder {
        return pigeon_instance.setDeviceAddress(deviceAddress)
    }

    override fun setDeviceName(pigeon_instance: ScanFilter.Builder, deviceName: String): ScanFilter.Builder {
        return pigeon_instance.setDeviceName(deviceName)
    }

    override fun setManufacturerData1(
        pigeon_instance: ScanFilter.Builder, manufacturerId: Long, manufacturerData: ByteArray
    ): ScanFilter.Builder {
        return pigeon_instance.setManufacturerData(manufacturerId.toInt(), manufacturerData)
    }

    override fun setManufacturerData2(
        pigeon_instance: ScanFilter.Builder,
        manufacturerId: Long,
        manufacturerData: ByteArray,
        manufacturerDataMask: ByteArray
    ): ScanFilter.Builder {
        return pigeon_instance.setManufacturerData(manufacturerId.toInt(), manufacturerData, manufacturerDataMask)
    }

    override fun setServiceData1(
        pigeon_instance: ScanFilter.Builder, serviceDataUuid: ParcelUuid, serviceData: ByteArray
    ): ScanFilter.Builder {
        return pigeon_instance.setServiceData(serviceDataUuid, serviceData)
    }

    override fun setServiceData2(
        pigeon_instance: ScanFilter.Builder,
        serviceDataUuid: ParcelUuid,
        serviceData: ByteArray,
        serviceDataMask: ByteArray
    ): ScanFilter.Builder {
        return pigeon_instance.setServiceData(serviceDataUuid, serviceData, serviceDataMask)
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun setServiceSolicitationUuid1(
        pigeon_instance: ScanFilter.Builder, serviceSolicitationUuid: ParcelUuid?
    ): ScanFilter.Builder {
        return pigeon_instance.setServiceSolicitationUuid(serviceSolicitationUuid)
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun setServiceSolicitationUuid2(
        pigeon_instance: ScanFilter.Builder, serviceSolicitationUuid: ParcelUuid?, solicitationUuidMask: ParcelUuid?
    ): ScanFilter.Builder {
        return pigeon_instance.setServiceSolicitationUuid(serviceSolicitationUuid, solicitationUuidMask)
    }

    override fun setServiceUuid1(pigeon_instance: ScanFilter.Builder, serviceUuid: ParcelUuid): ScanFilter.Builder {
        return pigeon_instance.setServiceUuid(serviceUuid)
    }

    override fun setServiceUuid2(
        pigeon_instance: ScanFilter.Builder, serviceUuid: ParcelUuid, uuidMask: ParcelUuid
    ): ScanFilter.Builder {
        return pigeon_instance.setServiceUuid(serviceUuid, uuidMask)
    }
}