package dev.hebei.bluetooth_low_energy_android

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import androidx.activity.result.ActivityResult
import androidx.core.app.ActivityCompat
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

typealias StartActivityForResultCallback = (requestCode: Int, result: ActivityResult) -> Boolean
typealias RequestPermissionsCallback = (requestCode: Int, isGranted: Boolean) -> Boolean

class ActivityUtil : ActivityAware, ActivityResultListener, RequestPermissionsResultListener {
    private var binding: ActivityPluginBinding? = null
    private val bindingNotNull: ActivityPluginBinding get() = binding ?: throw NullPointerException("binding is null")
    private val activity: Activity get() = bindingNotNull.activity
    private val lifecycle: Lifecycle get() = (bindingNotNull.lifecycle as HiddenLifecycleReference).lifecycle

    private val startActivityForResultCallbacks = mutableListOf<StartActivityForResultCallback>()
    private val requestPermissionsCallbacks = mutableListOf<RequestPermissionsCallback>()

    val packageName: String get() = activity.packageName

    fun startActivity(intent: Intent, options: Bundle?) {
        ActivityCompat.startActivity(activity, intent, options)
    }

    suspend fun startActivityForResult(intent: Intent, requestCode: Int, options: Bundle?): ActivityResult =
        suspendCoroutine {
            try {
                ActivityCompat.startActivityForResult(activity, intent, requestCode, options)
                startActivityForResultCallbacks.add { requestCode1, result ->
                    if (requestCode1 != requestCode) return@add false
                    it.resume(result)
                    return@add true
                }
            } catch (e: Exception) {
                it.resumeWithException(e)
            }
        }

    fun checkPermissions(permissions: Array<String>): Boolean {
        return permissions.all { ActivityCompat.checkSelfPermission(activity, it) == PackageManager.PERMISSION_GRANTED }
    }

    fun shouldShowRequestPermissionsRationale(permissions: Array<String>): Boolean {
        return permissions.any { ActivityCompat.shouldShowRequestPermissionRationale(activity, it) }
    }

    suspend fun requestPermissions(permissions: Array<String>, requestCode: Int): Boolean = suspendCoroutine {
        try {
            ActivityCompat.requestPermissions(activity, permissions, requestCode)
            requestPermissionsCallbacks.add { requestCode1, isGranted ->
                if (requestCode1 != requestCode) return@add false
                it.resume(isGranted)
                return@add true
            }
        } catch (e: Exception) {
            it.resumeWithException(e)
        }
    }

    fun addLifecycleObserver(observer: LifecycleObserver) {
        lifecycle.addObserver(observer)
    }

    fun removeLifecycleObserver(observer: LifecycleObserver) {
        lifecycle.removeObserver(observer)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addActivityResultListener(this)
        binding.addRequestPermissionsResultListener(this)
        this.binding = binding
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        this.binding = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        val result = ActivityResult(requestCode, data)
        val callbacks = startActivityForResultCallbacks.filter { it(requestCode, result) }
        startActivityForResultCallbacks.removeAll(callbacks)
        return callbacks.isNotEmpty()
    }

    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, grantResults: IntArray
    ): Boolean {
        val isGranted = grantResults.all { it == PackageManager.PERMISSION_GRANTED }
        val callbacks = requestPermissionsCallbacks.filter { it(requestCode, isGranted) }
        requestPermissionsCallbacks.removeAll(callbacks)
        return callbacks.isNotEmpty()
    }
}