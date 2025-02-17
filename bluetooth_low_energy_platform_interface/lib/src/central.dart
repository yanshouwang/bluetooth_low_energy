import 'bluetooth_low_energy_peer.dart';

/// A remote device connected to a local app, which is acting as a peripheral.
abstract base class Central extends BluetoothLowEnergyPeer {
  Central.impl({
    required super.uuid,
  }) : super.impl();

  @override
  int get hashCode => uuid.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Central && other.uuid == uuid;
  }
}
