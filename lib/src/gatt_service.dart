part of bluetooth_low_energy;

abstract class GattService {
  UUID get uuid;
  Map<UUID, GattCharacteristic> get characteristics;
}

class _GattService implements GattService {
  _GattService(this.device, this.uuid, this.characteristics);

  final MAC device;
  @override
  final UUID uuid;
  @override
  final Map<UUID, GattCharacteristic> characteristics;
}
