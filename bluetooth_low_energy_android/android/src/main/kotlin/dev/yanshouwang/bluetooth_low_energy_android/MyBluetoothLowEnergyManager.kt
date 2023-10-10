package dev.yanshouwang.bluetooth_low_energy_android

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import androidx.annotation.CallSuper
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.util.UUID
import java.util.concurrent.Executor

abstract class MyBluetoothLowEnergyManager(private val context: Context) {
    companion object {
        const val DATA_TYPE_MANUFACTURER_SPECIFIC_DATA = 0xff.toByte()
        const val REQUEST_CODE = 443

        val HEART_RATE_MEASUREMENT_UUID: UUID = UUID.fromString("00002a37-0000-1000-8000-00805f9b34fb")
        val CLIENT_CHARACTERISTIC_CONFIG_UUID: UUID = UUID.fromString("00002902-0000-1000-8000-00805f9b34fb")
    }

    private lateinit var binding: ActivityPluginBinding

    protected val unsupported = !context.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
    protected val executor = ContextCompat.getMainExecutor(context) as Executor

    protected val manager get() = ContextCompat.getSystemService(context, BluetoothManager::class.java) as BluetoothManager
    protected val adapter get() = manager.adapter as BluetoothAdapter

    private val listener by lazy { MyRequestPermissionResultListener(this) }
    private val receiver by lazy { MyBroadcastReceiver(this) }

    fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addRequestPermissionsResultListener(listener)
        this.binding = binding
    }

    fun onDetachedFromActivity() {
        binding.removeRequestPermissionsResultListener(listener)
    }

    protected fun authorize(permissions: Array<String>) {
        val activity = binding.activity
        ActivityCompat.requestPermissions(activity, permissions, REQUEST_CODE)
    }

    @CallSuper
    protected open fun register() {
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        context.registerReceiver(receiver, filter)
    }

    @CallSuper
    protected open fun unregister() {
        context.unregisterReceiver(receiver)
    }

    abstract fun onRequestPermissionsResult(requestCode: Int, results: IntArray): Boolean
    abstract fun onReceive(intent: Intent)
}