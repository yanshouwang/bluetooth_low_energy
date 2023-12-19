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

extension Uint8ListX on Uint8List {
  Uint8List trimGATT() {
    final elements = take(512).toList();
    return Uint8List.fromList(elements);
  }
}
