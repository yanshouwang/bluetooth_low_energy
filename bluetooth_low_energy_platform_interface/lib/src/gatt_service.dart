import 'gatt_attribute.dart';
import 'gatt_characteristic.dart';
import 'my_gatt_service.dart';
import 'uuid.dart';

/// A collection of data and associated behaviors that accomplish a function or feature of a device.
abstract class GattService extends GattAttribute {
  /// A list of characteristics discovered in this service.
  List<GattCharacteristic> get characteristics;

  /// Constructs a [GattService].
  factory GattService({
    required UUID uuid,
    required List<GattCharacteristic> characteristics,
  }) =>
      MyGattService(
        uuid: uuid,
        characteristics: characteristics,
      );
}
