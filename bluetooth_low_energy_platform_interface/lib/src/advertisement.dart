import 'dart:typed_data';

import 'uuid.dart';

/// The advertisement discovered from a peripheral.
class Advertisement {
  /// The name of the peripheral.
  final String? name;

  /// The manufacturer specific data of the peripheral.
  final Map<int, Uint8List> manufacturerSpecificData;

  /// The GATT service uuids of the peripheral.
  final List<UUID> serviceUUIDs;

  /// The GATT service data of the peripheral.
  final Map<UUID, Uint8List> serviceData;

  /// Constructs an [Advertisement].
  Advertisement({
    this.name,
    this.manufacturerSpecificData = const {},
    this.serviceUUIDs = const [],
    this.serviceData = const {},
  });
}
