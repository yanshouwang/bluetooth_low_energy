import 'dart:typed_data';

import 'gatt_descriptor.dart';
import 'uuid.dart';

/// The GATT characteristic.
abstract class GattCharacteristic {
  /// The [UUID] of this [GattCharacteristic].
  UUID get uuid;

  /// Indicate whether this [GattCharacteristic] can read.
  bool get canRead;

  /// Indicate whether this [GattCharacteristic] can write.
  bool get canWrite;

  /// Indicate whether this [GattCharacteristic] can write without response.
  bool get canWriteWithoutResponse;

  /// Indicate whether this [GattCharacteristic] can notify.
  bool get canNotify;

  /// The descriptors of this [GattCharacteristic].
  Map<UUID, GattDescriptor> get descriptors;

  /// A stream for this [GattCharacteristic]'s value changed event.
  Stream<Uint8List> get valueChanged;

  /// TO BE DONE.
  Future<Uint8List> read();

  /// TO BE DONE.
  Future<void> write(Uint8List value, {bool withoutResponse = false});

  /// TO BE DONE.
  Future<void> notify(bool state);
}
