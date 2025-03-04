package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult

class ScanCallbackApi(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) : PigeonApiScanCallback(registrar) {
    override fun pigeon_defaultConstructor(): ScanCallback {
        return object : ScanCallback() {
            override fun onBatchScanResults(results: MutableList<ScanResult>) {
                super.onBatchScanResults(results)
                this@ScanCallbackApi.onBatchScanResults(this, results) {}
            }

            override fun onScanFailed(errorCode: Int) {
                super.onScanFailed(errorCode)
                this@ScanCallbackApi.onScanFailed(this, errorCode.toLong()) {}
            }

            override fun onScanResult(callbackType: Int, result: ScanResult) {
                super.onScanResult(callbackType, result)
                this@ScanCallbackApi.onScanResult(this, result) {}
            }
        }
    }
}