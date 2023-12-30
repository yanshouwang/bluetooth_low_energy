import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_peripheral2.dart';

class MyGattDescriptor2 extends MyGattDescriptor {
  final MyPeripheral2 peripheral;
  @override
  final int hashCode;

  MyGattDescriptor2({
    required this.peripheral,
    required this.hashCode,
    required super.uuid,
  });

  @override
  bool operator ==(Object other) {
    return other is MyGattDescriptor2 &&
        other.peripheral == peripheral &&
        other.hashCode == hashCode;
  }
}
