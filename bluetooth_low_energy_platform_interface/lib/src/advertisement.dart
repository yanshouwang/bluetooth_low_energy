import 'dart:typed_data';

abstract class Advertisement {
  Future<String?> getName();
  Future<Uint8List?> getManufacturerSpecificData();
}
