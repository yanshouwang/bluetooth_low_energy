part of bluetooth_low_energy;

abstract class GattService {
  UUID get uuid;
  Map<UUID, GattCharacteristic> get characteristics;
}

class _GattService implements GattService {
  _GattService(this.address, this.id, this.uuid, this.characteristics);

  final MAC address;
  final int id;
  @override
  final UUID uuid;
  @override
  final Map<UUID, GattCharacteristic> characteristics;
}
