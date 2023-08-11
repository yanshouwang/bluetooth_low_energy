import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';
import 'my_object.dart';

class MyGattDescriptor extends MyObject implements GattDescriptor {
  @override
  final UUID uuid;

  MyGattDescriptor(super.hashCode, this.uuid);

  factory MyGattDescriptor.fromBlueZ(BlueZGattDescriptor blueZDescriptor) {
    final hashCode = blueZDescriptor.hashCode;
    final uuid = blueZDescriptor.uuid.toUUID();
    return MyGattDescriptor(hashCode, uuid);
  }
}
