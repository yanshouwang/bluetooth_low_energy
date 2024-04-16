import 'dart:typed_data';

import 'base_gatt_descriptor.dart';
import 'gatt.dart';

base class MutableGattDescriptor extends BaseGattDescriptor {
  Uint8List _value;

  MutableGattDescriptor({
    required super.uuid,
    Uint8List? value,
  }) : _value = value?.trimGATT() ?? Uint8List(0);

  Uint8List get value => _value;
  set value(Uint8List value) {
    _value = value.trimGATT();
  }
}
