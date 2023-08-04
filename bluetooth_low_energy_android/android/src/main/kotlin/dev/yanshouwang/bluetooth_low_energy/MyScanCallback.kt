package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult

class MyScanCallback(private val api: ScanCallbackFlutterApi, private val instanceManager: InstanceManager) : ScanCallback() {
    override fun onScanResult(callbackType: Int, result: ScanResult) {
        super.onScanResult(callbackType, result)
        val callbackType1 = callbackType.toLong()
        val resultHashCode = instanceManager.allocate(result)
        api.onScanResult(hashCode1, callbackType1, resultHashCode) {}
    }

    override fun onBatchScanResults(results: MutableList<ScanResult>) {
        super.onBatchScanResults(results)
        val resultHashCodes = results.map { result -> instanceManager.allocate(result) }
        api.onBatchScanResults(hashCode1, resultHashCodes) {}
    }

    override fun onScanFailed(errorCode: Int) {
        super.onScanFailed(errorCode)
        val errorCode1 = errorCode.toLong()
        api.onScanFailed(hashCode1, errorCode1) {}
    }
}