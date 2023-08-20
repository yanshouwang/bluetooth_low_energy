import 'gatt_characteristic_property.dart';
import 'uuid.dart';

/// The GATT characteristic.
class GattCharacteristic {
  /// The [UUID] of this GATT characteristic.
  final UUID uuid;

  /// The properties of this GATT characteristic.
  final List<GattCharacteristicProperty> properties;

  /// Constructs a [GattCharacteristic].
  GattCharacteristic({
    required this.uuid,
    required this.properties,
  });
}
