package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanSettings
import android.content.pm.PackageManager
import android.os.Build
import android.os.ParcelUuid
import android.util.Log
import androidx.core.app.ActivityCompat
import dev.yanshouwang.bluetooth_low_energy.proto.UUID
import dev.yanshouwang.bluetooth_low_energy.pigeon.Messages as Pigeon

object MyCentralManagerHostApi : Pigeon.CentralManagerHostApi {
    const val REQUEST_CODE = 443

    override fun authorize(result: Pigeon.Result<Boolean>) {
        Log.d(TAG, "authorize: ")
        val permissions = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.BLUETOOTH_SCAN, android.Manifest.permission.BLUETOOTH_CONNECT)
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
        Log.d(TAG, "getState: ")
        return bluetoothAdapter.stateNumber
    }

    override fun startScan(uuidBuffers: MutableList<ByteArray>?, result: Pigeon.Result<Void>) {
        Log.d(TAG, "startScan: $uuidBuffers")
        val filters = uuidBuffers?.map { buffer ->
            val uuid = UUID.parseFrom(buffer).value
            val serviceUUID = ParcelUuid.fromString(uuid)
            ScanFilter.Builder().setServiceUuid(serviceUUID).build()
        }
        val settings = ScanSettings.Builder().setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
            .build()
        bluetoothAdapter.bluetoothLeScanner.startScan(filters, settings, MyScanCallback)
        // Use main handler.post to delay until ScanCallback.onScanFailed executed.
        mainHandler.post {
            val error = instances.remove(KEY_START_SCAN_ERROR) as Throwable?
            if (error == null) {
                result.success(null)
            } else {
                result.error(error)
            }
        }
    }

    override fun stopScan() {
        Log.d(TAG, "stopScan: ")
        bluetoothAdapter.bluetoothLeScanner.stopScan(MyScanCallback)
    }
}