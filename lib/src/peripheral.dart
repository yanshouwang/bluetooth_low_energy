import 'gatt_service.dart';

abstract class Peripheral {
  Future<void> disconnect();
  Future<int> requestMtu();
  Future<List<GattService>> discoverServices();
}
