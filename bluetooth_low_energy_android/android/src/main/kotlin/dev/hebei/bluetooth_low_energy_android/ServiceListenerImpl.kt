package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothProfile

class ServiceListenerImpl(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiServiceListener(registrar) {
    override fun pigeon_defaultConstructor(): BluetoothProfile.ServiceListener {
        return object : BluetoothProfile.ServiceListener {
            override fun onServiceConnected(profile: Int, proxy: BluetoothProfile) {
                this@ServiceListenerImpl.onServiceConnected(this, profile.toLong(), proxy) {}
            }

            override fun onServiceDisconnected(profile: Int) {
                this@ServiceListenerImpl.onServiceDisconnected(this, profile.toLong()) {}
            }
        }
    }
}