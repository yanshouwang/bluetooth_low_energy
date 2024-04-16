import 'base_gatt_attribute.dart';
import 'gatt_characteristic.dart';
import 'gatt_characteristic_property.dart';
import 'gatt_descriptor.dart';

abstract base class BaseGattCharacteristic extends BaseGattAttribute
    implements GattCharacteristic {
  @override
  final List<GattCharacteristicProperty> properties;

  @override
  final List<GattDescriptor> descriptors;

  BaseGattCharacteristic({
    required super.uuid,
    required this.properties,
    required this.descriptors,
  });
}
