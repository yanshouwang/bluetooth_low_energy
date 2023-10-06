import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';

class MyGattService2 extends MyGattService {
  final BlueZGattService service;

  MyGattService2(this.service)
      : super(
          hashCode: service.hashCode,
          uuid: service.myUUID,
          characteristics: service.myCharacteristics,
        );
}
