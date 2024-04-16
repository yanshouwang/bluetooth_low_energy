import 'dart:typed_data';

import 'central.dart';
import 'gatt_characteristic.dart';

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
