package dev.yanshouwang.bluetooth_low_energy

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull
import dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.MessageCategory

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener

const val NAMESPACE = "yanshouwang.dev/bluetooth_low_energy";

/** BluetoothLowEnergyPlugin */
class BluetoothLowEnergyPlugin : FlutterPlugin, ActivityAware, MethodCallHandler, StreamHandler, ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var method: MethodChannel
    private lateinit var event: EventChannel

    private var binding: ActivityPluginBinding? = null
    private var sink: EventSink? = null

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        method = MethodChannel(binding.binaryMessenger, "$NAMESPACE/method")
        event = EventChannel(binding.binaryMessenger, "$NAMESPACE/event")
        method.setMethodCallHandler(this)
        event.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        method.setMethodCallHandler(null)
        event.setStreamHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.binding = binding
        this.binding!!.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        binding!!.removeActivityResultListener(this)
        binding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method.category) {
            MessageCategory.BLUETOOTH_MANAGER_STATE -> TODO()
            MessageCategory.CENTRAL_MANAGER_START_DISCOVERY -> TODO()
            MessageCategory.CENTRAL_MANAGER_STOP_DISCOVERY -> TODO()
            MessageCategory.CENTRAL_MANAGER_DISCOVERED -> result.notImplemented()
            MessageCategory.UNRECOGNIZED -> result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, events: EventSink?) {
        sink = events
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        TODO("Not yet implemented")
    }
}

val String.category: MessageCategory
    get() = MessageCategory.valueOf(this)
