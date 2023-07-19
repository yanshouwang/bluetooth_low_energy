import 'dart:typed_data';

class Peripheral {
  final String id;
  final int rssi;
  final String? name;
  final Uint8List? manufacturerSpecificData;

  Peripheral({
    required this.id,
    required this.rssi,
    required this.name,
    required this.manufacturerSpecificData,
  });
}
