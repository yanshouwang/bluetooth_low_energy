import 'bluetooth_low_energy_peer.dart';

/// A remote device connected to a local app, which is acting as a peripheral.
abstract class Central extends BluetoothLowEnergyPeer {
  /// The maximum amount of data, in bytes, that the central can receive in a
  /// single notification or indication.
  int get maximumWriteLength;
}
