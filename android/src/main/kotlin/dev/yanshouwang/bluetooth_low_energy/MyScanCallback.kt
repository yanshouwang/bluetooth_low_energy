package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.os.Build
import android.util.Log
import com.google.protobuf.ByteString
import dev.yanshouwang.bluetooth_low_energy.proto.advertisement
import dev.yanshouwang.bluetooth_low_energy.proto.serviceData
import dev.yanshouwang.bluetooth_low_energy.proto.uUID

object MyScanCallback : ScanCallback() {
    override fun onScanFailed(errorCode: Int) {
        Log.d(TAG, "onScanFailed: $errorCode")
        super.onScanFailed(errorCode)
        val error = BluetoothLowEnergyException("Start scan failed with code: $errorCode")
        items[KEY_START_SCAN_ERROR] = error
    }

    override fun onScanResult(callbackType: Int, result: ScanResult) {
        Log.d(TAG, "onScanResult: $callbackType, $result")
        super.onScanResult(callbackType, result)
        val advertisementValue = advertisement {
            this.uuid = uUID {
                this.value = result.device.uuidString
            }
            this.rssi = result.rssi
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                this.connectable = result.isConnectable
            }
            val scanRecord = result.scanRecord
            if (scanRecord == null) {
                this.data = ByteString.EMPTY
            } else {
                this.data = ByteString.copyFrom(scanRecord.bytes)
                val deviceName = scanRecord.deviceName
                if (deviceName != null) {
                    this.localName = deviceName
                }
                val manufacturerSpecificData = scanRecord.rawManufacturerSpecificData
                if (manufacturerSpecificData != null) {
                    this.manufacturerSpecificData = ByteString.copyFrom(manufacturerSpecificData)
                }
                val serviceDatas = scanRecord.serviceData.map { entry ->
                    serviceData {
                        this.uuid = uUID {
                            this.value = entry.key.toString()
                        }
                        this.data = ByteString.copyFrom(entry.value)
                    }
                }
                this.serviceDatas.addAll(serviceDatas)
                val serviceUUIDs = scanRecord.serviceUuids
                if (serviceUUIDs != null) {
                    val uuids = serviceUUIDs.map { uuid ->
                        uUID {
                            this.value = uuid.toString()
                        }
                    }
                    this.serviceUuids.addAll(uuids)
                }
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    val uuids = scanRecord.serviceSolicitationUuids.map { uuid ->
                        uUID {
                            this.value = uuid.toString()
                        }
                    }
                    this.solicitedServiceUuids.addAll(uuids)
                }
                this.txPowerLevel = scanRecord.txPowerLevel
            }
        }.toByteArray()
        centralFlutterApi.notifyAdvertisement(advertisementValue) {}
    }

    override fun onBatchScanResults(results: MutableList<ScanResult>) {
        super.onBatchScanResults(results)
        Log.d(TAG, "onBatchScanResults: $results")
        for (result in results) {
            onScanResult(ScanSettings.CALLBACK_TYPE_ALL_MATCHES, result)
        }
    }
}
