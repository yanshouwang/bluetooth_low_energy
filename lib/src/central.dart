import 'bluetooth.dart';
import 'bluetooth_implementation.dart';
import 'gatt.dart';
import 'discovery.dart';
import 'uuid.dart';

final central = Central._();

/// An object that scans for, discovers, connects to, and manages peripherals.
abstract class Central extends Bluetooth {
  factory Central._() => $Central();

  Stream<Discovery> startDiscovery({List<UUID>? uuids});

  Future<GATT> connect(
    UUID uuid, {
    required void Function(int errorCode) onConnectionLost,
  });
}
