import 'gatt_characteristic.dart';
import 'gatt_service.dart';
import 'my_gatt_attribute.dart';

class MyGattService extends MyGattAttribute implements GattService {
  @override
  final List<GattCharacteristic> characteristics;

  MyGattService({
    required super.uuid,
    required this.characteristics,
  });
}
