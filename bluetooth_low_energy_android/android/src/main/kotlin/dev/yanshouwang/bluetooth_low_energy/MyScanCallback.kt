package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanRecord
import android.bluetooth.le.ScanResult

class MyScanCallback(private val instanceManager: MyInstanceManager, private val api: MyCentralControllerFlutterApi) : ScanCallback() {
    companion object {
        private const val DATA_TYPE_MANUFACTURER_SPECIFIC_DATA = 0xff.toByte()
    }


    var scanFailedCallback: ((Int) -> Unit)? = null

    override fun onScanFailed(errorCode: Int) {
        val callback = scanFailedCallback ?: return
        callback(errorCode)
        scanFailedCallback = null
    }

    override fun onScanResult(callbackType: Int, result: ScanResult) {
        val device = result.device
        val hashCode = device.hashCode()
        val instance = instanceManager.instanceOf(hashCode)
        val myPeripheral = if (instance is MyPeripheral) instance
        else MyPeripheral(device, instanceManager)
        val peripheralArgs = myPeripheral.toArgs()
        val rssi = result.rssi.toLong()
        val record = result.scanRecord
        val advertisementArgs = if (record == null) {
            MyAdvertisementArgs()
        } else {
            val name = record.deviceName
            val manufacturerSpecificData = record.rawValues[DATA_TYPE_MANUFACTURER_SPECIFIC_DATA]
            MyAdvertisementArgs(name, manufacturerSpecificData)
        }
        api.onDiscovered(peripheralArgs, rssi, advertisementArgs) {}
    }
}

private val ScanRecord.rawValues: Map<Byte, ByteArray>
    get() {
        val rawValues = mutableMapOf<Byte, ByteArray>()
        var begin = 0
        while (begin < bytes.size) {
            val length = bytes[begin++].toInt() and 0xff
            if (length == 0) {
                break
            }
            val end = begin + length
            val type = bytes[begin++]
            val value = bytes.slice(begin until end).toByteArray()
            rawValues[type] = value
            begin = end
        }
        return rawValues.toMap()
    }
