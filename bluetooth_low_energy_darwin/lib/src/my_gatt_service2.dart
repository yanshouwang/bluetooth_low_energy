import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_gatt_characteristic2.dart';

class MyGattService2 extends MyGattService {
  final MyPeripheral peripheral;
  @override
  final int hashCode;

  MyGattService2({
    required this.peripheral,
    required this.hashCode,
    required super.uuid,
    required List<MyGattCharacteristic2> characteristics,
  }) : super(characteristics: characteristics);

  @override
  List<MyGattCharacteristic2> get characteristics =>
      super.characteristics.cast<MyGattCharacteristic2>();

  @override
  bool operator ==(Object other) {
    return other is MyGattService2 &&
        other.peripheral == peripheral &&
        other.hashCode == hashCode;
  }
}
