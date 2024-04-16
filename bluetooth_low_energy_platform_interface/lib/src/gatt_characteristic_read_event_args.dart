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
