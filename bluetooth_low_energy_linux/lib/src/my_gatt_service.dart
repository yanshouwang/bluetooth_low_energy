import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';
import 'my_object.dart';

class MyGattService extends MyObject implements GattService {
  final BlueZGattService service;

  MyGattService(this.service) : super(service);

  @override
  UUID get uuid => service.uuid.toUUID();
}
