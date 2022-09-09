import 'package:pigeon/pigeon.dart';

import 'gatt_descriptor.dart';

abstract class GattCharacteristic {
  Stream<Uint8List> get valueStream;

  Future<List<GattDescriptor>> discoverDescriptors();
  Future<Uint8List> read();
  Future<void> write(Uint8List value);
}
