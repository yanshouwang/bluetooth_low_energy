import 'gatt_attribute.dart';
import 'uuid.dart';

abstract base class BaseGattAttribute implements GattAttribute {
  @override
  final UUID uuid;

  BaseGattAttribute({
    required this.uuid,
  });
}
