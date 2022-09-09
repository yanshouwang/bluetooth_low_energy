import 'gatt_characteristic.dart';

abstract class GattService {
  Future<List<GattCharacteristic>> discoverCharacteristics();
}
