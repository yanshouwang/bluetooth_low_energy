import 'gatt_service.dart';
import 'uuid.dart';

/// Bluetooth GATT.
abstract class GATT {
  /// The size of MTU.
  int get maximumWriteLength;

  /// A stream for connection lost event.
  Stream<Exception> get connectionLost;

  /// The services of this [GATT].
  Map<UUID, GattService> get services;

  /// Disconnect this [GATT].
  Future<void> disconnect();
}
