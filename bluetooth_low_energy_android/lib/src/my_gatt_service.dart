import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';
import 'my_object.dart';
import 'my_peripheral.dart';

class MyGattService extends MyObject implements GattService {
  final MyPeripheral myPeripheral;
  @override
  final UUID uuid;

  MyGattService(super.hashCode, this.myPeripheral, this.uuid);

  factory MyGattService.fromMyArgs(
    MyPeripheral myPeripheral,
    MyGattServiceArgs myArgs,
  ) {
    final hashCode = myArgs.key;
    final uuid = UUID.fromString(myArgs.uuidString);
    return MyGattService(hashCode, myPeripheral, uuid);
  }
}
