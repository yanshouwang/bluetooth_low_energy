import 'gatt_characteristic.dart';
import 'uuid.dart';

abstract class GattDescriptor {
  GattCharacteristic get characteristic;
  UUID get uuid;
}
