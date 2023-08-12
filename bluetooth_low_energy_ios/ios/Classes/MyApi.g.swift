// Autogenerated from Pigeon (v10.1.6), do not edit directly.
// See also: https://pub.dev/packages/pigeon


import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  if (exception is FlutterError) {
    return listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    return listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

enum class MyCentralStateArgs(val raw: Int) {
  UNKNOWN(0),
  UNSUPPORTED(1),
  UNAUTHORIZED(2),
  POWEREDOFF(3),
  POWEREDON(4);

  companion object {
    fun ofRaw(raw: Int): MyCentralStateArgs? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

enum class MyGattCharacteristicPropertyArgs(val raw: Int) {
  READ(0),
  WRITE(1),
  WRITEWITHOUTRESPONSE(2),
  NOTIFY(3),
  INDICATE(4);

  companion object {
    fun ofRaw(raw: Int): MyGattCharacteristicPropertyArgs? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

enum class MyGattCharacteristicWriteTypeArgs(val raw: Int) {
  WITHRESPONSE(0),
  WITHOUTRESPONSE(1);

  companion object {
    fun ofRaw(raw: Int): MyGattCharacteristicWriteTypeArgs? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class MyCentralControllerArgs (
  val myStateNumber: Long

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): MyCentralControllerArgs {
      val myStateNumber = list[0].let { if (it is Int) it.toLong() else it as Long }
      return MyCentralControllerArgs(myStateNumber)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      myStateNumber,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class MyPeripheralArgs (
  val key: Long,
  val uuidString: String

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): MyPeripheralArgs {
      val key = list[0].let { if (it is Int) it.toLong() else it as Long }
      val uuidString = list[1] as String
      return MyPeripheralArgs(key, uuidString)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      key,
      uuidString,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class MyAdvertisementArgs (
  val name: String? = null,
  val manufacturerSpecificData: Map<Long?, ByteArray?>

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): MyAdvertisementArgs {
      val name = list[0] as String?
      val manufacturerSpecificData = list[1] as Map<Long?, ByteArray?>
      return MyAdvertisementArgs(name, manufacturerSpecificData)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      name,
      manufacturerSpecificData,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class MyGattServiceArgs (
  val key: Long,
  val uuidString: String

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): MyGattServiceArgs {
      val key = list[0].let { if (it is Int) it.toLong() else it as Long }
      val uuidString = list[1] as String
      return MyGattServiceArgs(key, uuidString)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      key,
      uuidString,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class MyGattCharacteristicArgs (
  val key: Long,
  val uuidString: String,
  val myPropertyNumbers: List<Long?>

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): MyGattCharacteristicArgs {
      val key = list[0].let { if (it is Int) it.toLong() else it as Long }
      val uuidString = list[1] as String
      val myPropertyNumbers = list[2] as List<Long?>
      return MyGattCharacteristicArgs(key, uuidString, myPropertyNumbers)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      key,
      uuidString,
      myPropertyNumbers,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class MyGattDescriptorArgs (
  val key: Long,
  val uuidString: String

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): MyGattDescriptorArgs {
      val key = list[0].let { if (it is Int) it.toLong() else it as Long }
      val uuidString = list[1] as String
      return MyGattDescriptorArgs(key, uuidString)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      key,
      uuidString,
    )
  }
}

@Suppress("UNCHECKED_CAST")
private object MyCentralControllerHostApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MyCentralControllerArgs.fromList(it)
        }
      }
      129.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MyGattCharacteristicArgs.fromList(it)
        }
      }
      130.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MyGattDescriptorArgs.fromList(it)
        }
      }
      131.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MyGattServiceArgs.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is MyCentralControllerArgs -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      is MyGattCharacteristicArgs -> {
        stream.write(129)
        writeValue(stream, value.toList())
      }
      is MyGattDescriptorArgs -> {
        stream.write(130)
        writeValue(stream, value.toList())
      }
      is MyGattServiceArgs -> {
        stream.write(131)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface MyCentralControllerHostApi {
  fun setUp(): MyCentralControllerArgs
  fun tearDown()
  fun startDiscovery()
  fun stopDiscovery()
  fun connect(myPeripheralKey: Long, callback: (Result<Unit>) -> Unit)
  fun disconnect(myPeripheralKey: Long, callback: (Result<Unit>) -> Unit)
  fun discoverGATT(myPeripheralKey: Long, callback: (Result<Unit>) -> Unit)
  fun getServices(myPeripheralKey: Long): List<MyGattServiceArgs>
  fun getCharacteristics(myServiceKey: Long): List<MyGattCharacteristicArgs>
  fun getDescriptors(myCharacteristicKey: Long): List<MyGattDescriptorArgs>
  fun readCharacteristic(myPeripheralKey: Long, myCharacteristicKey: Long, callback: (Result<ByteArray>) -> Unit)
  fun writeCharacteristic(myPeripheralKey: Long, myCharacteristicKey: Long, value: ByteArray, myTypeNumber: Long, callback: (Result<Unit>) -> Unit)
  fun notifyCharacteristic(myPeripheralKey: Long, myCharacteristicKey: Long, state: Boolean, callback: (Result<Unit>) -> Unit)
  fun readDescriptor(myPeripheralKey: Long, myDescriptorKey: Long, callback: (Result<ByteArray>) -> Unit)
  fun writeDescriptor(myPeripheralKey: Long, myDescriptorKey: Long, value: ByteArray, callback: (Result<Unit>) -> Unit)

  companion object {
    /** The codec used by MyCentralControllerHostApi. */
    val codec: MessageCodec<Any?> by lazy {
      MyCentralControllerHostApiCodec
    }
    /** Sets up an instance of `MyCentralControllerHostApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: MyCentralControllerHostApi?) {
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerHostApi.setUp", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.setUp())
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerHostApi.tearDown", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              api.tearDown()
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerHostApi.startDiscovery", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              api.startDiscovery()
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerHostApi.stopDiscovery", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              api.stopDiscovery()
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerHostApi.connect", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val myPeripheralKeyArg = args[0].let { if (it is Int) it.toLong() else it as Long }
            api.connect(myPeripheralKeyArg) { result: Result<Unit> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                reply.reply(wrapResult(null))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerHostApi.disconnect", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val myPeripheralKeyArg = args[0].let { if (it is Int) it.toLong() else it as Long }
            api.disconnect(myPeripheralKeyArg) { result: Result<Unit> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                reply.reply(wrapResult(null))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerHostApi.discoverGATT", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val myPeripheralKeyArg = args[0].let { if (it is Int) it.toLong() else it as Long }
            api.discoverGATT(myPeripheralKeyArg) { result: Result<Unit> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                reply.reply(wrapResult(null))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerHostApi.getServices", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val myPeripheralKeyArg = args[0].let { if (it is Int) it.toLong() else it as Long }
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.getServices(myPeripheralKeyArg))
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerHostApi.getCharacteristics", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val myServiceKeyArg = args[0].let { if (it is Int) it.toLong() else it as Long }
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.getCharacteristics(myServiceKeyArg))
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerHostApi.getDescriptors", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val myCharacteristicKeyArg = args[0].let { if (it is Int) it.toLong() else it as Long }
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.getDescriptors(myCharacteristicKeyArg))
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerHostApi.readCharacteristic", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val myPeripheralKeyArg = args[0].let { if (it is Int) it.toLong() else it as Long }
            val myCharacteristicKeyArg = args[1].let { if (it is Int) it.toLong() else it as Long }
            api.readCharacteristic(myPeripheralKeyArg, myCharacteristicKeyArg) { result: Result<ByteArray> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerHostApi.writeCharacteristic", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val myPeripheralKeyArg = args[0].let { if (it is Int) it.toLong() else it as Long }
            val myCharacteristicKeyArg = args[1].let { if (it is Int) it.toLong() else it as Long }
            val valueArg = args[2] as ByteArray
            val myTypeNumberArg = args[3].let { if (it is Int) it.toLong() else it as Long }
            api.writeCharacteristic(myPeripheralKeyArg, myCharacteristicKeyArg, valueArg, myTypeNumberArg) { result: Result<Unit> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                reply.reply(wrapResult(null))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerHostApi.notifyCharacteristic", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val myPeripheralKeyArg = args[0].let { if (it is Int) it.toLong() else it as Long }
            val myCharacteristicKeyArg = args[1].let { if (it is Int) it.toLong() else it as Long }
            val stateArg = args[2] as Boolean
            api.notifyCharacteristic(myPeripheralKeyArg, myCharacteristicKeyArg, stateArg) { result: Result<Unit> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                reply.reply(wrapResult(null))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerHostApi.readDescriptor", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val myPeripheralKeyArg = args[0].let { if (it is Int) it.toLong() else it as Long }
            val myDescriptorKeyArg = args[1].let { if (it is Int) it.toLong() else it as Long }
            api.readDescriptor(myPeripheralKeyArg, myDescriptorKeyArg) { result: Result<ByteArray> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerHostApi.writeDescriptor", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val myPeripheralKeyArg = args[0].let { if (it is Int) it.toLong() else it as Long }
            val myDescriptorKeyArg = args[1].let { if (it is Int) it.toLong() else it as Long }
            val valueArg = args[2] as ByteArray
            api.writeDescriptor(myPeripheralKeyArg, myDescriptorKeyArg, valueArg) { result: Result<Unit> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                reply.reply(wrapResult(null))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
@Suppress("UNCHECKED_CAST")
private object MyCentralControllerFlutterApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MyAdvertisementArgs.fromList(it)
        }
      }
      129.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MyPeripheralArgs.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is MyAdvertisementArgs -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      is MyPeripheralArgs -> {
        stream.write(129)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated class from Pigeon that represents Flutter messages that can be called from Kotlin. */
@Suppress("UNCHECKED_CAST")
class MyCentralControllerFlutterApi(private val binaryMessenger: BinaryMessenger) {
  companion object {
    /** The codec used by MyCentralControllerFlutterApi. */
    val codec: MessageCodec<Any?> by lazy {
      MyCentralControllerFlutterApiCodec
    }
  }
  fun onStateChanged(myStateNumberArg: Long, callback: () -> Unit) {
    val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerFlutterApi.onStateChanged", codec)
    channel.send(listOf(myStateNumberArg)) {
      callback()
    }
  }
  fun onDiscovered(myPeripheralArgsArg: MyPeripheralArgs, rssiArg: Long, myAdvertisementArgsArg: MyAdvertisementArgs, callback: () -> Unit) {
    val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerFlutterApi.onDiscovered", codec)
    channel.send(listOf(myPeripheralArgsArg, rssiArg, myAdvertisementArgsArg)) {
      callback()
    }
  }
  fun onPeripheralStateChanged(myPeripheralKeyArg: Long, stateArg: Boolean, callback: () -> Unit) {
    val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerFlutterApi.onPeripheralStateChanged", codec)
    channel.send(listOf(myPeripheralKeyArg, stateArg)) {
      callback()
    }
  }
  fun onCharacteristicValueChanged(myCharacteristicKeyArg: Long, valueArg: ByteArray, callback: () -> Unit) {
    val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.bluetooth_low_energy_ios.MyCentralControllerFlutterApi.onCharacteristicValueChanged", codec)
    channel.send(listOf(myCharacteristicKeyArg, valueArg)) {
      callback()
    }
  }
}
