import 'dart:typed_data';

import 'gatt_descriptor.dart';
import 'uuid.dart';

class MyGattDescriptor implements GattDescriptor {
  @override
  final UUID uuid;
  final Uint8List? value;

  MyGattDescriptor({
    required this.uuid,
    this.value,
  });
}
