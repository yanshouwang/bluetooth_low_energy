import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_gatt_characteristic2.dart';

class MyGattService2 extends MyGattService {
  late final MyPeripheral peripheral;

  MyGattService2({
    super.hashCode,
    required super.uuid,
    required List<MyGattCharacteristic2> characteristics,
  }) : super(characteristics: characteristics);

  @override
  List<MyGattCharacteristic2> get characteristics =>
      super.characteristics.cast<MyGattCharacteristic2>();
}
