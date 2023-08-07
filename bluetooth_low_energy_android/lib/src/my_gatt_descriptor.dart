import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_object.dart';

class MyGattDescriptor extends MyObject implements GattDescriptor {
  MyGattDescriptor(super.hashCode);

  @override
  Future<UUID> getUUID() async {
    final value = await myGattDescriptorApi.getUUID();
    return UUID.fromString(value);
  }
}
