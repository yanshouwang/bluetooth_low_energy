package dev.zeekr.bluetooth_low_energy_android

import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry

abstract class BluetoothLowEnergyManagerImpl(val context: Context) {
    companion object {
        const val AUTHORIZE_CODE = 0x00
    }

    private val mBroadcastReceiver: BroadcastReceiver by lazy { BroadcastReceiverImpl(this) }
    private val mRequestPermissionsResultListener: PluginRegistry.RequestPermissionsResultListener by lazy {
        RequestPermissionResultListenerImpl(
            this
        )
    }

    private lateinit var mBinding: ActivityPluginBinding

    init {
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        filter.addAction(BluetoothAdapter.ACTION_LOCAL_NAME_CHANGED)
        filter.addAction(BluetoothDevice.ACTION_BOND_STATE_CHANGED)
        context.registerReceiver(mBroadcastReceiver, filter)
    }

    val activity: Activity get() = mBinding.activity

    fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addRequestPermissionsResultListener(mRequestPermissionsResultListener)
        mBinding = binding
    }

    fun onDetachedFromActivity() {
        mBinding.removeRequestPermissionsResultListener(mRequestPermissionsResultListener)
    }

    /**
     * Releases everything this manager holds on the platform side.
     *
     * Called when the plugin leaves the engine. The adapter receiver is registered
     * against the APPLICATION context, so without this it outlives the engine it
     * reports to: it keeps the manager (and its Flutter API handle) alive and
     * delivers state changes to a messenger that is already detached. Subclasses
     * override to also release their Bluetooth resources, and must call super.
     */
    open fun tearDown() {
        try {
            context.unregisterReceiver(mBroadcastReceiver)
        } catch (e: IllegalArgumentException) {
            // Not registered (already torn down) - nothing to undo.
            Log.w("BluetoothLowEnergyManager", "Broadcast receiver was not registered: ${e.message}")
        }
    }

    abstract fun onReceive(context: Context, intent: Intent)
    abstract fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        results: IntArray
    ): Boolean
}

