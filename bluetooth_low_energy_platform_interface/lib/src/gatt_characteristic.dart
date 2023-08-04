import 'gatt_characteristic_properties.dart';
import 'gatt_service.dart';
import 'uuid.dart';

abstract class GattCharacteristic {
  GattService get service;
  UUID get uuid;
  GattCharacteristicProperties get properties;
}
