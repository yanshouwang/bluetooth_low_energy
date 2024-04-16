import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_gatt_characteristic.dart';
import 'my_peripheral.dart';

base class MyGattService extends BaseGattService {
  final MyPeripheral peripheral;
  @override
  final int hashCode;

  MyGattService({
    required this.peripheral,
    required this.hashCode,
    required super.uuid,
    required List<MyGattCharacteristic> characteristics,
  }) : super(characteristics: characteristics);

  @override
  List<MyGattCharacteristic> get characteristics =>
      super.characteristics.cast<MyGattCharacteristic>();

  @override
  bool operator ==(Object other) {
    return other is MyGattService &&
        other.peripheral == peripheral &&
        other.hashCode == hashCode;
  }
}
