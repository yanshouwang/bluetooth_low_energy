import 'dart:typed_data';

import 'central.dart';
import 'gatt_characteristic.dart';

/// The GATT characteristic written event arguments.
class GattCharacteristicReadEventArgs {
  /// The central which read this characteristic.
  final Central central;

  /// The GATT characteristic which value is read.
  final GattCharacteristic characteristic;

  /// The value.
  final Uint8List value;

  /// Constructs a [GattCharacteristicReadEventArgs].
  GattCharacteristicReadEventArgs(
    this.central,
    this.characteristic,
    this.value,
  );
}

/// The GATT characteristic written event arguments.
class GattCharacteristicWrittenEventArgs {
  /// The central which wrote this characteristic.
  final Central central;

  /// The GATT characteristic which value is written.
  final GattCharacteristic characteristic;

  /// The value.
  final Uint8List value;

  /// Constructs a [GattCharacteristicWrittenEventArgs].
  GattCharacteristicWrittenEventArgs(
    this.central,
    this.characteristic,
    this.value,
  );
}

/// The GATT characteristic notify state changed event arguments.
class GattCharacteristicNotifyStateChangedEventArgs {
  /// The central which set this notify state.
  final Central central;

  /// The GATT characteristic which notify state changed.
  final GattCharacteristic characteristic;

  /// The notify state.
  final bool state;

  /// Constructs a [GattCharacteristicNotifyStateChangedEventArgs].
  GattCharacteristicNotifyStateChangedEventArgs(
    this.central,
    this.characteristic,
    this.state,
  );
}
