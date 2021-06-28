//Generated by the protocol buffer compiler. DO NOT EDIT!
// source: message.proto

package dev.yanshouwang.bluetooth_low_energy;

@kotlin.jvm.JvmSynthetic
inline fun gattCharacteristicValue(block: dev.yanshouwang.bluetooth_low_energy.GattCharacteristicValueKt.Dsl.() -> Unit): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicValue =
  dev.yanshouwang.bluetooth_low_energy.GattCharacteristicValueKt.Dsl._create(dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicValue.newBuilder()).apply { block() }._build()
object GattCharacteristicValueKt {
  @kotlin.OptIn(com.google.protobuf.kotlin.OnlyForUseByGeneratedProtoCode::class)
  @com.google.protobuf.kotlin.ProtoDslMarker
  class Dsl private constructor(
    @kotlin.jvm.JvmField private val _builder: dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicValue.Builder
  ) {
    companion object {
      @kotlin.jvm.JvmSynthetic
      @kotlin.PublishedApi
      internal fun _create(builder: dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicValue.Builder): Dsl = Dsl(builder)
    }

    @kotlin.jvm.JvmSynthetic
    @kotlin.PublishedApi
    internal fun _build(): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicValue = _builder.build()

    /**
     * <code>string device = 1;</code>
     */
    var device: kotlin.String
      @JvmName("getDevice")
      get() = _builder.getDevice()
      @JvmName("setDevice")
      set(value) {
        _builder.setDevice(value)
      }
    /**
     * <code>string device = 1;</code>
     */
    fun clearDevice() {
      _builder.clearDevice()
    }

    /**
     * <code>string service = 2;</code>
     */
    var service: kotlin.String
      @JvmName("getService")
      get() = _builder.getService()
      @JvmName("setService")
      set(value) {
        _builder.setService(value)
      }
    /**
     * <code>string service = 2;</code>
     */
    fun clearService() {
      _builder.clearService()
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
     * <code>bytes value = 4;</code>
     */
    var value: com.google.protobuf.ByteString
      @JvmName("getValue")
      get() = _builder.getValue()
      @JvmName("setValue")
      set(value) {
        _builder.setValue(value)
      }
    /**
     * <code>bytes value = 4;</code>
     */
    fun clearValue() {
      _builder.clearValue()
    }
  }
}
@kotlin.jvm.JvmSynthetic
inline fun dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicValue.copy(block: dev.yanshouwang.bluetooth_low_energy.GattCharacteristicValueKt.Dsl.() -> Unit): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicValue =
  dev.yanshouwang.bluetooth_low_energy.GattCharacteristicValueKt.Dsl._create(this.toBuilder()).apply { block() }._build()
