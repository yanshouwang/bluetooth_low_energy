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

typealias MyBluetoothLowEnergyState = MyBluetoothLowEnergyStateArgs

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

    private var mState: MyBluetoothLowEnergyState
    private var mRegistered: Boolean
    private lateinit var mBinding: ActivityPluginBinding

    init {
        mContext = context
        mState = MyBluetoothLowEnergyState.UNKNOWN
        mRegistered = false
    }

    protected var state
        get() = mState
        private set(value) {
            if (mState == value) return
            mState = value
            onStateChanged(value)
        }
    protected val executor get() = ContextCompat.getMainExecutor(mContext) as Executor
    protected val manager
        get() = ContextCompat.getSystemService(
            mContext, BluetoothManager::class.java
        ) as BluetoothManager
    protected val adapter get() = manager.adapter as BluetoothAdapter

    protected fun initialize() {
        val hasFeature =
            mContext.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
        if (hasFeature) {
            val granted = permissions.all { permission ->
                ActivityCompat.checkSelfPermission(
                    mContext, permission
                ) == PackageManager.PERMISSION_GRANTED
            }
            if (granted) {
                onPermissionsGranted()
            } else {
                val activity = mBinding.activity
                ActivityCompat.requestPermissions(activity, permissions, requestCode)
            }
        } else {
            state = MyBluetoothLowEnergyState.UNSUPPORTED
        }
    }

    fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addRequestPermissionsResultListener(mRequestPermissionsResultListener)
        mBinding = binding
    }

    fun onDetachedFromActivity() {
        mBinding.removeRequestPermissionsResultListener(mRequestPermissionsResultListener)
    }

    fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, results: IntArray
    ): Boolean {
        if (this.requestCode != requestCode) {
            return false
        }
        val granted = results.all { r -> r == PackageManager.PERMISSION_GRANTED }
        if (granted) {
            onPermissionsGranted()
        } else {
            state = MyBluetoothLowEnergyStateArgs.UNAUTHORIZED
        }
        return true
    }

    fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        if (action != BluetoothAdapter.ACTION_STATE_CHANGED) {
            return
        }
        val state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.STATE_OFF)
        this.state = state.toBluetoothLowEnergyStateArgs()
    }

    protected open fun onPermissionsGranted() {
        state =
            if (adapter.state == BluetoothAdapter.STATE_ON) MyBluetoothLowEnergyStateArgs.POWEREDON
            else MyBluetoothLowEnergyState.POWEREDOFF
        if (mRegistered) return
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        mContext.registerReceiver(mBroadcastReceiver, filter)
        mRegistered = true
    }

    abstract val permissions: Array<String>
    abstract val requestCode: Int
    abstract fun onStateChanged(state: MyBluetoothLowEnergyState)
}

