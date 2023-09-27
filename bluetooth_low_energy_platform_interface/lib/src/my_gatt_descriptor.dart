import 'dart:typed_data';

import 'gatt_descriptor.dart';
import 'my_gatt_characteristic.dart';
import 'my_object.dart';
import 'uuid.dart';

class MyGattDescriptor extends MyObject implements GattDescriptor {
  @override
  final UUID uuid;
  final Uint8List? value;

  late MyGattCharacteristic myCharacteristic;

  MyGattDescriptor({
    super.myHashCode,
    required this.uuid,
    this.value,
  });
}
