package dev.yanshouwang.bluetooth_low_energy

import android.content.pm.PackageManager
import android.util.Log
import dev.yanshouwang.bluetooth_low_energy.pigeon.Messages as Pigeon
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener

object MyRequestPermissionsResultListener : RequestPermissionsResultListener {
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
        Log.d(TAG, "onRequestPermissionsResult: $requestCode, $permissions, $grantResults")
        return when (requestCode) {
            REQUEST_CODE -> {
                val result = items.remove(KEY_AUTHORIZE_RESULT) as Pigeon.Result<Boolean>
                val authorized = grantResults.all { grantResult -> grantResult == PackageManager.PERMISSION_GRANTED }
                result.success(authorized)
                true
            }
            else -> false
        }
    }
}