import 'dart:typed_data';

/// The manufacturer specific data of the peripheral
final class ManufacturerSpecificData {
  /// The manufacturer id.
  final int id;

  /// The manufacturer data.
  final Uint8List data;

  /// Constructs an [ManufacturerSpecificData].
  ManufacturerSpecificData({
    required this.id,
    required this.data,
  });
}
