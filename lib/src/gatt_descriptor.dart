import 'dart:typed_data';

import 'uuid.dart';

/// The GATT descriptor.
abstract class GattDescriptor {
  /// The [UUID] of this [GattDescriptor].
  UUID get uuid;

  Future<Uint8List> read();

  Future<void> write(Uint8List value);
}
