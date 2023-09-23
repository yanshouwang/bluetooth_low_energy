import 'gatt_attribute.dart';
import 'gatt_characteristic_property.dart';
import 'gatt_descriptor.dart';
import 'uuid.dart';

/// A characteristic of a remote peripheral’s service.
abstract class GattCharacteristic extends GattAttribute {
  /// A list of the descriptors discovered in this characteristic.
  List<GattDescriptor> get descriptors;

  /// The properties of the characteristic.
  List<GattCharacteristicProperty> get properties;

  /// Constructs a [GattCharacteristic].
  factory GattCharacteristic({
    required UUID uuid,
    required List<GattDescriptor> descriptors,
    required List<GattCharacteristicProperty> properties,
  }) =>
      CustomizedGattCharacteristic(
        uuid,
        descriptors,
        properties,
      );
}

class CustomizedGattCharacteristic implements GattCharacteristic {
  @override
  final UUID uuid;
  @override
  final List<GattDescriptor> descriptors;
  @override
  final List<GattCharacteristicProperty> properties;

  CustomizedGattCharacteristic(
    this.uuid,
    this.descriptors,
    this.properties,
  );
}
