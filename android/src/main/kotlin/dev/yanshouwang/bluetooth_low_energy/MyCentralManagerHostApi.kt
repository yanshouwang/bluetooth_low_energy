package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanSettings
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Build
import android.os.ParcelUuid
import androidx.core.app.ActivityCompat
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api
import dev.yanshouwang.bluetooth_low_energy.proto.BluetoothState
import dev.yanshouwang.bluetooth_low_energy.proto.UUID

object MyCentralManagerHostApi : Api.CentralManagerHostApi {
    const val REQUEST_CODE = 443
    const val KEY_AUTHORIZE_RESULT = "AUTHORIZE_RESULT"
    const val KEY_START_SCAN_ERROR = "START_SCAN_ERROR"
    const val KEY_CONNECT_RESULT = "CONNECT_RESULT"
    override fun authorize(result: Api.Result<Boolean>) {
        val permissions = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            arrayOf(
                android.Manifest.permission.ACCESS_FINE_LOCATION,
                android.Manifest.permission.BLUETOOTH_SCAN,
                android.Manifest.permission.BLUETOOTH_CONNECT
            )
        } else {
            arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION)
        }
        val authorized = permissions.all { permission ->
            ActivityCompat.checkSelfPermission(activity, permission) == PackageManager.PERMISSION_GRANTED
        }
        if (authorized) {
            result.success(true)
        } else {
            ActivityCompat.requestPermissions(activity, permissions, REQUEST_CODE)
            instances[KEY_AUTHORIZE_RESULT] = result
        }
    }

    override fun getState(): Long {
        val state = if (bluetoothAvailable) {
            bluetoothAdapter.state.bluetoothState
        } else {
            BluetoothState.BLUETOOTH_STATE_UNSUPPORTED
        }
        return state.number.toLong()
    }

    override fun addStateObserver() {
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        activity.registerReceiver(MyBluetoothStateBroadcastReceiver, filter)
    }

    override fun removeStateObserver() {
        activity.unregisterReceiver(MyBluetoothStateBroadcastReceiver)
    }

    override fun startScan(uuidBuffers: MutableList<ByteArray>?, result: Api.Result<Void>) {
        val filters = uuidBuffers?.map { buffer ->
            val uuid = UUID.parseFrom(buffer).value
            val serviceUUID = ParcelUuid.fromString(uuid)
            ScanFilter.Builder().setServiceUuid(serviceUUID).build()
        }
        val settings = ScanSettings.Builder().setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY).build()
        bluetoothAdapter.bluetoothLeScanner.startScan(filters, settings, MyScanCallback)
        // Use main handler.post to delay until ScanCallback.onScanFailed executed.
        mainHandler.post {
            val error = instances.free<Throwable>(KEY_START_SCAN_ERROR)
            if (error == null) {
                result.success(null)
            } else {
                result.error(error)
            }
        }
    }

    override fun stopScan() {
        bluetoothAdapter.bluetoothLeScanner.stopScan(MyScanCallback)
    }

    override fun connect(uuidBuffer: ByteArray, result: Api.Result<ByteArray>) {
        val address = UUID.parseFrom(uuidBuffer).address
        val device = bluetoothAdapter.getRemoteDevice(address)
        val autoConnect = false
        val gatt = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val transport = BluetoothDevice.TRANSPORT_LE
            device.connectGatt(activity, autoConnect, BluetoothGattCallback, transport)
        } else {
            device.connectGatt(activity, autoConnect, BluetoothGattCallback)
        }
        instances["${gatt.hashCode()}/${KEY_CONNECT_RESULT}"] = result
    }
}