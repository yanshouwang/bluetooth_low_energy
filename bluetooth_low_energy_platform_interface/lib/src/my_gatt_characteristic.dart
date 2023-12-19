import 'dart:typed_data';

import 'gatt_characteristic.dart';
import 'gatt_characteristic_property.dart';
import 'my_gatt_attribute.dart';
import 'my_gatt_descriptor.dart';

class MyGattCharacteristic extends MyGattAttribute
    implements GattCharacteristic {
  @override
  final List<GattCharacteristicProperty> properties;
  Uint8List? _value;
  @override
  final List<MyGattDescriptor> descriptors;

  MyGattCharacteristic({
    required super.uuid,
    required this.properties,
    Uint8List? value,
    required this.descriptors,
  }) : _value = value?.trimGATT();

  Uint8List get value => _value ?? Uint8List.fromList([]);
  set value(Uint8List value) {
    _value = value.trimGATT();
  }
}
