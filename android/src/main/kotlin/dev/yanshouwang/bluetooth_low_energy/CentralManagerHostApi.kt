package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanSettings
import android.content.IntentFilter
import android.os.Build
import android.os.ParcelUuid
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api
import dev.yanshouwang.bluetooth_low_energy.proto.bluetoothState

object CentralManagerHostApi : Api.CentralManagerHostApi {
    const val KEY_START_SCAN_ERROR = "start-scan-error"
    const val KEY_CONNECT_RESULT = "connect-result"

    override fun getState(): ByteArray {
        return bluetoothState {
            val state = if (bluetoothAvailable) {
                bluetoothAdapter.state.bluetoothState
            } else {
                BluetoothState.Unsupported
            }
            this.number = state.ordinal
        }.toByteArray()
    }

    override fun addStateObserver() {
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        activity.registerReceiver(BluetoothAdapterStateChangedReceiver, filter)
    }

    override fun removeStateObserver() {
        activity.unregisterReceiver(BluetoothAdapterStateChangedReceiver)
    }

    override fun startScan(uuids: MutableList<String>?, result: Api.Result<Void>) {
        val filters = uuids?.map { uuid ->
            val serviceUUID = ParcelUuid.fromString(uuid)
            ScanFilter.Builder()
                .setServiceUuid(serviceUUID)
                .build()
        }
        val settings = ScanSettings.Builder()
            .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
            .build()
        bluetoothAdapter.bluetoothLeScanner.startScan(filters, settings, ScanCallback)
        // Use main handler.post to delay until ScanCallback.onScanFailed executed.
        mainHandler.post {
            val error = instances.remove<Throwable>(KEY_START_SCAN_ERROR)
            if (error == null) {
                result.success(null)
            } else {
                result.error(error)
            }
        }
    }

    override fun stopScan() {
        bluetoothAdapter.bluetoothLeScanner.stopScan(ScanCallback)
    }

    override fun connect(uuid: String, result: Api.Result<ByteArray>) {
        val device = bluetoothAdapter.getRemoteDevice(uuid)
        val autoConnect = false
        val gatt = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val transport = BluetoothDevice.TRANSPORT_LE
            device.connectGatt(activity, autoConnect, BluetoothGattCallback, transport)
        } else {
            device.connectGatt(activity, autoConnect, BluetoothGattCallback)
        }
        instances["${gatt.id}/${KEY_CONNECT_RESULT}"] = result
    }
}

val Int.bluetoothState
    get() = when (this) {
        BluetoothAdapter.STATE_OFF -> BluetoothState.PoweredOff
        BluetoothAdapter.STATE_TURNING_ON -> BluetoothState.PoweredOff
        BluetoothAdapter.STATE_ON -> BluetoothState.PoweredOn
        BluetoothAdapter.STATE_TURNING_OFF -> BluetoothState.PoweredOn
        else -> throw IllegalArgumentException()
    }