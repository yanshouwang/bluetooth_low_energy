package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseSettings

class AdvertiseCallbackImpl(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiAdvertiseCallback(registrar) {
    override fun pigeon_defaultConstructor(): AdvertiseCallback {
        return object : AdvertiseCallback() {
            override fun onStartFailure(errorCode: Int) {
                super.onStartFailure(errorCode)
                this@AdvertiseCallbackImpl.onStartFailure(this, errorCode.toLong()) {}
            }

            override fun onStartSuccess(settingsInEffect: AdvertiseSettings) {
                super.onStartSuccess(settingsInEffect)
                this@AdvertiseCallbackImpl.onStartSuccess(this, settingsInEffect) {}
            }
        }
    }
}