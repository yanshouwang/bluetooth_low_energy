import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';
import 'my_object.dart';

class MyPeripheral extends MyObject implements Peripheral {
  final BlueZDevice device;

  @override
  final UUID uuid;

  MyPeripheral(this.device)
      : uuid = device.uuid.toUUID(),
        super(device);
}
