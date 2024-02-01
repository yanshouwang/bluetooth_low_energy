import 'dart:typed_data';

import 'gatt_attribute.dart';
import 'gatt_characteristic_property.dart';
import 'gatt_descriptor.dart';
import 'my_gatt_characteristic.dart';
import 'my_gatt_descriptor.dart';
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
    Uint8List? value,
    required List<GattDescriptor> descriptors,
  }) =>
      MyGattCharacteristic(
        uuid: uuid,
        properties: properties,
        value: value,
        descriptors: descriptors.cast<MyGattDescriptor>(),
      );
}
