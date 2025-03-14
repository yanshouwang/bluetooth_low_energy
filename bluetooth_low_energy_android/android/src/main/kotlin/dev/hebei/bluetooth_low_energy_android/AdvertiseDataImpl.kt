package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.TransportDiscoveryData
import android.os.Build
import android.os.ParcelUuid
import android.util.SparseArray
import androidx.annotation.RequiresApi

class AdvertiseDataImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
    PigeonApiAdvertiseData(registrar) {
    override fun getIncludeDeviceName(pigeon_instance: AdvertiseData): Boolean {
        return pigeon_instance.includeDeviceName
    }

    override fun getIncludeTxPowerLevel(pigeon_instance: AdvertiseData): Boolean {
        return pigeon_instance.includeTxPowerLevel
    }

    override fun getManufacturerSpecificData(pigeon_instance: AdvertiseData): Map<Long, ByteArray> {
        return pigeon_instance.manufacturerSpecificData.args
    }

    override fun getServiceData(pigeon_instance: AdvertiseData): Map<ParcelUuid, ByteArray> {
        return pigeon_instance.serviceData
    }

    @RequiresApi(Build.VERSION_CODES.S)
    override fun getServiceSolicitationUuids(pigeon_instance: AdvertiseData): List<ParcelUuid> {
        return pigeon_instance.serviceSolicitationUuids
    }

    override fun getServiceUuids(pigeon_instance: AdvertiseData): List<ParcelUuid> {
        return pigeon_instance.serviceUuids
    }

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun getTransportDiscoveryData(pigeon_instance: AdvertiseData): List<TransportDiscoveryData> {
        return pigeon_instance.transportDiscoveryData
    }
}

val <E> SparseArray<E>.args: Map<Long, E>
    get() {
        var index = 0
        val size = size()
        val args = mutableMapOf<Long, E>()
        while (index < size) {
            val key = keyAt(index).toLong()
            val value = valueAt(index)
            args[key] = value
            index++
        }
        return args
    }
