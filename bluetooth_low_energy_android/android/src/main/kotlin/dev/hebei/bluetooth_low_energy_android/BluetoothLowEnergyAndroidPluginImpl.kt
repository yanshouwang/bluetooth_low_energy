package dev.hebei.bluetooth_low_energy_android

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.PluginRegistry

class BluetoothLowEnergyAndroidPluginImpl(
    registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar, val instance: BluetoothLowEnergyAndroidPlugin
) : PigeonApiBluetoothLowEnergyAndroidPlugin(registrar) {
    override fun instance(): BluetoothLowEnergyAndroidPlugin {
        return instance
    }

    override fun applicationContext(pigeon_instance: BluetoothLowEnergyAndroidPlugin): Context {
        return pigeon_instance.applicationContext
    }

    override fun getActivity(pigeon_instance: BluetoothLowEnergyAndroidPlugin): Activity? {
        return pigeon_instance.gatActivity()
    }

    override fun addRequestPermissionsResultListener(
        pigeon_instance: BluetoothLowEnergyAndroidPlugin, listener: PluginRegistry.RequestPermissionsResultListener
    ) {
        pigeon_instance.addRequestPermissionsResultListener(listener)
    }

    override fun removeRequestPermissionsResultListener(
        pigeon_instance: BluetoothLowEnergyAndroidPlugin, listener: PluginRegistry.RequestPermissionsResultListener
    ) {
        pigeon_instance.removeRequestPermissionsResultListener(listener)
    }

    override fun addActivityResultListener(
        pigeon_instance: BluetoothLowEnergyAndroidPlugin, listener: PluginRegistry.ActivityResultListener
    ) {
        pigeon_instance.addActivityResultListener(listener)
    }

    override fun removeActivityResultListener(
        pigeon_instance: BluetoothLowEnergyAndroidPlugin, listener: PluginRegistry.ActivityResultListener
    ) {
        pigeon_instance.removeActivityResultListener(listener)
    }
}