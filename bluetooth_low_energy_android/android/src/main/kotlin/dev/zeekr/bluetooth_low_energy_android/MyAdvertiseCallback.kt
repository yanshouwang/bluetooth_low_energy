package dev.zeekr.bluetooth_low_energy_android

import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseSettings

class MyAdvertiseCallback(manager: MyPeripheralManager) : AdvertiseCallback() {
    private val mManager: MyPeripheralManager

    init {
        mManager = manager
    }

    override fun onStartSuccess(settingsInEffect: AdvertiseSettings) {
        super.onStartSuccess(settingsInEffect)
        mManager.onStartSuccess(settingsInEffect)
    }

    override fun onStartFailure(errorCode: Int) {
        super.onStartFailure(errorCode)
        mManager.onStartFailure(errorCode)
    }
}