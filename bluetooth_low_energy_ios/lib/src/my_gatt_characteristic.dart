import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';
import 'my_gatt_service.dart';
import 'my_object.dart';

class MyGattCharacteristic extends MyObject implements GattCharacteristic {
  final MyGattService myService;
  @override
  final UUID uuid;
  @override
  final List<GattCharacteristicProperty> properties;

  MyGattCharacteristic(
    super.hashCode,
    this.myService,
    this.uuid,
    this.properties,
  );

  factory MyGattCharacteristic.fromMyArgs(
    MyGattService myService,
    MyGattCharacteristicArgs myArgs,
  ) {
    final hashCode = myArgs.key;
    final uuid = UUID.fromString(myArgs.uuidString);
    final properties =
        myArgs.myPropertyNumbers.whereType<int>().map((myPropertyNumber) {
      final myPropertyArgs =
          MyGattCharacteristicPropertyArgs.values[myPropertyNumber];
      return myPropertyArgs.toProperty();
    }).toList();
    return MyGattCharacteristic(hashCode, myService, uuid, properties);
  }
}

extension on MyGattCharacteristicPropertyArgs {
  GattCharacteristicProperty toProperty() {
    return GattCharacteristicProperty.values[index];
  }
}
