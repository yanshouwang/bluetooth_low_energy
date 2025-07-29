import 'uuid.dart';

/// An object that represents a remote device.
abstract base class BluetoothLowEnergyPeer {
  /// The UUID associated with the peer.
  final UUID uuid;

  BluetoothLowEnergyPeer({required this.uuid});

  @override
  int get hashCode => uuid.hashCode;

  @override
  bool operator ==(Object other) {
    return other is BluetoothLowEnergyPeer && other.uuid == uuid;
  }
}
