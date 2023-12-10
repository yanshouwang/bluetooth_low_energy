import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';
import 'my_gatt_descriptor2.dart';

class MyGattCharacteristic2 extends MyGattCharacteristic {
  final BlueZGattCharacteristic blueZCharacteristic;

  MyGattCharacteristic2(this.blueZCharacteristic)
      : super(
          uuid: blueZCharacteristic.myUUID,
          properties: blueZCharacteristic.myProperties,
          descriptors: blueZCharacteristic.myDescriptors,
        );

  @override
  List<MyGattDescriptor2> get descriptors =>
      super.descriptors.cast<MyGattDescriptor2>();

  @override
  int get hashCode => blueZCharacteristic.hashCode;

  @override
  bool operator ==(Object other) {
    return other is MyGattCharacteristic2 &&
        other.blueZCharacteristic == blueZCharacteristic;
  }
}
