import 'dart:typed_data';

import 'gatt_descriptor.dart';
import 'uuid.dart';

abstract class GattCharacteristic {
  UUID get uuid;
  bool get canRead;
  bool get canWrite;
  bool get canWriteWithoutResponse;
  bool get canNotify;
  Stream<Uint8List> get valueStream;

  Future<List<GattDescriptor>> discoverDescriptors();
  Future<Uint8List> read();
  Future<void> write(Uint8List value, {bool withoutResponse = false});
}
