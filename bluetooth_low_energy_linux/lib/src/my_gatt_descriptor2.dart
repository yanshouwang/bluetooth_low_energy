import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';

class MyGattDescriptor2 extends MyGattDescriptor {
  final BlueZGattDescriptor blueZDescriptor;

  MyGattDescriptor2(this.blueZDescriptor)
      : super(
          uuid: blueZDescriptor.myUUID,
        );

  @override
  int get hashCode => blueZDescriptor.hashCode;

  @override
  bool operator ==(Object other) {
    return other is MyGattDescriptor2 &&
        other.blueZDescriptor == blueZDescriptor;
  }
}
