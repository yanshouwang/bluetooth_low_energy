package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult

class ScanCallbackImpl(registrar: BluetoothLowEnergyPigeonProxyApiRegistrar) : PigeonApiScanCallback(registrar) {
    override fun pigeon_defaultConstructor(): ScanCallback {
        return object : ScanCallback() {
            override fun onBatchScanResults(results: MutableList<ScanResult>) {
                super.onBatchScanResults(results)
                this@ScanCallbackImpl.onBatchScanResults(this, results) {}
            }

            override fun onScanFailed(errorCode: Int) {
                super.onScanFailed(errorCode)
                this@ScanCallbackImpl.onScanFailed(this, errorCode.toLong()) {}
            }

            override fun onScanResult(callbackType: Int, result: ScanResult) {
                super.onScanResult(callbackType, result)
                this@ScanCallbackImpl.onScanResult(this, result) {}
            }
        }
    }
}