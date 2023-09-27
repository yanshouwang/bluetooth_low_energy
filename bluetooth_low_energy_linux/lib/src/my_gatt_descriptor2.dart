import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';

class MyGattDescriptor2 extends MyGattDescriptor {
  final BlueZGattDescriptor descriptor;

  MyGattDescriptor2(this.descriptor)
      : super(
          myHashCode: descriptor.hashCode,
          uuid: descriptor.myUUID,
        );
}
