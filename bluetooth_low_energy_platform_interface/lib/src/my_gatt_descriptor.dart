import 'dart:typed_data';

import 'gatt_descriptor.dart';
import 'my_gatt_attribute.dart';

class MyGattDescriptor extends MyGattAttribute implements GattDescriptor {
  final Uint8List? value;

  MyGattDescriptor({
    required super.uuid,
    this.value,
  });
}
