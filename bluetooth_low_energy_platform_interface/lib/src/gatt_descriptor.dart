import 'dart:typed_data';

import 'gatt_attribute.dart';
import 'uuid.dart';

/// An object that provides further information about a remote peripheral’s characteristic.
abstract class GattDescriptor extends GattAttribute {
  /// Constructs a [GattDescriptor].
  factory GattDescriptor({
    required UUID uuid,
    required Uint8List value,
  }) =>
      CustomizedGattDescriptor(uuid, value);
}

/// An object that provides additional information about a local peripheral’s characteristic.
class CustomizedGattDescriptor implements GattDescriptor {
  @override
  final UUID uuid;

  /// The value of the descriptor.
  final Uint8List value;

  /// Constructs a [CustomizedGattDescriptor].
  CustomizedGattDescriptor(this.uuid, this.value);
}
