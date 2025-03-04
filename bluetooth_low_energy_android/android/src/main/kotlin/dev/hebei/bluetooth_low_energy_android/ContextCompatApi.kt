package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Bundle
import android.os.Handler
import androidx.core.content.ContextCompat

class ContextCompatApi(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiContextCompat(registrar) {
    override fun checkSelfPermission(context: Context, permission: Permission): Boolean {
        val permissions = permission.obj
        return permissions.all { ContextCompat.checkSelfPermission(context, it) == PackageManager.PERMISSION_GRANTED }
    }

    override fun getBluetoothManager(context: Context): BluetoothManager? {
        return ContextCompat.getSystemService(context, BluetoothManager::class.java)
    }

    override fun registerReceiver1(
        context: Context, receiver: BroadcastReceiver?, filter: IntentFilter, flags: RegisterReceiverFlags
    ): Intent? {
        return ContextCompat.registerReceiver(context, receiver, filter, flags.obj)
    }

    override fun registerReceiver2(
        context: Context,
        receiver: BroadcastReceiver?,
        filter: IntentFilter,
        broadcastPermission: String,
        scheduler: Handler?,
        flags: RegisterReceiverFlags
    ): Intent? {
        return ContextCompat.registerReceiver(context, receiver, filter, broadcastPermission, scheduler, flags.obj)
    }

    override fun startActivity(context: Context, intent: Intent, options: Bundle?) {
        ContextCompat.startActivity(context, intent, options)
    }
}

val RegisterReceiverFlags.obj: Int
    get() = when (this) {
        RegisterReceiverFlags.EXPORTED -> ContextCompat.RECEIVER_EXPORTED
        RegisterReceiverFlags.NOT_EXPORTED -> ContextCompat.RECEIVER_NOT_EXPORTED
        RegisterReceiverFlags.VISIBLE_TO_INSTANT_APPS -> ContextCompat.RECEIVER_VISIBLE_TO_INSTANT_APPS
    }