package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.PeriodicAdvertisingParameters
import android.os.Build
import androidx.annotation.RequiresApi

class PeriodicAdvertisingParametersBuilderImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
    PigeonApiPeriodicAdvertisingParametersBuilder(registrar) {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun pigeon_defaultConstructor(): PeriodicAdvertisingParameters.Builder {
        return PeriodicAdvertisingParameters.Builder()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun build(pigeon_instance: PeriodicAdvertisingParameters.Builder): PeriodicAdvertisingParameters {
        return pigeon_instance.build()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setIncludeTxPower(
        pigeon_instance: PeriodicAdvertisingParameters.Builder, includeTxPower: Boolean
    ): PeriodicAdvertisingParameters.Builder {
        return pigeon_instance.setIncludeTxPower(includeTxPower)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun setInterval(
        pigeon_instance: PeriodicAdvertisingParameters.Builder, interval: Long
    ): PeriodicAdvertisingParameters.Builder {
        return pigeon_instance.setInterval(interval.toInt())
    }
}