//Generated by the protocol buffer compiler. DO NOT EDIT!
// source: messages.proto

package dev.yanshouwang.bluetooth_low_energy.messages;

@kotlin.jvm.JvmSynthetic
public inline fun event(block: dev.yanshouwang.bluetooth_low_energy.messages.EventKt.Dsl.() -> kotlin.Unit): dev.yanshouwang.bluetooth_low_energy.messages.Messages.Event =
  dev.yanshouwang.bluetooth_low_energy.messages.EventKt.Dsl._create(dev.yanshouwang.bluetooth_low_energy.messages.Messages.Event.newBuilder()).apply { block() }._build()
public object EventKt {
  @kotlin.OptIn(com.google.protobuf.kotlin.OnlyForUseByGeneratedProtoCode::class)
  @com.google.protobuf.kotlin.ProtoDslMarker
  public class Dsl private constructor(
    private val _builder: dev.yanshouwang.bluetooth_low_energy.messages.Messages.Event.Builder
  ) {
    public companion object {
      @kotlin.jvm.JvmSynthetic
      @kotlin.PublishedApi
      internal fun _create(builder: dev.yanshouwang.bluetooth_low_energy.messages.Messages.Event.Builder): Dsl = Dsl(builder)
    }

    @kotlin.jvm.JvmSynthetic
    @kotlin.PublishedApi
    internal fun _build(): dev.yanshouwang.bluetooth_low_energy.messages.Messages.Event = _builder.build()

    /**
     * <code>.dev.yanshouwang.bluetooth_low_energy.messages.EventCategory category = 1;</code>
     */
    public var category: dev.yanshouwang.bluetooth_low_energy.messages.Messages.EventCategory
      @JvmName("getCategory")
      get() = _builder.getCategory()
      @JvmName("setCategory")
      set(value) {
        _builder.setCategory(value)
      }
    /**
     * <code>.dev.yanshouwang.bluetooth_low_energy.messages.EventCategory category = 1;</code>
     */
    public fun clearCategory() {
      _builder.clearCategory()
    }

    /**
     * <code>.dev.yanshouwang.bluetooth_low_energy.messages.BluetoothStateChangedEventArguments bluetooth_state_changed_arguments = 2;</code>
     */
    public var bluetoothStateChangedArguments: dev.yanshouwang.bluetooth_low_energy.messages.Messages.BluetoothStateChangedEventArguments
      @JvmName("getBluetoothStateChangedArguments")
      get() = _builder.getBluetoothStateChangedArguments()
      @JvmName("setBluetoothStateChangedArguments")
      set(value) {
        _builder.setBluetoothStateChangedArguments(value)
      }
    /**
     * <code>.dev.yanshouwang.bluetooth_low_energy.messages.BluetoothStateChangedEventArguments bluetooth_state_changed_arguments = 2;</code>
     */
    public fun clearBluetoothStateChangedArguments() {
      _builder.clearBluetoothStateChangedArguments()
    }
    /**
     * <code>.dev.yanshouwang.bluetooth_low_energy.messages.BluetoothStateChangedEventArguments bluetooth_state_changed_arguments = 2;</code>
     * @return Whether the bluetoothStateChangedArguments field is set.
     */
    public fun hasBluetoothStateChangedArguments(): kotlin.Boolean {
      return _builder.hasBluetoothStateChangedArguments()
    }

    /**
     * <code>.dev.yanshouwang.bluetooth_low_energy.messages.CentralDiscoveredEventArguments central_discovered_arguments = 3;</code>
     */
    public var centralDiscoveredArguments: dev.yanshouwang.bluetooth_low_energy.messages.Messages.CentralDiscoveredEventArguments
      @JvmName("getCentralDiscoveredArguments")
      get() = _builder.getCentralDiscoveredArguments()
      @JvmName("setCentralDiscoveredArguments")
      set(value) {
        _builder.setCentralDiscoveredArguments(value)
      }
    /**
     * <code>.dev.yanshouwang.bluetooth_low_energy.messages.CentralDiscoveredEventArguments central_discovered_arguments = 3;</code>
     */
    public fun clearCentralDiscoveredArguments() {
      _builder.clearCentralDiscoveredArguments()
    }
    /**
     * <code>.dev.yanshouwang.bluetooth_low_energy.messages.CentralDiscoveredEventArguments central_discovered_arguments = 3;</code>
     * @return Whether the centralDiscoveredArguments field is set.
     */
    public fun hasCentralDiscoveredArguments(): kotlin.Boolean {
      return _builder.hasCentralDiscoveredArguments()
    }

    /**
     * <code>.dev.yanshouwang.bluetooth_low_energy.messages.GattConnectionLostEventArguments gatt_connection_lost_arguments = 4;</code>
     */
    public var gattConnectionLostArguments: dev.yanshouwang.bluetooth_low_energy.messages.Messages.GattConnectionLostEventArguments
      @JvmName("getGattConnectionLostArguments")
      get() = _builder.getGattConnectionLostArguments()
      @JvmName("setGattConnectionLostArguments")
      set(value) {
        _builder.setGattConnectionLostArguments(value)
      }
    /**
     * <code>.dev.yanshouwang.bluetooth_low_energy.messages.GattConnectionLostEventArguments gatt_connection_lost_arguments = 4;</code>
     */
    public fun clearGattConnectionLostArguments() {
      _builder.clearGattConnectionLostArguments()
    }
    /**
     * <code>.dev.yanshouwang.bluetooth_low_energy.messages.GattConnectionLostEventArguments gatt_connection_lost_arguments = 4;</code>
     * @return Whether the gattConnectionLostArguments field is set.
     */
    public fun hasGattConnectionLostArguments(): kotlin.Boolean {
      return _builder.hasGattConnectionLostArguments()
    }

    /**
     * <code>.dev.yanshouwang.bluetooth_low_energy.messages.CharacteristicNotifiedEventArguments characteristic_notified_arguments = 5;</code>
     */
    public var characteristicNotifiedArguments: dev.yanshouwang.bluetooth_low_energy.messages.Messages.CharacteristicNotifiedEventArguments
      @JvmName("getCharacteristicNotifiedArguments")
      get() = _builder.getCharacteristicNotifiedArguments()
      @JvmName("setCharacteristicNotifiedArguments")
      set(value) {
        _builder.setCharacteristicNotifiedArguments(value)
      }
    /**
     * <code>.dev.yanshouwang.bluetooth_low_energy.messages.CharacteristicNotifiedEventArguments characteristic_notified_arguments = 5;</code>
     */
    public fun clearCharacteristicNotifiedArguments() {
      _builder.clearCharacteristicNotifiedArguments()
    }
    /**
     * <code>.dev.yanshouwang.bluetooth_low_energy.messages.CharacteristicNotifiedEventArguments characteristic_notified_arguments = 5;</code>
     * @return Whether the characteristicNotifiedArguments field is set.
     */
    public fun hasCharacteristicNotifiedArguments(): kotlin.Boolean {
      return _builder.hasCharacteristicNotifiedArguments()
    }
    public val eventCase: dev.yanshouwang.bluetooth_low_energy.messages.Messages.Event.EventCase
      @JvmName("getEventCase")
      get() = _builder.getEventCase()

    public fun clearEvent() {
      _builder.clearEvent()
    }
  }
}
@kotlin.jvm.JvmSynthetic
public inline fun dev.yanshouwang.bluetooth_low_energy.messages.Messages.Event.copy(block: dev.yanshouwang.bluetooth_low_energy.messages.EventKt.Dsl.() -> kotlin.Unit): dev.yanshouwang.bluetooth_low_energy.messages.Messages.Event =
  dev.yanshouwang.bluetooth_low_energy.messages.EventKt.Dsl._create(this.toBuilder()).apply { block() }._build()
