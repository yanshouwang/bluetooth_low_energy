import 'gatt_attribute.dart';
import 'gatt_characteristic.dart';
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
      CustomizedGattService(uuid, characteristics);
}

class CustomizedGattService implements GattService {
  @override
  final UUID uuid;
  @override
  final List<GattCharacteristic> characteristics;

  CustomizedGattService(this.uuid, this.characteristics);
}
