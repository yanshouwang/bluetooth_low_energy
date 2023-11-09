import 'gatt_characteristic.dart';
import 'gatt_characteristic_property.dart';
import 'gatt_descriptor.dart';
import 'my_gatt_attribute.dart';

class MyGattCharacteristic extends MyGattAttribute
    implements GattCharacteristic {
  @override
  final List<GattCharacteristicProperty> properties;
  @override
  final List<GattDescriptor> descriptors;

  MyGattCharacteristic({
    required super.uuid,
    required this.properties,
    required this.descriptors,
  });
}
