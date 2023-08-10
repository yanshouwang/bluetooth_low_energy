import 'dart:typed_data';

class Advertisement {
  final String? name;
  final Uint8List? manufacturerSpecificData;

  Advertisement({
    this.name,
    this.manufacturerSpecificData,
  });
}
