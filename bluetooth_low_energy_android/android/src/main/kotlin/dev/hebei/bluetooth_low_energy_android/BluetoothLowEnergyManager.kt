package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.Uri
import android.provider.Settings
import androidx.core.app.ActivityOptionsCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

typealias TurnOnCallback = (state: Int) -> Unit
typealias TurnOffCallback = (state: Int) -> Unit
typealias SetNameCallback = (name: String?) -> Unit

abstract class BluetoothLowEnergyManager(private val contextUtil: ContextUtil, private val activityUtil: ActivityUtil) {
    private val lifecycleObserver = LifecycleEventObserver { _, event ->
        if (event != Lifecycle.Event.ON_RESUME) return@LifecycleEventObserver
        updateState()
    }
    private val receiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            when (intent.action) {
                BluetoothAdapter.ACTION_STATE_CHANGED -> {
                    updateState()
                    val state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, 0)
                    // Raise turn on/off callbacks
                    if (state != BluetoothAdapter.STATE_OFF && state != BluetoothAdapter.STATE_ON) return
                    for (callback in turnOnCallbacks) {
                        callback(state)
                    }
                    turnOnCallbacks.clear()
                    for (callback in turnOffCallbacks) {
                        callback(state)
                    }
                    turnOffCallbacks.clear()
                }

                BluetoothAdapter.ACTION_LOCAL_NAME_CHANGED -> {
                    val name = intent.getStringExtra(BluetoothAdapter.EXTRA_LOCAL_NAME)
                    for (listener in nameChangedListeners) {
                        listener.onChanged(name)
                    }
                    for (callback in setNameCallbacks) {
                        callback(name)
                    }
                    setNameCallbacks.clear()
                }

                else -> {}
            }
        }
    }

    private val stateChangedListeners = mutableListOf<StateChangedListener>()
    private val nameChangedListeners = mutableListOf<NameChangedListener>()

    private var turnOnCallbacks = mutableListOf<TurnOnCallback>()
    private var turnOffCallbacks = mutableListOf<TurnOffCallback>()
    private var setNameCallbacks = mutableListOf<SetNameCallback>()

    protected val bluetoothManager: BluetoothManager get() = contextUtil.getSystemService(BluetoothManager::class.java)
    protected val bluetoothAdapter: BluetoothAdapter get() = bluetoothManager.adapter

    protected abstract val permissions: Array<String>
    protected abstract val requestCode: Int

    var state = BluetoothLowEnergyState.UNKNOWN
        private set(value) {
            if (value == field) return
            field = value
            for (listener in stateChangedListeners) {
                listener.onChanged(value)
            }
        }
    val name: String? get() = bluetoothAdapter.name

    init {
        updateState()
        activityUtil.addLifecycleObserver(lifecycleObserver)
        val filter = IntentFilter().apply {
            addAction(BluetoothAdapter.ACTION_STATE_CHANGED)
            addAction(BluetoothAdapter.ACTION_LOCAL_NAME_CHANGED)
        }
        contextUtil.registerReceiver(receiver, filter, ContextCompat.RECEIVER_NOT_EXPORTED)
    }

    fun dispose() {
        activityUtil.removeLifecycleObserver(lifecycleObserver)
        contextUtil.unregisterReceiver(receiver)
    }

    fun addStateChangedListener(listener: StateChangedListener) {
        stateChangedListeners.add(listener)
    }

    fun removeStateChangedListener(listener: StateChangedListener) {
        stateChangedListeners.remove(listener)
    }

    fun addNameChangedListener(listener: NameChangedListener) {
        nameChangedListeners.add(listener)
    }

    fun removeNameChangedListener(observer: NameChangedListener) {
        nameChangedListeners.remove(observer)
    }

    fun showAppSettings() {
        val packageName = activityUtil.packageName
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
            data = Uri.fromParts("package", packageName, null)
        }
        val options = ActivityOptionsCompat.makeBasic().toBundle()
        activityUtil.startActivity(intent, options)
    }

    fun shouldShowAuthorizeRationale(): Boolean {
        return activityUtil.shouldShowRequestPermissionsRationale(permissions)
    }

    suspend fun authorize(): Boolean {
        return activityUtil.requestPermissions(permissions, requestCode)
    }

    suspend fun turnOn() = suspendCoroutine {
        try {
            ensureState(false)
            val ok = bluetoothAdapter.enable()
            if (!ok) throw IllegalStateException("bluetoothAdapter.enable returns false")
            turnOnCallbacks.add { state ->
                try {
                    if (state != BluetoothAdapter.STATE_ON) throw IllegalStateException("turnOn failed: $state")
                    it.resume(Unit)
                } catch (e: Exception) {
                    it.resumeWithException(e)
                }
            }
        } catch (e: Exception) {
            it.resumeWithException(e)
        }
    }

    suspend fun turnOff() = suspendCoroutine {
        try {
            ensureState(false)
            val ok = bluetoothAdapter.disable()
            if (!ok) throw IllegalStateException("bluetoothAdapter.disable returns false")
            turnOnCallbacks.add { state ->
                try {
                    if (state != BluetoothAdapter.STATE_OFF) throw IllegalStateException("turnOff failed: $state")
                    it.resume(Unit)
                } catch (e: Exception) {
                    it.resumeWithException(e)
                }
            }
        } catch (e: Exception) {
            it.resumeWithException(e)
        }
    }

    suspend fun setName(name: String?): String? = suspendCoroutine {
        try {
            val ok = bluetoothAdapter.setName(name)
            if (!ok) throw IllegalStateException("BluetoothAdapter#setName returns false")
            setNameCallbacks.add { name -> it.resume(name) }
        } catch (e: Exception) {
            it.resumeWithException(e)
        }
    }

    protected fun ensureState(isOn: Boolean = true) {
        val state = this.state
        val ok = if (isOn) state == BluetoothLowEnergyState.ON
        else state != BluetoothLowEnergyState.UNKNOWN && state != BluetoothLowEnergyState.UNSUPPORTED && state != BluetoothLowEnergyState.UNAUTHORIZED
        if (ok) return
        throw IllegalStateException("Illegal state $state")
    }

    private fun updateState() {
        val hasBluetoothLowEnergy = contextUtil.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
        state = if (hasBluetoothLowEnergy) {
            val isAuthorized = isAuthorized()
            if (isAuthorized) bluetoothAdapter.state.bluetoothLowEnergyStateArgs
            else BluetoothLowEnergyState.UNAUTHORIZED
        } else BluetoothLowEnergyState.UNSUPPORTED
    }

    private fun isAuthorized(): Boolean {
        return activityUtil.checkPermissions(permissions)
    }

    interface StateChangedListener {
        fun onChanged(state: BluetoothLowEnergyState)
    }

    interface NameChangedListener {
        fun onChanged(name: String?)
    }
}