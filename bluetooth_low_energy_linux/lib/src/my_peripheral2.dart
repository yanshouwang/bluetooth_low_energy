import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';

class MyPeripheral2 extends MyPeripheral {
  final BlueZDevice blueZDevice;

  MyPeripheral2(this.blueZDevice)
      : super(
          uuid: blueZDevice.myUUID,
        );
}
