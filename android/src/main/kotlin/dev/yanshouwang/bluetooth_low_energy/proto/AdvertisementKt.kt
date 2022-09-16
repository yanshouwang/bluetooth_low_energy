//Generated by the protocol buffer compiler. DO NOT EDIT!
// source: proto/messages.proto

package dev.yanshouwang.bluetooth_low_energy.proto;

@kotlin.jvm.JvmName("-initializeadvertisement")
inline fun advertisement(block: dev.yanshouwang.bluetooth_low_energy.proto.AdvertisementKt.Dsl.() -> kotlin.Unit): dev.yanshouwang.bluetooth_low_energy.proto.Advertisement =
  dev.yanshouwang.bluetooth_low_energy.proto.AdvertisementKt.Dsl._create(dev.yanshouwang.bluetooth_low_energy.proto.Advertisement.newBuilder()).apply { block() }._build()
object AdvertisementKt {
  @kotlin.OptIn(com.google.protobuf.kotlin.OnlyForUseByGeneratedProtoCode::class)
  @com.google.protobuf.kotlin.ProtoDslMarker
  class Dsl private constructor(
    private val _builder: dev.yanshouwang.bluetooth_low_energy.proto.Advertisement.Builder
  ) {
    companion object {
      @kotlin.jvm.JvmSynthetic
      @kotlin.PublishedApi
      internal fun _create(builder: dev.yanshouwang.bluetooth_low_energy.proto.Advertisement.Builder): Dsl = Dsl(builder)
    }

    @kotlin.jvm.JvmSynthetic
    @kotlin.PublishedApi
    internal fun _build(): dev.yanshouwang.bluetooth_low_energy.proto.Advertisement = _builder.build()

    /**
     * <code>string uuid = 1;</code>
     */
    var uuid: kotlin.String
      @JvmName("getUuid")
      get() = _builder.getUuid()
      @JvmName("setUuid")
      set(value) {
        _builder.setUuid(value)
      }
    /**
     * <code>string uuid = 1;</code>
     */
    fun clearUuid() {
      _builder.clearUuid()
    }

    /**
     * An uninstantiable, behaviorless type to represent the field in
     * generics.
     */
    @kotlin.OptIn(com.google.protobuf.kotlin.OnlyForUseByGeneratedProtoCode::class)
    class DataProxy private constructor() : com.google.protobuf.kotlin.DslProxy()
    /**
     * <code>map&lt;int32, bytes&gt; data = 2;</code>
     */
     val data: com.google.protobuf.kotlin.DslMap<kotlin.Int, com.google.protobuf.ByteString, DataProxy>
      @kotlin.jvm.JvmSynthetic
      @JvmName("getDataMap")
      get() = com.google.protobuf.kotlin.DslMap(
        _builder.getDataMap()
      )
    /**
     * <code>map&lt;int32, bytes&gt; data = 2;</code>
     */
    @JvmName("putData")
    fun com.google.protobuf.kotlin.DslMap<kotlin.Int, com.google.protobuf.ByteString, DataProxy>
      .put(key: kotlin.Int, value: com.google.protobuf.ByteString) {
         _builder.putData(key, value)
       }
    /**
     * <code>map&lt;int32, bytes&gt; data = 2;</code>
     */
    @kotlin.jvm.JvmSynthetic
    @JvmName("setData")
    @Suppress("NOTHING_TO_INLINE")
    inline operator fun com.google.protobuf.kotlin.DslMap<kotlin.Int, com.google.protobuf.ByteString, DataProxy>
      .set(key: kotlin.Int, value: com.google.protobuf.ByteString) {
         put(key, value)
       }
    /**
     * <code>map&lt;int32, bytes&gt; data = 2;</code>
     */
    @kotlin.jvm.JvmSynthetic
    @JvmName("removeData")
    fun com.google.protobuf.kotlin.DslMap<kotlin.Int, com.google.protobuf.ByteString, DataProxy>
      .remove(key: kotlin.Int) {
         _builder.removeData(key)
       }
    /**
     * <code>map&lt;int32, bytes&gt; data = 2;</code>
     */
    @kotlin.jvm.JvmSynthetic
    @JvmName("putAllData")
    fun com.google.protobuf.kotlin.DslMap<kotlin.Int, com.google.protobuf.ByteString, DataProxy>
      .putAll(map: kotlin.collections.Map<kotlin.Int, com.google.protobuf.ByteString>) {
         _builder.putAllData(map)
       }
    /**
     * <code>map&lt;int32, bytes&gt; data = 2;</code>
     */
    @kotlin.jvm.JvmSynthetic
    @JvmName("clearData")
    fun com.google.protobuf.kotlin.DslMap<kotlin.Int, com.google.protobuf.ByteString, DataProxy>
      .clear() {
         _builder.clearData()
       }

    /**
     * <code>int32 rssi = 3;</code>
     */
    var rssi: kotlin.Int
      @JvmName("getRssi")
      get() = _builder.getRssi()
      @JvmName("setRssi")
      set(value) {
        _builder.setRssi(value)
      }
    /**
     * <code>int32 rssi = 3;</code>
     */
    fun clearRssi() {
      _builder.clearRssi()
    }

    /**
     * <code>bool connectable = 4;</code>
     */
    var connectable: kotlin.Boolean
      @JvmName("getConnectable")
      get() = _builder.getConnectable()
      @JvmName("setConnectable")
      set(value) {
        _builder.setConnectable(value)
      }
    /**
     * <code>bool connectable = 4;</code>
     */
    fun clearConnectable() {
      _builder.clearConnectable()
    }
  }
}
@kotlin.jvm.JvmSynthetic
inline fun dev.yanshouwang.bluetooth_low_energy.proto.Advertisement.copy(block: dev.yanshouwang.bluetooth_low_energy.proto.AdvertisementKt.Dsl.() -> kotlin.Unit): dev.yanshouwang.bluetooth_low_energy.proto.Advertisement =
  dev.yanshouwang.bluetooth_low_energy.proto.AdvertisementKt.Dsl._create(this.toBuilder()).apply { block() }._build()

