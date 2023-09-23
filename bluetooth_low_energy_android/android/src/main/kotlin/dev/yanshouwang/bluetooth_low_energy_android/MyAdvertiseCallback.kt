package dev.yanshouwang.bluetooth_low_energy_android

import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseSettings

class MyAdvertiseCallback(private val myPeripheralManager: MyPeripheralManager) : AdvertiseCallback() {
    override fun onStartSuccess(settingsInEffect: AdvertiseSettings) {
        super.onStartSuccess(settingsInEffect)
        myPeripheralManager.onStartSuccess(settingsInEffect)
    }

    override fun onStartFailure(errorCode: Int) {
        super.onStartFailure(errorCode)
        myPeripheralManager.onStartFailure(errorCode)
    }
}