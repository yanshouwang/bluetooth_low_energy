package dev.yanshouwang.bluetooth_low_energy_android

import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseSettings

class MyAdvertiseCallback(private val peripheralManager: MyPeripheralManager) : AdvertiseCallback() {
    override fun onStartSuccess(settingsInEffect: AdvertiseSettings) {
        super.onStartSuccess(settingsInEffect)
        peripheralManager.onStartSuccess(settingsInEffect)
    }

    override fun onStartFailure(errorCode: Int) {
        super.onStartFailure(errorCode)
        peripheralManager.onStartFailure(errorCode)
    }
}