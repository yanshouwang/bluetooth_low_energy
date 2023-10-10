import 'dart:typed_data';

import 'manufacturer_specific_data.dart';
import 'uuid.dart';

/// The advertise data discovered from a peripheral.
class AdvertiseData {
  /// The name of the peripheral.
  final String? name;

  /// The GATT service uuids of the peripheral.
  final List<UUID> serviceUUIDs;

  /// The GATT service data of the peripheral.
  final Map<UUID, Uint8List> serviceData;

  /// The manufacturer specific data of the peripheral.
  final ManufacturerSpecificData? manufacturerSpecificData;

  /// Constructs an [AdvertiseData].
  AdvertiseData({
    this.name,
    this.serviceUUIDs = const [],
    this.serviceData = const {},
    this.manufacturerSpecificData,
  });
}
