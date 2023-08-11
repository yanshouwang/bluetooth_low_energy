import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';
import 'my_object.dart';

class MyPeripheral extends MyObject implements Peripheral {
  @override
  final UUID uuid;

  MyPeripheral(super.hashCode, this.uuid);

  factory MyPeripheral.fromBlueZ(BlueZDevice blueZDevice) {
    final hashCode = blueZDevice.hashCode;
    final uuid = blueZDevice.uuid.toUUID();
    return MyPeripheral(hashCode, uuid);
  }
}
