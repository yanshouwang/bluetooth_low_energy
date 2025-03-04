package dev.hebei.bluetooth_low_energy_android

import android.content.Context
import android.content.pm.PackageManager

class ContextApi(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) : PigeonApiContext(registrar) {
    override fun getPackageManager(pigeon_instance: Context): PackageManager {
        return pigeon_instance.packageManager
    }
}