package dev.yanshouwang.bluetooth_low_energy_android

import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult

class MyScanCallback(manager: MyCentralManager) : ScanCallback() {
    private val mManager: MyCentralManager

    init {
        mManager = manager
    }

    override fun onScanFailed(errorCode: Int) {
        super.onScanFailed(errorCode)
        mManager.onScanFailed(errorCode)
    }

    override fun onScanResult(callbackType: Int, result: ScanResult) {
        super.onScanResult(callbackType, result)
        mManager.onScanResult(result)
    }
}