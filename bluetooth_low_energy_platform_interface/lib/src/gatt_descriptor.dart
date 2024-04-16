import 'dart:typed_data';

import 'gatt_attribute.dart';
import 'mutable_gatt_descriptor.dart';
import 'uuid.dart';

/// An object that provides further information about a remote peripheral’s characteristic.
abstract interface class GattDescriptor implements GattAttribute {
  /// Constructs a [GattDescriptor].
  factory GattDescriptor({
    required UUID uuid,
    Uint8List? value,
  }) =>
      MutableGattDescriptor(
        uuid: uuid,
        value: value,
      );
}
