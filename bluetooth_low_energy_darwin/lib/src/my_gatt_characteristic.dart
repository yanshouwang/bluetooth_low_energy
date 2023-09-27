import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_gatt_descriptor.dart';
import 'my_gatt_service.dart';
import 'my_object.dart';

class MyGattCharacteristic extends MyObject implements GattCharacteristic {
  @override
  final UUID uuid;
  @override
  final List<GattCharacteristicProperty> properties;
  @override
  final List<MyGattDescriptor> descriptors;

  late final MyGattService myService;

  MyGattCharacteristic(
    super.hashCode,
    this.uuid,
    this.properties,
    this.descriptors,
  );

  factory MyGattCharacteristic.fromMyArgs(MyGattCharacteristicArgs myArgs) {
    final hashCode = myArgs.myKey;
    final uuid = UUID.fromString(myArgs.myUUID);
    final properties = myArgs.myPropertyNumbers.cast<int>().map(
      (myPropertyNumber) {
        final myPropertyArgs =
            MyGattCharacteristicPropertyArgs.values[myPropertyNumber];
        return myPropertyArgs.toProperty();
      },
    ).toList();
    final descriptors = myArgs.myDescriptorArgses
        .cast<MyGattDescriptorArgs>()
        .map(
          (myDescriptorArgs) => MyGattDescriptor.fromMyArgs(myDescriptorArgs),
        )
        .toList();
    return MyGattCharacteristic(
      hashCode,
      uuid,
      properties,
      descriptors,
    );
  }
}
