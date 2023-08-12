import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';
import 'my_object.dart';

class MyPeripheral extends MyObject implements Peripheral {
  @override
  final UUID uuid;

  MyPeripheral(super.hashCode, this.uuid);

  factory MyPeripheral.fromMyArgs(MyPeripheralArgs myArgs) {
    final hashCode = myArgs.key;
    final uuid = UUID.fromString(myArgs.uuidString);
    return MyPeripheral(hashCode, uuid);
  }
}
