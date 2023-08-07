import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_object.dart';

class MyGattCharacteristic extends MyObject implements GattCharacteristic {
  MyGattCharacteristic(super.hashCode);

  @override
  Future<UUID> getUUID() async {
    final value = await myGattCharacteristicApi.getUUID();
    return UUID.fromString(value);
  }

  @override
  Future<List<GattCharacteristicProperty>> getProperties() async {
    final rawProperties = await myGattCharacteristicApi.getProperties();
    return rawProperties
        .whereType<int>()
        .map((rawProperty) => GattCharacteristicProperty.values[rawProperty])
        .toList();
  }
}
