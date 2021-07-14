//Generated by the protocol buffer compiler. DO NOT EDIT!
// source: message.proto

package dev.yanshouwang.bluetooth_low_energy;

@kotlin.jvm.JvmSynthetic
inline fun gattCharacteristicWriteArguments(block: dev.yanshouwang.bluetooth_low_energy.GattCharacteristicWriteArgumentsKt.Dsl.() -> Unit): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicWriteArguments =
  dev.yanshouwang.bluetooth_low_energy.GattCharacteristicWriteArgumentsKt.Dsl._create(dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicWriteArguments.newBuilder()).apply { block() }._build()
object GattCharacteristicWriteArgumentsKt {
  @kotlin.OptIn(com.google.protobuf.kotlin.OnlyForUseByGeneratedProtoCode::class)
  @com.google.protobuf.kotlin.ProtoDslMarker
  class Dsl private constructor(
    @kotlin.jvm.JvmField private val _builder: dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicWriteArguments.Builder
  ) {
    companion object {
      @kotlin.jvm.JvmSynthetic
      @kotlin.PublishedApi
      internal fun _create(builder: dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicWriteArguments.Builder): Dsl = Dsl(builder)
    }

    @kotlin.jvm.JvmSynthetic
    @kotlin.PublishedApi
    internal fun _build(): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicWriteArguments = _builder.build()

    /**
     * <code>int32 gatt_id = 1;</code>
     */
    var gattId: kotlin.Int
      @JvmName("getGattId")
      get() = _builder.getGattId()
      @JvmName("setGattId")
      set(value) {
        _builder.setGattId(value)
      }
    /**
     * <code>int32 gatt_id = 1;</code>
     */
    fun clearGattId() {
      _builder.clearGattId()
    }

    /**
     * <code>int32 id = 2;</code>
     */
    var id: kotlin.Int
      @JvmName("getId")
      get() = _builder.getId()
      @JvmName("setId")
      set(value) {
        _builder.setId(value)
      }
    /**
     * <code>int32 id = 2;</code>
     */
    fun clearId() {
      _builder.clearId()
    }

    /**
     * <code>bytes value = 3;</code>
     */
    var value: com.google.protobuf.ByteString
      @JvmName("getValue")
      get() = _builder.getValue()
      @JvmName("setValue")
      set(value) {
        _builder.setValue(value)
      }
    /**
     * <code>bytes value = 3;</code>
     */
    fun clearValue() {
      _builder.clearValue()
    }

    /**
     * <code>bool withoutResponse = 4;</code>
     */
    var withoutResponse: kotlin.Boolean
      @JvmName("getWithoutResponse")
      get() = _builder.getWithoutResponse()
      @JvmName("setWithoutResponse")
      set(value) {
        _builder.setWithoutResponse(value)
      }
    /**
     * <code>bool withoutResponse = 4;</code>
     */
    fun clearWithoutResponse() {
      _builder.clearWithoutResponse()
    }
  }
}
@kotlin.jvm.JvmSynthetic
inline fun dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicWriteArguments.copy(block: dev.yanshouwang.bluetooth_low_energy.GattCharacteristicWriteArgumentsKt.Dsl.() -> Unit): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.GattCharacteristicWriteArguments =
  dev.yanshouwang.bluetooth_low_energy.GattCharacteristicWriteArgumentsKt.Dsl._create(this.toBuilder()).apply { block() }._build()
