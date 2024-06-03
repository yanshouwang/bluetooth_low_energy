import 'bluetooth_low_energy_peer.dart';

/// A remote peripheral device.
base class Peripheral extends BluetoothLowEnergyPeer {
  Peripheral({
    required super.uuid,
  });

  @override
  int get hashCode => uuid.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Peripheral && other.uuid == uuid;
  }
}
