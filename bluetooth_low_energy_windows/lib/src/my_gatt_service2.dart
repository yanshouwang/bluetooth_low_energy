import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_gatt_characteristic2.dart';

class MyGattService2 extends MyGattService {
  final MyPeripheral peripheral;
  final int handle;

  MyGattService2({
    required this.peripheral,
    required this.handle,
    required super.uuid,
    required List<MyGattCharacteristic2> characteristics,
  }) : super(characteristics: characteristics);

  @override
  List<MyGattCharacteristic2> get characteristics =>
      super.characteristics.cast<MyGattCharacteristic2>();

  @override
  int get hashCode => Object.hash(peripheral, handle);

  @override
  bool operator ==(Object other) {
    return other is MyGattService2 &&
        other.peripheral == peripheral &&
        other.handle == handle;
  }
}
