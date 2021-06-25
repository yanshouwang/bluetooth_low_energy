part of bluetooth_low_energy;

abstract class GattDescriptor {
  UUID get uuid;
}

class _GattDescriptor implements GattDescriptor {
  _GattDescriptor(this.uuid);

  @override
  final UUID uuid;
}
