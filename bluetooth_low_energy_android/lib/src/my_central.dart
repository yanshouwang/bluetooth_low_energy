import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_object.dart';

class MyCentral extends MyObject implements Central {
  @override
  final UUID uuid;

  MyCentral(super.hashCode, this.uuid);

  factory MyCentral.fromMyArgs(MyCentralArgs myArgs) {
    final hashCode = myArgs.myKey;
    final uuid = UUID.fromString(myArgs.myUUID);
    return MyCentral(hashCode, uuid);
  }
}
