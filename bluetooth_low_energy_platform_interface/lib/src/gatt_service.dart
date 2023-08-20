import 'uuid.dart';

/// The GATT service.
class GattService {
  /// The [UUID] of this GATT service.
  final UUID uuid;

  /// Constructs a [GattService].
  GattService({
    required this.uuid,
  });
}
