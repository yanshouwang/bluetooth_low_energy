part of bluetooth_low_energy;

/// TO BE DONE.
abstract class GattService {
  /// TO BE DONE.
  UUID get uuid;

  /// TO BE DONE.
  Map<UUID, GattCharacteristic> get characteristics;
}

class _GattService implements GattService {
  _GattService(this.id, this.uuid, this.characteristics);

  final int id;
  @override
  final UUID uuid;
  @override
  final Map<UUID, GattCharacteristic> characteristics;
}
