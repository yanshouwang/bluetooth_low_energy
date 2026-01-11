import 'dart:typed_data';

import 'manufacturer_specific_data.dart';
import 'uuid.dart';

/// The advertisement of the peripheral.
abstract interface class Advertisement {
  /// The name of the peripheral.
  ///
  /// This field is available on Android, iOS and macOS, throws [UnsupportedError]
  /// on other platforms.
  String? get name;

  /// The GATT service uuids of the peripheral.
  List<UUID> get serviceUUIDs;

  /// The GATT service data of the peripheral.
  ///
  /// This field is available on Android and Windows, throws [UnsupportedError]
  /// on other platforms.
  Map<UUID, Uint8List> get serviceData;

  /// The manufacturer specific data of the peripheral.
  ///
  /// This field is available on Android and Windows, throws [UnsupportedError]
  /// on other platforms.
  List<ManufacturerSpecificData> get manufacturerSpecificData;

  /// Constructs an [Advertisement].
  factory Advertisement({
    String? name,
    List<UUID> serviceUUIDs = const [],
    Map<UUID, Uint8List> serviceData = const {},
    List<ManufacturerSpecificData> manufacturerSpecificData = const [],
  }) => AdvertisementImpl(
    name: name,
    serviceUUIDs: serviceUUIDs,
    serviceData: serviceData,
    manufacturerSpecificData: manufacturerSpecificData,
  );
}

final class AdvertisementImpl implements Advertisement {
  @override
  final String? name;
  @override
  final List<UUID> serviceUUIDs;
  @override
  final Map<UUID, Uint8List> serviceData;
  @override
  final List<ManufacturerSpecificData> manufacturerSpecificData;

  AdvertisementImpl({
    required this.name,
    required this.serviceUUIDs,
    required this.serviceData,
    required this.manufacturerSpecificData,
  });
}
