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

  /// [Android] Add the local name to the primary advertisement packet.
  /// May fail with `ADVERTISE_FAILED_DATA_TOO_LARGE` (`1`) if the ad is too
  /// large or fallback to false.
  bool get includeDeviceNameInAdvertisement;

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
    bool includeDeviceNameInAdvertisement = false,
    List<UUID> serviceUUIDs = const [],
    Map<UUID, Uint8List> serviceData = const {},
    List<ManufacturerSpecificData> manufacturerSpecificData = const [],
  }) => AdvertisementImpl(
    name: name,
    includeDeviceNameInAdvertisement: includeDeviceNameInAdvertisement,
    serviceUUIDs: serviceUUIDs,
    serviceData: serviceData,
    manufacturerSpecificData: manufacturerSpecificData,
  );
}

final class AdvertisementImpl implements Advertisement {
  @override
  final String? name;
  @override
  final bool includeDeviceNameInAdvertisement;
  @override
  final List<UUID> serviceUUIDs;
  @override
  final Map<UUID, Uint8List> serviceData;
  @override
  final List<ManufacturerSpecificData> manufacturerSpecificData;

  AdvertisementImpl({
    required this.name,
    required this.includeDeviceNameInAdvertisement,
    required this.serviceUUIDs,
    required this.serviceData,
    required this.manufacturerSpecificData,
  });
}
