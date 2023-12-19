import 'dart:typed_data';

import 'gatt_characteristic.dart';
import 'gatt_characteristic_property.dart';
import 'my_gatt_attribute.dart';
import 'my_gatt_descriptor.dart';

class MyGattCharacteristic extends MyGattAttribute
    implements GattCharacteristic {
  @override
  final List<GattCharacteristicProperty> properties;
  final Uint8List? value;
  @override
  final List<MyGattDescriptor> descriptors;

  MyGattCharacteristic({
    required super.uuid,
    required this.properties,
    this.value,
    required this.descriptors,
  });
}
