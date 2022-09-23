import 'gatt_characteristic.dart';
import 'uuid.dart';

abstract class GattService {
  UUID get uuid;

  Future<List<GattCharacteristic>> discoverCharacteristics();
}
