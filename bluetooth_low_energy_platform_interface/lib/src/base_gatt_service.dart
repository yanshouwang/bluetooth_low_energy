import 'base_gatt_attribute.dart';
import 'gatt_characteristic.dart';
import 'gatt_service.dart';

abstract base class BaseGattService extends BaseGattAttribute
    implements GattService {
  @override
  final List<GattCharacteristic> characteristics;

  BaseGattService({
    required super.uuid,
    required this.characteristics,
  });
}
