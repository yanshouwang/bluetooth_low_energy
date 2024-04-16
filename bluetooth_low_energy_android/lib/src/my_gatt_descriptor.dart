import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_peripheral.dart';

base class MyGattDescriptor extends BaseGattDescriptor {
  final MyPeripheral peripheral;
  @override
  final int hashCode;

  MyGattDescriptor({
    required this.peripheral,
    required this.hashCode,
    required super.uuid,
  });

  @override
  bool operator ==(Object other) {
    return other is MyGattDescriptor &&
        other.peripheral == peripheral &&
        other.hashCode == hashCode;
  }
}
