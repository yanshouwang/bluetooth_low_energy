import 'gatt_service.dart';
import 'my_gatt_attribute.dart';
import 'my_gatt_characteristic.dart';

class MyGattService extends MyGattAttribute implements GattService {
  @override
  final List<MyGattCharacteristic> characteristics;

  MyGattService({
    required super.uuid,
    required this.characteristics,
  });
}
