import 'dart:typed_data';

import 'gatt_descriptor.dart';
import 'my_object.dart';
import 'uuid.dart';

class MyGattDescriptor extends MyObject implements GattDescriptor {
  @override
  final UUID uuid;
  final Uint8List? value;

  MyGattDescriptor({
    super.hashCode,
    required this.uuid,
    this.value,
  });
}
