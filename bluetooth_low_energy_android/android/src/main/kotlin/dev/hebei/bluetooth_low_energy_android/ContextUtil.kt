package dev.hebei.bluetooth_low_energy_android

import android.content.BroadcastReceiver
import android.content.Context
import android.content.IntentFilter
import androidx.core.content.ContextCompat

class ContextUtil(val context: Context) {
    val mainExecutor get() = ContextCompat.getMainExecutor(context)

    fun hasSystemFeature(featureName: String): Boolean {
        return context.packageManager.hasSystemFeature(featureName)
    }

    fun <T> getSystemService(clazz: Class<T>): T {
        return ContextCompat.getSystemService(context, clazz)
            ?: throw UnsupportedOperationException("$clazz is unsupported")
    }

    fun registerReceiver(receiver: BroadcastReceiver, filter: IntentFilter, flags: Int) {
        ContextCompat.registerReceiver(context, receiver, filter, flags)
    }

    fun unregisterReceiver(receiver: BroadcastReceiver) {
        context.unregisterReceiver(receiver)
    }
}