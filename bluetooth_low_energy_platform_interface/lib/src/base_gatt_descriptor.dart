import 'base_gatt_attribute.dart';
import 'gatt_descriptor.dart';

abstract base class BaseGattDescriptor extends BaseGattAttribute
    implements GattDescriptor {
  BaseGattDescriptor({
    required super.uuid,
  });
}
