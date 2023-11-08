import 'gatt_characteristic.dart';
import 'gatt_characteristic_property.dart';
import 'my_gatt_descriptor.dart';
import 'uuid.dart';

class MyGattCharacteristic implements GattCharacteristic {
  @override
  final UUID uuid;
  @override
  final List<GattCharacteristicProperty> properties;
  @override
  final List<MyGattDescriptor> descriptors;

  MyGattCharacteristic({
    required this.uuid,
    required this.properties,
    required this.descriptors,
  });
}
