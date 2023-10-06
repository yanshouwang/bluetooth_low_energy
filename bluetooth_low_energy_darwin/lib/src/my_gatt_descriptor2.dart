import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_gatt_characteristic2.dart';

class MyGattDescriptor2 extends MyGattDescriptor {
  late final MyGattCharacteristic2 characteristic;

  MyGattDescriptor2({
    super.hashCode,
    required super.uuid,
  });
}
