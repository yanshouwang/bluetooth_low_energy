import 'package:bluetooth_low_energy/src/event_subscription.dart';

import 'bluetooth.dart';
import 'bluetooth_implementation.dart';
import 'gatt.dart';
import 'discovery.dart';
import 'uuid.dart';

final central = Central._();

/// An object that scans for, discovers, connects to, and manages peripherals.
abstract class Central extends Bluetooth {
  factory Central._() => $Central();

  Future<EventSubscription> scan({
    List<UUID>? uuids,
    required void Function(Discovery discovery) onScanned,
  });

  Future<GATT> connect({
    required UUID uuid,
    required void Function(int errorCode) onConnectionLost,
  });
}
