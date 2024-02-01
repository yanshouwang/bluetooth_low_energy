import 'dart:typed_data';

import 'gatt_descriptor.dart';
import 'my_gatt_attribute.dart';

class MyGattDescriptor extends MyGattAttribute implements GattDescriptor {
  Uint8List _value;

  MyGattDescriptor({
    required super.uuid,
    Uint8List? value,
  }) : _value = value?.trimGATT() ?? Uint8List(0);

  Uint8List get value => _value;
  set value(Uint8List value) {
    _value = value.trimGATT();
  }
}
