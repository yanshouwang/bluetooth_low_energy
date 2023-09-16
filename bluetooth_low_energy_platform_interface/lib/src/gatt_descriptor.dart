import 'dart:typed_data';

import 'uuid.dart';

/// The GATT characteristic.
class GattDescriptor {
  /// The [UUID] of this GATT descriptor.
  final UUID uuid;

  GattDescriptor._inner(this.uuid);

  /// Constructs a [GattDescriptor].
  factory GattDescriptor({
    required UUID uuid,
    Uint8List? value,
  }) {
    if (value == null) {
      return GattDescriptor._inner(uuid);
    } else {
      return CustomGattDescriptor(uuid, value);
    }
  }
}

class CustomGattDescriptor extends GattDescriptor {
  final Uint8List value;

  CustomGattDescriptor(UUID uuid, this.value) : super._inner(uuid);
}
