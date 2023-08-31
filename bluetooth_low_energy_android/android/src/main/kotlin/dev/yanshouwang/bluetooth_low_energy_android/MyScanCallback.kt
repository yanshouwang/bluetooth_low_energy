package dev.yanshouwang.bluetooth_low_energy_android

import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult

class MyScanCallback(private val myCentralController: MyCentralController) : ScanCallback() {
    override fun onScanFailed(errorCode: Int) {
        super.onScanFailed(errorCode)
        myCentralController.onScanFailed(errorCode)
    }

    override fun onScanResult(callbackType: Int, result: ScanResult) {
        super.onScanResult(callbackType, result)
        myCentralController.onScanResult(result)
    }
}