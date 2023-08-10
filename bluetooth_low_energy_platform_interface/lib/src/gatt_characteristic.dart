import 'gatt_characteristic_property.dart';
import 'uuid.dart';

class GattCharacteristic {
  final UUID uuid;
  final List<GattCharacteristicProperty> properties;

  GattCharacteristic({
    required this.uuid,
    required this.properties,
  });
}
