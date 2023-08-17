import 'dart:typed_data';

import 'uuid.dart';

class Advertisement {
  final String? name;
  final Map<int, Uint8List> manufacturerSpecificData;
  final List<UUID> serviceUUIDs;
  final Map<UUID, Uint8List> serviceData;

  Advertisement({
    this.name,
    this.manufacturerSpecificData = const {},
    this.serviceUUIDs = const [],
    this.serviceData = const {},
  });
}
