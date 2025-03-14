package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.AdvertisingSetParameters
import android.os.Build
import androidx.annotation.RequiresApi

class AdvertisingSetParametersImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
    PigeonApiAdvertisingSetParameters(registrar) {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun getInterval(pigeon_instance: AdvertisingSetParameters): Long {
        return pigeon_instance.interval.toLong()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getPrimaryPhy(pigeon_instance: AdvertisingSetParameters): Long {
        return pigeon_instance.primaryPhy.toLong()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getSecondaryPhy(pigeon_instance: AdvertisingSetParameters): Long {
        return pigeon_instance.secondaryPhy.toLong()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getTxPowerLevel(pigeon_instance: AdvertisingSetParameters): Long {
        return pigeon_instance.txPowerLevel.toLong()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun includeTxPower(pigeon_instance: AdvertisingSetParameters): Boolean {
        return pigeon_instance.includeTxPower()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun isAnonymous(pigeon_instance: AdvertisingSetParameters): Boolean {
        return pigeon_instance.isAnonymous
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun isConnectable(pigeon_instance: AdvertisingSetParameters): Boolean {
        return pigeon_instance.isConnectable
    }

    @RequiresApi(Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
    override fun isDiscoverable(pigeon_instance: AdvertisingSetParameters): Boolean {
        return pigeon_instance.isDiscoverable
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun isLegacy(pigeon_instance: AdvertisingSetParameters): Boolean {
        return pigeon_instance.isLegacy
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun isScannable(pigeon_instance: AdvertisingSetParameters): Boolean {
        return pigeon_instance.isScannable
    }
}