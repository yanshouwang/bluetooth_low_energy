package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.TransportDiscoveryData
import android.os.Build
import android.os.ParcelUuid
import androidx.annotation.RequiresApi

class AdvertiseDataBuilderImpl(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiAdvertiseDataBuilder(registrar) {
    override fun pigeon_defaultConstructor(): AdvertiseData.Builder {
        return AdvertiseData.Builder()
    }

    override fun addManufacturerData(
        pigeon_instance: AdvertiseData.Builder, manufacturerId: Long, manufacturerSpecificData: ByteArray
    ): AdvertiseData.Builder {
        return pigeon_instance.addManufacturerData(manufacturerId.toInt(), manufacturerSpecificData)
    }

    override fun addServiceData(
        pigeon_instance: AdvertiseData.Builder, serviceDataUuid: ParcelUuid, serviceData: ByteArray
    ): AdvertiseData.Builder {
        return pigeon_instance.addServiceData(serviceDataUuid, serviceData)
    }

    @RequiresApi(Build.VERSION_CODES.S)
    override fun addServiceSolicitationUuid(
        pigeon_instance: AdvertiseData.Builder, serviceSolicitationUuid: ParcelUuid
    ): AdvertiseData.Builder {
        return pigeon_instance.addServiceSolicitationUuid(serviceSolicitationUuid)
    }

    override fun addServiceUuid(
        pigeon_instance: AdvertiseData.Builder, serviceUuid: ParcelUuid
    ): AdvertiseData.Builder {
        return pigeon_instance.addServiceUuid(serviceUuid)
    }

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun addTransportDiscoveryData(
        pigeon_instance: AdvertiseData.Builder, transportDiscoveryData: TransportDiscoveryData
    ): AdvertiseData.Builder {
        return pigeon_instance.addTransportDiscoveryData(transportDiscoveryData)
    }

    override fun build(pigeon_instance: AdvertiseData.Builder): AdvertiseData {
        return pigeon_instance.build()
    }

    override fun setIncludeDeviceName(
        pigeon_instance: AdvertiseData.Builder, includeDeviceName: Boolean
    ): AdvertiseData.Builder {
        return pigeon_instance.setIncludeDeviceName(includeDeviceName)
    }

    override fun setIncludeTxPowerLevel(
        pigeon_instance: AdvertiseData.Builder, includeTxPowerLevel: Boolean
    ): AdvertiseData.Builder {
        return pigeon_instance.setIncludeTxPowerLevel(includeTxPowerLevel)
    }
}