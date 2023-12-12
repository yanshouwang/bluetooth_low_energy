package dev.yanshouwang.bluetooth_low_energy_android

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener
import java.util.UUID
import java.util.concurrent.Executor

abstract class MyBluetoothLowEnergyManager(context: Context) {
    companion object {
        val CLIENT_CHARACTERISTIC_CONFIG_UUID =
            UUID.fromString("00002902-0000-1000-8000-00805f9b34fb") as UUID
    }

    private val mContext: Context

    private val mRequestPermissionsResultListener: RequestPermissionsResultListener by lazy {
        MyRequestPermissionResultListener(this)
    }
    private val mBroadcastReceiver: BroadcastReceiver by lazy {
        MyBroadcastReceiver(this)
    }

    private var mRegistered: Boolean
    private lateinit var mBinding: ActivityPluginBinding

    init {
        mContext = context
        mRegistered = false
    }

    protected val executor get() = ContextCompat.getMainExecutor(mContext) as Executor
    protected val unsupported get() = !mContext.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
    protected val registered get() = mRegistered
    protected val manager
        get() = ContextCompat.getSystemService(
            mContext, BluetoothManager::class.java
        ) as BluetoothManager
    protected val adapter get() = manager.adapter as BluetoothAdapter

    fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addRequestPermissionsResultListener(mRequestPermissionsResultListener)
        mBinding = binding
    }

    fun onDetachedFromActivity() {
        mBinding.removeRequestPermissionsResultListener(mRequestPermissionsResultListener)
    }

    protected open fun registerReceiver() {
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        mContext.registerReceiver(mBroadcastReceiver, filter)
        mRegistered = true
    }

    protected open fun unregisterReceiver() {
        mContext.unregisterReceiver(mBroadcastReceiver)
        mRegistered = false
    }

    protected fun requestPermissions(permissions: Array<String>, requestCode: Int) {
        val activity = mBinding.activity
        ActivityCompat.requestPermissions(activity, permissions, requestCode)
    }

    abstract fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, results: IntArray
    ): Boolean

    abstract fun onReceive(context: Context, intent: Intent)
}