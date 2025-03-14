package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.AdvertiseSettings
import android.os.Build
import androidx.annotation.RequiresApi

class AdvertiseSettingsBuilderImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
    PigeonApiAdvertiseSettingsBuilder(registrar) {
    override fun pigeon_defaultConstructor(): AdvertiseSettings.Builder {
        return AdvertiseSettings.Builder()
    }

    override fun build(pigeon_instance: AdvertiseSettings.Builder): AdvertiseSettings {
        return pigeon_instance.build()
    }

    override fun setAdvertiseMode(
        pigeon_instance: AdvertiseSettings.Builder, advertiseMode: Long
    ): AdvertiseSettings.Builder {
        return pigeon_instance.setAdvertiseMode(advertiseMode.toInt())
    }

    override fun setConnectable(
        pigeon_instance: AdvertiseSettings.Builder, connectable: Boolean
    ): AdvertiseSettings.Builder {
        return pigeon_instance.setConnectable(connectable)
    }

    @RequiresApi(Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
    override fun setDiscoverable(
        pigeon_instance: AdvertiseSettings.Builder, discoverable: Boolean
    ): AdvertiseSettings.Builder {
        return pigeon_instance.setDiscoverable(discoverable)
    }

    override fun setTimeout(
        pigeon_instance: AdvertiseSettings.Builder, timeoutMillis: Long
    ): AdvertiseSettings.Builder {
        return pigeon_instance.setTimeout(timeoutMillis.toInt())
    }

    override fun setTxPowerLevel(
        pigeon_instance: AdvertiseSettings.Builder, txPowerLevel: Long
    ): AdvertiseSettings.Builder {
        return pigeon_instance.setTxPowerLevel(txPowerLevel.toInt())
    }
}