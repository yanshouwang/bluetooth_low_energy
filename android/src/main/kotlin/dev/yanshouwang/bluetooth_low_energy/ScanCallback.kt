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
        val uuid = result.device.address.toUUID()
        val data = if (record == null) {
            ByteString.EMPTY
        } else {
            ByteString.copyFrom(record.bytes)
        }
        val connectable = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            result.isConnectable
        } else {
            // Just return true before Android 8.0
            true
        }
        val advertisementValue = advertisement {
            this.uuid = uuid
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

/**
 * Converts MAC address to UUID.
 */
fun String.toUUID(): String {
    val node = filter { char -> char != ':' }.lowercase()
    // We don't know the timestamp of the bluetooth device, use nil UUID as prefix.
    return "00000000-0000-0000-$node"
}

/**
 * Converts UUID to MAC address.
 */
fun String.toAddress(): String {
    return takeLast(12).chunked(2).joinToString(":").uppercase()
}