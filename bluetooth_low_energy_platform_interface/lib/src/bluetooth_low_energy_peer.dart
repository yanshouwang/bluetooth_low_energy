import 'uuid.dart';

/// An object that represents a remote device.
abstract class BluetoothLowEnergyPeer {
  /// The UUID associated with the peer.
  UUID get uuid;
}
