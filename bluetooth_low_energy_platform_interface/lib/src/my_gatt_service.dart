import 'gatt_service.dart';
import 'my_gatt_characteristic.dart';
import 'my_object.dart';
import 'my_peripheral.dart';
import 'uuid.dart';

class MyGattService extends MyObject implements GattService {
  @override
  final UUID uuid;
  @override
  final List<MyGattCharacteristic> characteristics;

  late MyPeripheral myPeripheral;

  MyGattService({
    super.myHashCode,
    required this.uuid,
    required this.characteristics,
  });
}
