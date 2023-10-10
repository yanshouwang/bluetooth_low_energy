import 'dart:typed_data';

import 'gatt_attribute.dart';
import 'my_gatt_descriptor.dart';
import 'uuid.dart';

/// An object that provides further information about a remote peripheral’s characteristic.
abstract class GattDescriptor extends GattAttribute {
  /// Constructs a [GattDescriptor].
  factory GattDescriptor({
    required UUID uuid,
    required Uint8List value,
  }) =>
      MyGattDescriptor(
        uuid: uuid,
        value: value,
      );
}
