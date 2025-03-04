package dev.hebei.bluetooth_low_energy_android

import android.content.pm.PackageManager

class PackageManagerApi(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiPackageManager(registrar) {
    override fun hasSystemFeature(pigeon_instance: PackageManager, featureName: Feature): Boolean {
        return pigeon_instance.hasSystemFeature(featureName.obj)
    }
}

val Feature.obj: String
    get() = when (this) {
        Feature.BLUETOOTH -> PackageManager.FEATURE_BLUETOOTH
        Feature.BLUETOOTH_LOW_ENERGY -> PackageManager.FEATURE_BLUETOOTH_LE
    }