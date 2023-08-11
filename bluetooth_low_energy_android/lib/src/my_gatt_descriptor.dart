import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';
import 'my_gatt_characteristic.dart';
import 'my_object.dart';

class MyGattDescriptor extends MyObject implements GattDescriptor {
  final MyGattCharacteristic myCharacteristic;
  @override
  final UUID uuid;

  MyGattDescriptor(super.hashCode, this.myCharacteristic, this.uuid);

  factory MyGattDescriptor.fromMyArgs(
    MyGattCharacteristic myCharacteristic,
    MyGattDescriptorArgs myArgs,
  ) {
    final hashCode = myArgs.key;
    final uuid = UUID.fromString(myArgs.uuidString);
    return MyGattDescriptor(hashCode, myCharacteristic, uuid);
  }
}
