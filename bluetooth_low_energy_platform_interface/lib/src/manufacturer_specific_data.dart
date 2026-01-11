import 'dart:typed_data';

/// The manufacturer specific data of the peripheral
abstract interface class ManufacturerSpecificData {
  /// The manufacturer id.
  int get id;

  /// The manufacturer data.
  Uint8List get data;

  /// Constructs an [ManufacturerSpecificData].
  factory ManufacturerSpecificData({
    required int id,
    required Uint8List data,
  }) => ManufacturerSpecificDataImpl(id: id, data: data);
}

final class ManufacturerSpecificDataImpl implements ManufacturerSpecificData {
  @override
  final int id;

  @override
  final Uint8List data;

  ManufacturerSpecificDataImpl({required this.id, required this.data});
}
