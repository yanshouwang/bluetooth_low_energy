import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';
import 'my_gatt_characteristic.dart';
import 'my_object.dart';

class MyGattDescriptor extends MyObject implements GattDescriptor {
  final BlueZGattDescriptor descriptor;

  late final MyGattCharacteristic myCharacteristic;

  MyGattDescriptor(this.descriptor) : super(descriptor);

  @override
  UUID get uuid => descriptor.uuid.toUUID();
}
