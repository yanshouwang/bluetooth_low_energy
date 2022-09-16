package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.os.Build
import com.google.protobuf.ByteString
import dev.yanshouwang.bluetooth_low_energy.proto.advertisement

object ScanCallback : ScanCallback() {
    override fun onScanFailed(errorCode: Int) {
        super.onScanFailed(errorCode)
        val error = Throwable("Start scan failed with code: $errorCode")
        instances[CentralManagerHostApi.KEY_START_SCAN_ERROR] = error
    }

    override fun onScanResult(callbackType: Int, result: ScanResult) {
        super.onScanResult(callbackType, result)
        val record = result.scanRecord
        val data = if (record == null) {
            ByteString.EMPTY
        } else {
            ByteString.copyFrom(record.bytes)
        }
        val connectable = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            result.isConnectable
        } else {
            true
        }
        val advertisementValue = advertisement {
            this.uuid = result.device.uuid
            this.data = data
            this.connectable = connectable
            this.rssi = result.rssi
        }.toByteArray()
        centralManagerFlutterApi.notifyAdvertisement(advertisementValue) {}
    }

    override fun onBatchScanResults(results: MutableList<ScanResult>) {
        super.onBatchScanResults(results)

        for (result in results) {
            onScanResult(ScanSettings.CALLBACK_TYPE_ALL_MATCHES, result)
        }
    }
}
