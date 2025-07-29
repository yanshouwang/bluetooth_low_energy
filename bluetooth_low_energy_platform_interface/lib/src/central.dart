import 'bluetooth_low_energy_peer.dart';

/// A remote device connected to a local app, which is acting as a peripheral.
base class Central extends BluetoothLowEnergyPeer {
  Central({required super.uuid});

  @override
  int get hashCode => uuid.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Central && other.uuid == uuid;
  }
}
