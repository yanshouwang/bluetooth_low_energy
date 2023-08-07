import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_object.dart';

class MyPeripheral extends MyObject implements Peripheral {
  MyPeripheral(super.hashCode);

  @override
  Future<UUID> getUUID() async {
    final value = await myPeripheralApi.getUUID();
    return UUID.fromString(value);
  }
}
