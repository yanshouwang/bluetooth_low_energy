import 'gatt_attribute.dart';
import 'gatt_characteristic_property.dart';
import 'gatt_descriptor.dart';
import 'uuid.dart';

/// A characteristic of a remote peripheral’s service.
abstract class GattCharacteristic extends GattAttribute {
  /// The properties of the characteristic.
  List<GattCharacteristicProperty> get properties;

  /// A list of the descriptors discovered in this characteristic.
  List<GattDescriptor> get descriptors;

  /// Constructs a [GattCharacteristic].
  factory GattCharacteristic({
    required UUID uuid,
    required List<GattCharacteristicProperty> properties,
    required List<GattDescriptor> descriptors,
  }) =>
      CustomizedGattCharacteristic(
        uuid,
        properties,
        descriptors,
      );
}

class CustomizedGattCharacteristic implements GattCharacteristic {
  @override
  final UUID uuid;
  @override
  final List<GattCharacteristicProperty> properties;
  @override
  final List<GattDescriptor> descriptors;

  CustomizedGattCharacteristic(
    this.uuid,
    this.properties,
    this.descriptors,
  );
}
