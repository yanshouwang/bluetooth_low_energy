import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';
import 'my_gatt_characteristic2.dart';

class MyGattService2 extends MyGattService {
  final BlueZGattService blueZService;

  MyGattService2(this.blueZService)
      : super(
          uuid: blueZService.myUUID,
          characteristics: blueZService.myCharacteristics,
        );

  @override
  List<MyGattCharacteristic2> get characteristics =>
      super.characteristics.cast<MyGattCharacteristic2>();

  @override
  int get hashCode => blueZService.hashCode;

  @override
  bool operator ==(Object other) {
    return other is MyGattService2 && other.blueZService == blueZService;
  }
}
