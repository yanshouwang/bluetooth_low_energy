//Generated by the protocol buffer compiler. DO NOT EDIT!
// source: message.proto

package dev.yanshouwang.bluetooth_low_energy;

@kotlin.jvm.JvmSynthetic
inline fun gattDescriptorWriteArguments(block: dev.yanshouwang.bluetooth_low_energy.GattDescriptorWriteArgumentsKt.Dsl.() -> Unit): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattDescriptorWriteArguments =
  dev.yanshouwang.bluetooth_low_energy.GattDescriptorWriteArgumentsKt.Dsl._create(dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattDescriptorWriteArguments.newBuilder()).apply { block() }._build()
object GattDescriptorWriteArgumentsKt {
  @kotlin.OptIn(com.google.protobuf.kotlin.OnlyForUseByGeneratedProtoCode::class)
  @com.google.protobuf.kotlin.ProtoDslMarker
  class Dsl private constructor(
    @kotlin.jvm.JvmField private val _builder: dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattDescriptorWriteArguments.Builder
  ) {
    companion object {
      @kotlin.jvm.JvmSynthetic
      @kotlin.PublishedApi
      internal fun _create(builder: dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattDescriptorWriteArguments.Builder): Dsl = Dsl(builder)
    }

    @kotlin.jvm.JvmSynthetic
    @kotlin.PublishedApi
    internal fun _build(): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattDescriptorWriteArguments = _builder.build()

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
     * <code>string characteristic = 3;</code>
     */
    var characteristic: kotlin.String
      @JvmName("getCharacteristic")
      get() = _builder.getCharacteristic()
      @JvmName("setCharacteristic")
      set(value) {
        _builder.setCharacteristic(value)
      }
    /**
     * <code>string characteristic = 3;</code>
     */
    fun clearCharacteristic() {
      _builder.clearCharacteristic()
    }

    /**
     * <code>string uuid = 4;</code>
     */
    var uuid: kotlin.String
      @JvmName("getUuid")
      get() = _builder.getUuid()
      @JvmName("setUuid")
      set(value) {
        _builder.setUuid(value)
      }
    /**
     * <code>string uuid = 4;</code>
     */
    fun clearUuid() {
      _builder.clearUuid()
    }

    /**
     * <code>bytes value = 5;</code>
     */
    var value: com.google.protobuf.ByteString
      @JvmName("getValue")
      get() = _builder.getValue()
      @JvmName("setValue")
      set(value) {
        _builder.setValue(value)
      }
    /**
     * <code>bytes value = 5;</code>
     */
    fun clearValue() {
      _builder.clearValue()
    }
  }
}
@kotlin.jvm.JvmSynthetic
inline fun dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattDescriptorWriteArguments.copy(block: dev.yanshouwang.bluetooth_low_energy.GattDescriptorWriteArgumentsKt.Dsl.() -> Unit): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattDescriptorWriteArguments =
  dev.yanshouwang.bluetooth_low_energy.GattDescriptorWriteArgumentsKt.Dsl._create(this.toBuilder()).apply { block() }._build()
