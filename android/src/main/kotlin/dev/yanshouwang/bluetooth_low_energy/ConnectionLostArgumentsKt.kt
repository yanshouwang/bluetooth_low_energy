//Generated by the protocol buffer compiler. DO NOT EDIT!
// source: message.proto

package dev.yanshouwang.bluetooth_low_energy;

@kotlin.jvm.JvmSynthetic
inline fun connectionLostArguments(block: dev.yanshouwang.bluetooth_low_energy.ConnectionLostArgumentsKt.Dsl.() -> Unit): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.ConnectionLostArguments =
  dev.yanshouwang.bluetooth_low_energy.ConnectionLostArgumentsKt.Dsl._create(dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.ConnectionLostArguments.newBuilder()).apply { block() }._build()
object ConnectionLostArgumentsKt {
  @kotlin.OptIn(com.google.protobuf.kotlin.OnlyForUseByGeneratedProtoCode::class)
  @com.google.protobuf.kotlin.ProtoDslMarker
  class Dsl private constructor(
    @kotlin.jvm.JvmField private val _builder: dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.ConnectionLostArguments.Builder
  ) {
    companion object {
      @kotlin.jvm.JvmSynthetic
      @kotlin.PublishedApi
      internal fun _create(builder: dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.ConnectionLostArguments.Builder): Dsl = Dsl(builder)
    }

    @kotlin.jvm.JvmSynthetic
    @kotlin.PublishedApi
    internal fun _build(): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.ConnectionLostArguments = _builder.build()

    /**
     * <code>string address = 1;</code>
     */
    var address: kotlin.String
      @JvmName("getAddress")
      get() = _builder.getAddress()
      @JvmName("setAddress")
      set(value) {
        _builder.setAddress(value)
      }
    /**
     * <code>string address = 1;</code>
     */
    fun clearAddress() {
      _builder.clearAddress()
    }

    /**
     * <code>int32 error_code = 2;</code>
     */
    var errorCode: kotlin.Int
      @JvmName("getErrorCode")
      get() = _builder.getErrorCode()
      @JvmName("setErrorCode")
      set(value) {
        _builder.setErrorCode(value)
      }
    /**
     * <code>int32 error_code = 2;</code>
     */
    fun clearErrorCode() {
      _builder.clearErrorCode()
    }
  }
}
@kotlin.jvm.JvmSynthetic
inline fun dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.ConnectionLostArguments.copy(block: dev.yanshouwang.bluetooth_low_energy.ConnectionLostArgumentsKt.Dsl.() -> Unit): dev.yanshouwang.bluetooth_low_energy.MessageOuterClass.ConnectionLostArguments =
  dev.yanshouwang.bluetooth_low_energy.ConnectionLostArgumentsKt.Dsl._create(this.toBuilder()).apply { block() }._build()