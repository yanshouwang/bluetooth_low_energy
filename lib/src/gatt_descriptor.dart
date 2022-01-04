import 'dart:typed_data';

import 'uuid.dart';

/// The GATT descriptor.
abstract class GattDescriptor {
  /// The [UUID] of this [GattDescriptor].
  UUID get uuid;

  /// Read this [GattDescriptor].
  Future<Uint8List> read();

  /// Write this [GattDescriptor].
  Future<void> write(Uint8List value);
}
