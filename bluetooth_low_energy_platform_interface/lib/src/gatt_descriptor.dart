import 'uuid.dart';

/// The GATT characteristic.
class GattDescriptor {
  /// The [UUID] of this GATT descriptor.
  final UUID uuid;

  /// Constructs a [GattDescriptor].
  GattDescriptor({
    required this.uuid,
  });
}
