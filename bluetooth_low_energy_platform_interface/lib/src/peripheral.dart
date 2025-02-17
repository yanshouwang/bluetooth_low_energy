import 'bluetooth_low_energy_peer.dart';

/// A remote peripheral device.
abstract base class Peripheral extends BluetoothLowEnergyPeer {
  Peripheral.impl({
    required super.uuid,
  }) : super.impl();

  @override
  int get hashCode => uuid.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Peripheral && other.uuid == uuid;
  }
}
