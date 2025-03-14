package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.AdvertisingSet
import android.bluetooth.le.AdvertisingSetParameters
import android.bluetooth.le.PeriodicAdvertisingParameters
import android.os.Build
import androidx.annotation.RequiresApi

class AdvertisingSetImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
    PigeonApiAdvertisingSet(registrar) {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun enableAdvertising(
        pigeon_instance: AdvertisingSet, enable: Boolean, duration: Long, maxExtendedAdvertisingEvents: Long
    ) {
        pigeon_instance.enableAdvertising(enable, duration.toInt(), maxExtendedAdvertisingEvents.toInt())
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setAdvertisingData(pigeon_instance: AdvertisingSet, advertiseData: AdvertiseData) {
        pigeon_instance.setAdvertisingData(advertiseData)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setAdvertisingParameters(pigeon_instance: AdvertisingSet, parameters: AdvertisingSetParameters) {
        pigeon_instance.setAdvertisingParameters(parameters)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setPeriodicAdvertisingData(pigeon_instance: AdvertisingSet, periodicData: AdvertiseData) {
        pigeon_instance.setPeriodicAdvertisingData(periodicData)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setPeriodicAdvertisingEnabled(pigeon_instance: AdvertisingSet, enable: Boolean) {
        pigeon_instance.setPeriodicAdvertisingEnabled(enable)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setPeriodicAdvertisingParameters(
        pigeon_instance: AdvertisingSet, parameters: PeriodicAdvertisingParameters
    ) {
        pigeon_instance.setPeriodicAdvertisingParameters(parameters)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setScanResponseData(pigeon_instance: AdvertisingSet, scanResponse: AdvertiseData) {
        pigeon_instance.setScanResponseData(scanResponse)
    }
}