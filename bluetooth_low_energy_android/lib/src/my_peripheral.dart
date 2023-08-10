import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';
import 'my_instance_manager.dart';
import 'my_object.dart';

class MyPeripheral extends MyObject implements Peripheral {
  @override
  final UUID uuid;

  MyPeripheral._(super.hashCode, this.uuid);

  factory MyPeripheral.fromArgs(MyPeripheralArgs args) {
    final hashCode = args.hashCode;
    final uuid = UUID.fromString(args.uuidValue);
    final peripheral = MyPeripheral._(hashCode, uuid);
    instanceManager.attach(peripheral);
    return peripheral;
  }
}
