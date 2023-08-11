import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';
import 'my_object.dart';

class MyGattService extends MyObject implements GattService {
  @override
  final UUID uuid;

  MyGattService(super.hashCode, this.uuid);

  factory MyGattService.fromBlueZ(BlueZGattService blueZService) {
    final hashCode = blueZService.hashCode;
    final uuid = blueZService.uuid.toUUID();
    return MyGattService(hashCode, uuid);
  }
}
