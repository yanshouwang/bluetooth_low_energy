import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';
import 'my_instance_manager.dart';
import 'my_object.dart';

class MyGattService extends MyObject implements GattService {
  @override
  final UUID uuid;

  MyGattService._(super.hashCode, this.uuid);

  factory MyGattService.fromArgs(MyGattServiceArgs args) {
    final hashCode = args.hashCode;
    final uuid = UUID.fromString(args.uuidValue);
    final service = MyGattService._(hashCode, uuid);
    instanceManager.attach(service);
    return service;
  }
}
