import 'dart:typed_data';

import 'gatt_attribute.dart';
import 'uuid.dart';

abstract class MyGattAttribute implements GattAttribute {
  @override
  final UUID uuid;

  MyGattAttribute({
    required this.uuid,
  });
}

extension MyGattAttributeUint8List on Uint8List {
  Uint8List trimGATT() {
    return sublist(0, 512);
  }
}
