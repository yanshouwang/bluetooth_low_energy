package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothClass
import android.os.Build
import androidx.annotation.RequiresApi

class BluetoothClassApi(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiBluetoothClass(registrar) {
    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun doesClassMatch(pigeon_instance: BluetoothClass, profile: Long): Boolean {
        return pigeon_instance.doesClassMatch(profile.toInt())
    }

    override fun getDeviceClass(pigeon_instance: BluetoothClass): Long {
        return pigeon_instance.deviceClass.toLong()
    }

    override fun getMajorDeviceClass(pigeon_instance: BluetoothClass): Long {
        return pigeon_instance.majorDeviceClass.toLong()
    }

    override fun hasService(pigeon_instance: BluetoothClass, service: Long): Boolean {
        return pigeon_instance.hasService(service.toInt())
    }
}