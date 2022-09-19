package dev.yanshouwang.bluetooth_low_energy

import android.content.pm.PackageManager
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener

object RequestPermissionsResultListener : RequestPermissionsResultListener {
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
        return when (requestCode) {
            CentralManagerHostApi.REQUEST_CODE -> {
                val result = InstanceManager.freeNotNull<Api.Result<Boolean>>(CentralManagerHostApi.KEY_AUTHORIZE_RESULT)
                val authorized = grantResults.all { grantResult -> grantResult == PackageManager.PERMISSION_GRANTED }
                result.success(authorized)
                true
            }
            else -> false
        }
    }
}