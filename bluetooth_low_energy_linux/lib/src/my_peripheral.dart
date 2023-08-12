import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';
import 'my_object.dart';

class MyPeripheral extends MyObject implements Peripheral {
  final BlueZDevice device;

  MyPeripheral(this.device) : super(device);

  @override
  UUID get uuid => device.uuid.toUUID();
}
