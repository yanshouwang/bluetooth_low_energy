import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';

class MyPeripheral2 extends MyPeripheral {
  final BlueZDevice device;

  MyPeripheral2(this.device)
      : super(
          hashCode: device.hashCode,
          uuid: device.myUUID,
        );
}
