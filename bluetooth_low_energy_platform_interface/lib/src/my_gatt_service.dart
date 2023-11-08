import 'gatt_service.dart';
import 'my_gatt_characteristic.dart';
import 'uuid.dart';

class MyGattService implements GattService {
  @override
  final UUID uuid;
  @override
  final List<MyGattCharacteristic> characteristics;

  MyGattService({
    required this.uuid,
    required this.characteristics,
  });
}
