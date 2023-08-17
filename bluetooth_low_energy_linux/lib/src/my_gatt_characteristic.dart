import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';
import 'my_object.dart';

class MyGattCharacteristic extends MyObject implements GattCharacteristic {
  final BlueZGattCharacteristic characteristic;

  MyGattCharacteristic(this.characteristic) : super(characteristic);

  @override
  UUID get uuid => characteristic.uuid.toUUID();

  @override
  List<GattCharacteristicProperty> get properties => characteristic.properties;
}
