import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';

class MyGattCharacteristic2 extends MyGattCharacteristic {
  final BlueZGattCharacteristic characteristic;

  MyGattCharacteristic2(this.characteristic)
      : super(
          myHashCode: characteristic.hashCode,
          uuid: characteristic.myUUID,
          properties: characteristic.myProperties,
          descriptors: characteristic.myDescriptors,
        );
}
