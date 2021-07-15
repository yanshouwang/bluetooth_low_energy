part of bluetooth_low_energy;

/// TO BE DONE.
abstract class GattService {
  /// TO BE DONE.
  UUID get uuid;

  /// TO BE DONE.
  Map<UUID, GattCharacteristic> get characteristics;
}

class _GattService implements GattService {
  _GattService(this.gattKey, this.key, this.uuid, this.characteristics);

  final String gattKey;
  final String key;
  @override
  final UUID uuid;
  @override
  final Map<UUID, GattCharacteristic> characteristics;
}
