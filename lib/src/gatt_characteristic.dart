import 'dart:typed_data';

import 'package:bluetooth_low_energy/src/event_subscription.dart';

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

  Future<Uint8List> read();

  Future<void> write(Uint8List value, {bool withoutResponse = false});

  Future<EventSubscription> notify({
    required void Function(Uint8List value) onValueChanged,
  });
}
