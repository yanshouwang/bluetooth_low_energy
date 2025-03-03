package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.PeriodicAdvertisingParameters
import android.os.Build
import androidx.annotation.RequiresApi

class PeriodicAdvertisingParametersImpl(registrar: BluetoothLowEnergyPigeonProxyApiRegistrar) :
    PigeonApiPeriodicAdvertisingParameters(registrar) {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun getIncludeTxPower(pigeon_instance: PeriodicAdvertisingParameters): Boolean {
        return pigeon_instance.includeTxPower
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getInterval(pigeon_instance: PeriodicAdvertisingParameters): Long {
        return pigeon_instance.interval.toLong()
    }
}