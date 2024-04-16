import 'dart:typed_data';

import 'base_gatt_characteristic.dart';
import 'gatt.dart';
import 'mutable_gatt_descriptor.dart';

base class MutableGattCharacteristic extends BaseGattCharacteristic {
  Uint8List _value;

  MutableGattCharacteristic({
    required super.uuid,
    required super.properties,
    Uint8List? value,
    required List<MutableGattDescriptor> descriptors,
  })  : _value = value?.trimGATT() ?? Uint8List(0),
        super(
          descriptors: descriptors,
        );

  Uint8List get value => _value;
  set value(Uint8List value) {
    _value = value.trimGATT();
  }

  @override
  List<MutableGattDescriptor> get descriptors =>
      super.descriptors.cast<MutableGattDescriptor>();
}
