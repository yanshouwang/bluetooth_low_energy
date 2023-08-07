import 'gatt_characteristic_property.dart';
import 'uuid.dart';

abstract class GattCharacteristic {
  Future<UUID> getUUID();
  Future<List<GattCharacteristicProperty>> getProperties();
}
