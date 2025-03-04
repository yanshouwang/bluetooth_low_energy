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

class ContextCompatImpl(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiContextCompat(registrar) {
    override fun checkSelfPermission(context: Context, permissionArgs: PermissionArgs): Boolean {
        val permissions = permissionArgs.obj
        return permissions.all { ContextCompat.checkSelfPermission(context, it) == PackageManager.PERMISSION_GRANTED }
    }

    override fun getBluetoothManager(context: Context): BluetoothManager? {
        return ContextCompat.getSystemService(context, BluetoothManager::class.java)
    }

    override fun registerReceiver1(
        context: Context, receiver: BroadcastReceiver?, filter: IntentFilter, flagsArgs: RegisterReceiverFlagsArgs
    ): Intent? {
        val flags = flagsArgs.obj
        return ContextCompat.registerReceiver(context, receiver, filter, flags)
    }

    override fun registerReceiver2(
        context: Context,
        receiver: BroadcastReceiver?,
        filter: IntentFilter,
        broadcastPermission: String,
        scheduler: Handler?,
        flagsArgs: RegisterReceiverFlagsArgs
    ): Intent? {
        val flags = flagsArgs.obj
        return ContextCompat.registerReceiver(context, receiver, filter, broadcastPermission, scheduler, flags)
    }

    override fun startActivity(context: Context, intent: Intent, options: Bundle?) {
        ContextCompat.startActivity(context, intent, options)
    }
}

val RegisterReceiverFlagsArgs.obj: Int
    get() = when (this) {
        RegisterReceiverFlagsArgs.EXPORTED -> ContextCompat.RECEIVER_EXPORTED
        RegisterReceiverFlagsArgs.NOT_EXPORTED -> ContextCompat.RECEIVER_NOT_EXPORTED
        RegisterReceiverFlagsArgs.VISIBLE_TO_INSTANT_APPS -> ContextCompat.RECEIVER_VISIBLE_TO_INSTANT_APPS
    }