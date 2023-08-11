import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';
import 'my_object.dart';

class MyGattCharacteristic extends MyObject implements GattCharacteristic {
  @override
  final UUID uuid;
  @override
  final List<GattCharacteristicProperty> properties;

  MyGattCharacteristic(super.hashCode, this.uuid, this.properties);

  factory MyGattCharacteristic.fromBlueZ(
    BlueZGattCharacteristic blueZCharacteristic,
  ) {
    final hashCode = blueZCharacteristic.hashCode;
    final uuid = blueZCharacteristic.uuid.toUUID();
    final properties = blueZCharacteristic.properties;
    return MyGattCharacteristic(hashCode, uuid, properties);
  }
}
