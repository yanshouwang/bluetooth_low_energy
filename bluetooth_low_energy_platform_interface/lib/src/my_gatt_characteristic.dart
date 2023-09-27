import 'gatt_characteristic.dart';
import 'gatt_characteristic_property.dart';
import 'my_gatt_descriptor.dart';
import 'my_gatt_service.dart';
import 'my_object.dart';
import 'uuid.dart';

class MyGattCharacteristic extends MyObject implements GattCharacteristic {
  @override
  final UUID uuid;
  @override
  final List<GattCharacteristicProperty> properties;
  @override
  final List<MyGattDescriptor> descriptors;

  late MyGattService myService;

  MyGattCharacteristic({
    super.myHashCode,
    required this.uuid,
    required this.properties,
    required this.descriptors,
  }) {
    for (var descriptor in descriptors) {
      descriptor.myCharacteristic = this;
    }
  }
}
