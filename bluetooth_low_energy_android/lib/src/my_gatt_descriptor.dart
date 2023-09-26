import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_gatt_characteristic.dart';
import 'my_object.dart';

class MyGattDescriptor extends MyObject implements GattDescriptor {
  @override
  final UUID uuid;

  late final MyGattCharacteristic myCharacteristic;

  MyGattDescriptor(super.hashCode, this.uuid);

  factory MyGattDescriptor.fromMyArgs(MyGattDescriptorArgs myArgs) {
    final hashCode = myArgs.myKey;
    final uuid = UUID.fromString(myArgs.myUUID);
    return MyGattDescriptor(hashCode, uuid);
  }
}
