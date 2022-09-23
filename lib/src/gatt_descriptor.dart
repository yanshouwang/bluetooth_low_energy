import 'dart:typed_data';

import 'uuid.dart';

abstract class GattDescriptor {
  UUID get uuid;

  Future<Uint8List> read();
  Future<void> write(Uint8List value);
}
