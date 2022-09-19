package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.pm.PackageManager
import android.os.Handler
import androidx.core.content.ContextCompat
import dev.yanshouwang.bluetooth_low_energy.pigeon.Api
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.util.concurrent.Executor

val instances = mutableMapOf<String, Any>()
val ids = mutableMapOf<Any, String>()

val activity get() = instances.findNotNull<ActivityPluginBinding>(ActivityPluginBinding::class.java.simpleName).activity
val centralManagerFlutterApi get() = instances.findNotNull<Api.CentralManagerFlutterApi>(Api.CentralManagerFlutterApi::class.java.simpleName)
val peripheralFlutterApi get() = instances.findNotNull<Api.PeripheralFlutterApi>(Api.PeripheralFlutterApi::class.java.simpleName)
val gattCharacteristicFlutterApi get() = instances.findNotNull<Api.GattCharacteristicFlutterApi>(Api.GattCharacteristicFlutterApi::class.java.simpleName)

val bluetoothManager get() = activity.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
val bluetoothAdapter get() = bluetoothManager.adapter as BluetoothAdapter
val bluetoothAvailable get() = activity.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
val mainHandler get() = Handler(activity.mainLooper)
val mainExecutor: Executor get() = ContextCompat.getMainExecutor(activity)

inline fun <reified T : Any> MutableMap<String, Any>.free(id: String): T? {
    return remove(id) as T?
}

inline fun <reified T : Any> MutableMap<String, Any>.freeNotNull(id: String): T {
    return remove(id) as T
}

inline fun <reified T : Any> MutableMap<String, Any>.find(id: String): T? {
    return this[id] as T?
}

inline fun <reified T : Any> MutableMap<String, Any>.findNotNull(id: String): T {
    return this[id] as T
}

fun MutableMap<Any, String>.findId(instance: Any): String {
    return this[instance] as String
}
