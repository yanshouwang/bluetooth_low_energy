package dev.hebei.bluetooth_low_energy_android

import android.content.pm.PackageManager

class PackageManagerImpl(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiPackageManager(registrar) {
    override fun hasSystemFeature(pigeon_instance: PackageManager, featureNameArgs: FeatureArgs): Boolean {
        val featureName = featureNameArgs.obj
        return pigeon_instance.hasSystemFeature(featureName)
    }
}

val FeatureArgs.obj: String
    get() = when (this) {
        FeatureArgs.BLUETOOTH -> PackageManager.FEATURE_BLUETOOTH
        FeatureArgs.BLUETOOTH_LOW_ENERGY -> PackageManager.FEATURE_BLUETOOTH_LE
    }