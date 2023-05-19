import 'dart:typed_data';

class Peripheral {
  final String id;
  final String name;
  final int rssi;
  final Uint8List? manufacturerSpecificData;

  Peripheral({
    required this.id,
    required this.name,
    required this.rssi,
    required this.manufacturerSpecificData,
  });
}
