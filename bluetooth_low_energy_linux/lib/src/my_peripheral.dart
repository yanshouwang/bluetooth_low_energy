import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';

final class MyPeripheral extends Peripheral {
  final BlueZDevice blueZDevice;

  MyPeripheral(this.blueZDevice)
      : super(
          uuid: blueZDevice.myUUID,
        );
}
