import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_gatt_characteristic2.dart';

class MyGattDescriptor2 extends MyGattDescriptor {
  late final MyGattCharacteristic2 characteristic;
  @override
  final int hashCode;

  MyGattDescriptor2({
    required this.hashCode,
    required super.uuid,
  });

  @override
  bool operator ==(Object other) {
    return other is MyGattDescriptor2 && other.hashCode == hashCode;
  }
}
