//Generated by the protocol buffer compiler. DO NOT EDIT!
// source: message.proto

package dev.yanshouwang.bluetooth_low_energy;

@kotlin.jvm.JvmSynthetic
inline fun gattCharacteristicNotifyArguments(block: dev.yanshouwang.bluetooth_low_energy.GattCharacteristicNotifyArgumentsKt.Dsl.() -> Unit): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicNotifyArguments =
  dev.yanshouwang.bluetooth_low_energy.GattCharacteristicNotifyArgumentsKt.Dsl._create(dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicNotifyArguments.newBuilder()).apply { block() }._build()
object GattCharacteristicNotifyArgumentsKt {
  @kotlin.OptIn(com.google.protobuf.kotlin.OnlyForUseByGeneratedProtoCode::class)
  @com.google.protobuf.kotlin.ProtoDslMarker
  class Dsl private constructor(
    @kotlin.jvm.JvmField private val _builder: dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicNotifyArguments.Builder
  ) {
    companion object {
      @kotlin.jvm.JvmSynthetic
      @kotlin.PublishedApi
      internal fun _create(builder: dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicNotifyArguments.Builder): Dsl = Dsl(builder)
    }

    @kotlin.jvm.JvmSynthetic
    @kotlin.PublishedApi
    internal fun _build(): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicNotifyArguments = _builder.build()

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
     * <code>bool state = 4;</code>
     */
    var state: kotlin.Boolean
      @JvmName("getState")
      get() = _builder.getState()
      @JvmName("setState")
      set(value) {
        _builder.setState(value)
      }
    /**
     * <code>bool state = 4;</code>
     */
    fun clearState() {
      _builder.clearState()
    }
  }
}
@kotlin.jvm.JvmSynthetic
inline fun dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicNotifyArguments.copy(block: dev.yanshouwang.bluetooth_low_energy.GattCharacteristicNotifyArgumentsKt.Dsl.() -> Unit): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicNotifyArguments =
  dev.yanshouwang.bluetooth_low_energy.GattCharacteristicNotifyArgumentsKt.Dsl._create(this.toBuilder()).apply { block() }._build()
