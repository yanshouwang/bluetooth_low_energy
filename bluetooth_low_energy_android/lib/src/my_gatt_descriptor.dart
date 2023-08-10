import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';
import 'my_instance_manager.dart';
import 'my_object.dart';

class MyGattDescriptor extends MyObject implements GattDescriptor {
  @override
  final UUID uuid;

  MyGattDescriptor._(super.hashCode, this.uuid);

  factory MyGattDescriptor.fromArgs(MyGattDescriptorArgs args) {
    final hashCode = args.hashCode;
    final uuid = UUID.fromString(args.uuidValue);
    final descriptor = MyGattDescriptor._(hashCode, uuid);
    instanceManager.attach(descriptor);
    return descriptor;
  }
}
