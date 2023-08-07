import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_object.dart';

class MyGattService extends MyObject implements GattService {
  MyGattService(super.hashCode);

  @override
  Future<UUID> getUUID() async {
    final value = await myGattServiceApi.getUUID();
    return UUID.fromString(value);
  }
}
