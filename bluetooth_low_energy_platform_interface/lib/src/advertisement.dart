import 'dart:typed_data';

import 'manufacturer_specific_data.dart';
import 'uuid.dart';

/// The advertisement of the peripheral.
final class Advertisement {
  /// The name of the peripheral.
  final String? name;

  /// The GATT service uuids of the peripheral.
  final List<UUID> serviceUUIDs;

  /// The GATT service data of the peripheral.
  final Map<UUID, Uint8List> serviceData;

  /// The manufacturer specific data of the peripheral.
  final ManufacturerSpecificData? manufacturerSpecificData;

  /// Constructs an [Advertisement].
  Advertisement({
    this.name,
    this.serviceUUIDs = const [],
    this.serviceData = const {},
    this.manufacturerSpecificData,
  });
}
