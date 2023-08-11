package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult

class MyScanCallback(private val myCentralController: MyCentralController) : ScanCallback() {
    override fun onScanFailed(errorCode: Int) {
        val error = IllegalStateException("Start discovery failed with error code: $errorCode")
        myCentralController.onScanFailed(error)
    }

    override fun onScanResult(callbackType: Int, result: ScanResult) {
        myCentralController.onScanResult(result)
    }
}