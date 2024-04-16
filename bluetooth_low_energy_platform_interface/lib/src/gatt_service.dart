import 'gatt_attribute.dart';
import 'gatt_characteristic.dart';
import 'mutable_gatt_characteristic.dart';
import 'mutable_gatt_service.dart';
import 'uuid.dart';

/// A collection of data and associated behaviors that accomplish a function or feature of a device.
abstract interface class GattService implements GattAttribute {
  /// A list of characteristics discovered in this service.
  List<GattCharacteristic> get characteristics;

  /// Constructs a [GattService].
  factory GattService({
    required UUID uuid,
    required List<GattCharacteristic> characteristics,
  }) =>
      MutableGattService(
        uuid: uuid,
        characteristics: characteristics.cast<MutableGattCharacteristic>(),
      );
}
