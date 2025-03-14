package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.AdvertiseSettings
import android.os.Build
import androidx.annotation.RequiresApi

class AdvertiseSettingsImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
    PigeonApiAdvertiseSettings(registrar) {
    override fun getMode(pigeon_instance: AdvertiseSettings): Long {
        return pigeon_instance.mode.toLong()
    }

    override fun getTimeout(pigeon_instance: AdvertiseSettings): Long {
        return pigeon_instance.timeout.toLong()
    }

    override fun getTxPowerLevel(pigeon_instance: AdvertiseSettings): Long {
        return pigeon_instance.txPowerLevel.toLong()
    }

    override fun isConnectable(pigeon_instance: AdvertiseSettings): Boolean {
        return pigeon_instance.isConnectable
    }

    @RequiresApi(Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
    override fun isDiscoverable(pigeon_instance: AdvertiseSettings): Boolean {
        return pigeon_instance.isDiscoverable
    }
}