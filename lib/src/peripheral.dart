import 'gatt_service.dart';
import 'uuid.dart';

abstract class Peripheral {
  UUID get uuid;

  Stream<Exception> get connectionLost;

  Future<void> connect();
  Future<void> disconnect();
  Future<int> requestMtu();
  Future<List<GattService>> discoverServices();
}
