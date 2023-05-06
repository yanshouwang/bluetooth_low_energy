import 'gatt_characteristic.dart';

class GattService {
  final String id;
  final List<GattCharacteristic> characteristics;

  GattService({
    required this.id,
    required this.characteristics,
  });
}
