import 'bluetooth.dart';
import 'bluetooth_implementation.dart';
import 'gatt.dart';
import 'peripheral_discovery.dart';
import 'uuid.dart';

final central = Central._();

/// An object that scans for, discovers, connects to, and manages peripherals.
abstract class Central extends Bluetooth {
  /// The central discovered a peripheral while scanning for devices.
  Stream<PeripheralDiscovery> get discovered;

  /// Start discover peripherals that are advertising services.
  Future<void> startDiscovery({List<UUID>? uuids});

  /// Stop discover peripherals.
  Future<void> stopDiscovery();

  /// Establishes a local connection to a peripheral.
  Future<GATT> connect(UUID uuid);

  factory Central._() => $Central();
}
