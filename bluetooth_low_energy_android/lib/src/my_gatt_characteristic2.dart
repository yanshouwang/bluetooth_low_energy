import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_gatt_descriptor2.dart';
import 'my_gatt_service2.dart';

class MyGattCharacteristic2 extends MyGattCharacteristic {
  late final MyGattService2 service;
  @override
  final int hashCode;

  MyGattCharacteristic2({
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
    return other is MyGattCharacteristic2 && other.hashCode == hashCode;
  }
}
