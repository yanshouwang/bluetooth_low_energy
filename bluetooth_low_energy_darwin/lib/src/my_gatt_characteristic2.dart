import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_gatt_descriptor2.dart';

class MyGattCharacteristic2 extends MyGattCharacteristic {
  final MyPeripheral peripheral;
  @override
  final int hashCode;

  MyGattCharacteristic2({
    required this.peripheral,
    required this.hashCode,
    required super.uuid,
    required super.properties,
    required List<MyGattDescriptor2> descriptors,
  }) : super(descriptors: descriptors);

  @override
  List<MyGattDescriptor2> get descriptors =>
      super.descriptors.cast<MyGattDescriptor2>();

  @override
  bool operator ==(Object other) {
    return other is MyGattCharacteristic2 &&
        other.peripheral == peripheral &&
        other.hashCode == hashCode;
  }
}
