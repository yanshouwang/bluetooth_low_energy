import 'dart:typed_data';

import 'event_args.dart';
import 'gatt_characteristic.dart';

/// The GATT characteristic notified event arguments.
base class GattCharacteristicNotifiedEventArgs extends EventArgs {
  /// The GATT characteristic which notified.
  final GattCharacteristic characteristic;

  /// The notified value.
  final Uint8List value;

  /// Constructs a [GattCharacteristicNotifiedEventArgs].
  GattCharacteristicNotifiedEventArgs(
    this.characteristic,
    this.value,
  );
}
