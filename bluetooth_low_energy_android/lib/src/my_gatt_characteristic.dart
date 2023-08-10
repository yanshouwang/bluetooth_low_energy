import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';
import 'my_instance_manager.dart';
import 'my_object.dart';

class MyGattCharacteristic extends MyObject implements GattCharacteristic {
  @override
  final UUID uuid;
  @override
  final List<GattCharacteristicProperty> properties;

  MyGattCharacteristic._(super.hashCode, this.uuid, this.properties);

  factory MyGattCharacteristic.fromArgs(MyGattCharacteristicArgs args) {
    final hashCode = args.hashCode;
    final uuid = UUID.fromString(args.uuidValue);
    final properties = args.propertyNumbers
        .whereType<int>()
        .map((propertyNumber) => propertyNumber.toGattCharacteristicProperty())
        .toList();
    final characteristic = MyGattCharacteristic._(hashCode, uuid, properties);
    instanceManager.attach(characteristic);
    return characteristic;
  }
}

extension on int {
  GattCharacteristicProperty toGattCharacteristicProperty() {
    final args = MyGattCharacteristicPropertyArgs.values[this];
    return GattCharacteristicProperty.values[args.index];
  }
}
