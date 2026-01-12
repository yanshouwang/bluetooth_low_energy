import 'uuid.dart';

/// An object that represents a remote device.
abstract interface class BluetoothLowEnergyPeer {
  /// The address associated with the peer.
  // String get address;

  /// The UUID associated with the peer.
  UUID get uuid;
}
