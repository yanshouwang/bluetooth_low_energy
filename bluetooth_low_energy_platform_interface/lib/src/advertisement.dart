import 'dart:typed_data';

import 'manufacturer_specific_data.dart';
import 'uuid.dart';

/// The advertisement discovered from a peripheral.
class Advertisement {
  /// The name of the peripheral.
  final String? name;

  /// The manufacturer specific data of the peripheral.
  final ManufacturerSpecificData? manufacturerSpecificData;

  /// The GATT service uuids of the peripheral.
  final List<UUID> serviceUUIDs;

  /// The GATT service data of the peripheral.
  final Map<UUID, Uint8List> serviceData;

  /// Constructs an [Advertisement].
  Advertisement({
    this.name,
    this.manufacturerSpecificData,
    this.serviceUUIDs = const [],
    this.serviceData = const {},
  });
}
