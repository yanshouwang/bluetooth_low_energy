import 'gatt_service.dart';

abstract class Peripheral {
  int get maximumWriteLength;

  Future<void> disconnect();
  Future<List<GattService>> discoverServices();
}
