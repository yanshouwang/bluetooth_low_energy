import 'gatt_service.dart';
import 'uuid.dart';

/// Bluetooth GATT.
abstract class GATT {
  int get maximumWriteLength;

  Map<UUID, GattService> get services;

  Future<void> disconnect();
}
