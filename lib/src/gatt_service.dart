part of bluetooth_low_energy;

abstract class GattService {
  UUID get uuid;
  List<GattCharacteristic> get characteristics;
}

class _GattService implements GattService {
  _GattService(this.uuid, this.characteristics);

  @override
  final UUID uuid;
  @override
  final List<GattCharacteristic> characteristics;
}
