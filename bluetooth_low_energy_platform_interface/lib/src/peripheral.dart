import 'bluetooth_low_energy_peer.dart';

/// A remote peripheral device.
abstract interface class Peripheral implements BluetoothLowEnergyPeer {
  /// The name of the peripheral as reported by the operating system
  /// (`CBPeripheral.name` on iOS/macOS, `BluetoothDevice.getName()` on Android).
  ///
  /// Null when the platform does not expose a name for the peripheral. Unlike a
  /// GATT read of the Generic Access device name (0x2A00), this is available on
  /// iOS, where CoreBluetooth hides the Generic Access service.
  String? get name;
}
