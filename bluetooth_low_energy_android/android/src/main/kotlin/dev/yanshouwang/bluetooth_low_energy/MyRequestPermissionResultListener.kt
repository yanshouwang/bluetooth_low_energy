package dev.yanshouwang.bluetooth_low_energy

import android.content.pm.PackageManager
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener

class MyRequestPermissionResultListener : RequestPermissionsResultListener {
    var callback: ((Boolean) -> Unit)? = null

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
        val callback = this.callback
        return if (requestCode == MyCentralController.REQUEST_CODE && callback != null) {
            val authorized = grantResults.all { r -> r == PackageManager.PERMISSION_GRANTED }
            callback(authorized)
            this.callback = null
            true
        } else false
    }
}