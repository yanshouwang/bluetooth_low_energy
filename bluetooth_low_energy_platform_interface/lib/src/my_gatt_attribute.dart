import 'gatt_attribute.dart';
import 'uuid.dart';

abstract class MyGattAttribute implements GattAttribute {
  @override
  final UUID uuid;

  MyGattAttribute({
    required this.uuid,
  });
}
