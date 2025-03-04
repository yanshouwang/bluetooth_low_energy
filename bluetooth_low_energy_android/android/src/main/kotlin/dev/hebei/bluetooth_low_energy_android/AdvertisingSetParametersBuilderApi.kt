package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.AdvertisingSetParameters
import android.os.Build
import androidx.annotation.RequiresApi

class AdvertisingSetParametersBuilderApi(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiAdvertisingSetParametersBuilder(registrar) {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun pigeon_defaultConstructor(): AdvertisingSetParameters.Builder {
        return AdvertisingSetParameters.Builder()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun build(pigeon_instance: AdvertisingSetParameters.Builder): AdvertisingSetParameters {
        return pigeon_instance.build()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setAnonymous(
        pigeon_instance: AdvertisingSetParameters.Builder, isAnonymous: Boolean
    ): AdvertisingSetParameters.Builder {
        return pigeon_instance.setAnonymous(isAnonymous)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setConnectable(
        pigeon_instance: AdvertisingSetParameters.Builder, connectable: Boolean
    ): AdvertisingSetParameters.Builder {
        return pigeon_instance.setConnectable(connectable)
    }

    @RequiresApi(Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
    override fun setDiscoverable(
        pigeon_instance: AdvertisingSetParameters.Builder, discoverable: Boolean
    ): AdvertisingSetParameters.Builder {
        return pigeon_instance.setDiscoverable(discoverable)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setIncludeTxPower(
        pigeon_instance: AdvertisingSetParameters.Builder, includeTxPower: Boolean
    ): AdvertisingSetParameters.Builder {
        return pigeon_instance.setIncludeTxPower(includeTxPower)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setInterval(
        pigeon_instance: AdvertisingSetParameters.Builder, interval: Long
    ): AdvertisingSetParameters.Builder {
        return pigeon_instance.setInterval(interval.toInt())
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setLegacyMode(
        pigeon_instance: AdvertisingSetParameters.Builder, isLegacy: Boolean
    ): AdvertisingSetParameters.Builder {
        return pigeon_instance.setLegacyMode(isLegacy)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setPrimaryPhy(
        pigeon_instance: AdvertisingSetParameters.Builder, primaryPhy: Long
    ): AdvertisingSetParameters.Builder {
        return pigeon_instance.setPrimaryPhy(primaryPhy.toInt())
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setScannable(
        pigeon_instance: AdvertisingSetParameters.Builder, scannable: Boolean
    ): AdvertisingSetParameters.Builder {
        return pigeon_instance.setScannable(scannable)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setSecondaryPhy(
        pigeon_instance: AdvertisingSetParameters.Builder, secondaryPhy: Long
    ): AdvertisingSetParameters.Builder {
        return pigeon_instance.setSecondaryPhy(secondaryPhy.toInt())
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setTxPowerLevel(
        pigeon_instance: AdvertisingSetParameters.Builder, txPowerLevel: Long
    ): AdvertisingSetParameters.Builder {
        return pigeon_instance.setTxPowerLevel(txPowerLevel.toInt())
    }
}