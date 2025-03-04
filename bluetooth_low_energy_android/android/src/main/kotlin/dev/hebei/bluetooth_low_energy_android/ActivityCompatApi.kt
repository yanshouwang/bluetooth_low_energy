package dev.hebei.bluetooth_low_energy_android

import android.app.Activity
import android.content.Intent
import android.os.Build
import android.os.Bundle
import androidx.core.app.ActivityCompat

class ActivityCompatApi(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiActivityCompat(registrar) {
    override fun requestPermissions(activity: Activity, permissions: Permission, requestCode: Long) {
        ActivityCompat.requestPermissions(activity, permissions.obj, requestCode.toInt())
    }

    override fun startActivityForResult(activity: Activity, intent: Intent, requestCode: Long, options: Bundle?) {
        ActivityCompat.startActivityForResult(activity, intent, requestCode.toInt(), options)
    }
}

val Permission.obj: Array<String>
    get() = when (this) {
        Permission.CENTRAL -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) arrayOf(
            android.Manifest.permission.BLUETOOTH_SCAN, android.Manifest.permission.BLUETOOTH_CONNECT
        )
        else arrayOf(
            android.Manifest.permission.ACCESS_COARSE_LOCATION, android.Manifest.permission.ACCESS_FINE_LOCATION
        )

        Permission.PERIPHERAL -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) arrayOf(
            android.Manifest.permission.BLUETOOTH_ADVERTISE, android.Manifest.permission.BLUETOOTH_CONNECT
        ) else arrayOf(
            android.Manifest.permission.ACCESS_COARSE_LOCATION, android.Manifest.permission.ACCESS_FINE_LOCATION
        )
    }