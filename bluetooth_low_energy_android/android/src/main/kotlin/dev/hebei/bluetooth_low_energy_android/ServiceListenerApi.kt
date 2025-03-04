package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothProfile

class ServiceListenerApi(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiServiceListener(registrar) {
    override fun pigeon_defaultConstructor(): BluetoothProfile.ServiceListener {
        return object : BluetoothProfile.ServiceListener {
            override fun onServiceConnected(profile: Int, proxy: BluetoothProfile) {
                this@ServiceListenerApi.onServiceConnected(this, profile.toLong(), proxy) {}
            }

            override fun onServiceDisconnected(profile: Int) {
                this@ServiceListenerApi.onServiceDisconnected(this, profile.toLong()) {}
            }
        }
    }
}