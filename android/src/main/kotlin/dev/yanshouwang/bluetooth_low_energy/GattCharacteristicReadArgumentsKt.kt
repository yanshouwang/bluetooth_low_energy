//Generated by the protocol buffer compiler. DO NOT EDIT!
// source: message.proto

package dev.yanshouwang.bluetooth_low_energy;

@kotlin.jvm.JvmSynthetic
inline fun gattCharacteristicReadArguments(block: dev.yanshouwang.bluetooth_low_energy.GattCharacteristicReadArgumentsKt.Dsl.() -> Unit): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicReadArguments =
  dev.yanshouwang.bluetooth_low_energy.GattCharacteristicReadArgumentsKt.Dsl._create(dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicReadArguments.newBuilder()).apply { block() }._build()
object GattCharacteristicReadArgumentsKt {
  @kotlin.OptIn(com.google.protobuf.kotlin.OnlyForUseByGeneratedProtoCode::class)
  @com.google.protobuf.kotlin.ProtoDslMarker
  class Dsl private constructor(
    @kotlin.jvm.JvmField private val _builder: dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicReadArguments.Builder
  ) {
    companion object {
      @kotlin.jvm.JvmSynthetic
      @kotlin.PublishedApi
      internal fun _create(builder: dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicReadArguments.Builder): Dsl = Dsl(builder)
    }

    @kotlin.jvm.JvmSynthetic
    @kotlin.PublishedApi
    internal fun _build(): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicReadArguments = _builder.build()

    /**
     * <code>string device_uuid = 1;</code>
     */
    var deviceUuid: kotlin.String
      @JvmName("getDeviceUuid")
      get() = _builder.getDeviceUuid()
      @JvmName("setDeviceUuid")
      set(value) {
        _builder.setDeviceUuid(value)
      }
    /**
     * <code>string device_uuid = 1;</code>
     */
    fun clearDeviceUuid() {
      _builder.clearDeviceUuid()
    }

    /**
     * <code>string service_uuid = 2;</code>
     */
    var serviceUuid: kotlin.String
      @JvmName("getServiceUuid")
      get() = _builder.getServiceUuid()
      @JvmName("setServiceUuid")
      set(value) {
        _builder.setServiceUuid(value)
      }
    /**
     * <code>string service_uuid = 2;</code>
     */
    fun clearServiceUuid() {
      _builder.clearServiceUuid()
    }

    /**
     * <code>string uuid = 3;</code>
     */
    var uuid: kotlin.String
      @JvmName("getUuid")
      get() = _builder.getUuid()
      @JvmName("setUuid")
      set(value) {
        _builder.setUuid(value)
      }
    /**
     * <code>string uuid = 3;</code>
     */
    fun clearUuid() {
      _builder.clearUuid()
    }

    /**
     * <code>int32 id = 4;</code>
     */
    var id: kotlin.Int
      @JvmName("getId")
      get() = _builder.getId()
      @JvmName("setId")
      set(value) {
        _builder.setId(value)
      }
    /**
     * <code>int32 id = 4;</code>
     */
    fun clearId() {
      _builder.clearId()
    }
  }
}
@kotlin.jvm.JvmSynthetic
inline fun dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicReadArguments.copy(block: dev.yanshouwang.bluetooth_low_energy.GattCharacteristicReadArgumentsKt.Dsl.() -> Unit): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicReadArguments =
  dev.yanshouwang.bluetooth_low_energy.GattCharacteristicReadArgumentsKt.Dsl._create(this.toBuilder()).apply { block() }._build()
