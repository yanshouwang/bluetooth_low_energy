import 'dart:typed_data';

class Advertisement {
  final String? name;
  final Map<int, Uint8List> manufacturerSpecificData;

  Advertisement({
    this.name,
    this.manufacturerSpecificData = const {},
  });
}
