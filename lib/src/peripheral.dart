import 'gatt_service.dart';
import 'uuid.dart';

abstract class Peripheral {
  UUID get uuid;
  bool get connectable;

  Future<int> connect(Function(Exception error) onConnectionLost);
  Future<void> disconnect();
  Future<List<GattService>> discoverServices();
}
