import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_gatt_descriptor.dart';
import 'my_gatt_service.dart';
import 'my_object.dart';

class MyGattCharacteristic extends MyObject implements GattCharacteristic {
  @override
  final UUID uuid;
  @override
  final List<MyGattDescriptor> descriptors;
  @override
  final List<GattCharacteristicProperty> properties;

  late MyGattService myService;

  MyGattCharacteristic(
    super.hashCode,
    this.uuid,
    this.descriptors,
    this.properties,
  );

  factory MyGattCharacteristic.fromMyArgs(MyGattCharacteristicArgs myArgs) {
    final hashCode = myArgs.myKey;
    final uuid = UUID.fromString(myArgs.myUUID);
    final descriptors = myArgs.myDescriptorArgses
        .cast<MyGattDescriptorArgs>()
        .map(
          (myDescriptorArgs) => MyGattDescriptor.fromMyArgs(myDescriptorArgs),
        )
        .toList();
    final properties = myArgs.myPropertyNumbers.cast<int>().map(
      (myPropertyNumber) {
        final myPropertyArgs =
            MyGattCharacteristicPropertyArgs.values[myPropertyNumber];
        return myPropertyArgs.toProperty();
      },
    ).toList();
    return MyGattCharacteristic(
      hashCode,
      uuid,
      descriptors,
      properties,
    );
  }
  factory MyGattCharacteristic.fromMyCustomizedArgs(
    MyCustomizedGattCharacteristicArgs myArgs,
  ) {
    final hashCode = myArgs.myKey;
    final uuid = UUID.fromString(myArgs.myUUID);
    final descriptors = myArgs.myDescriptorArgses
        .cast<MyGattDescriptorArgs>()
        .map(
          (myDescriptorArgs) => MyGattDescriptor.fromMyArgs(myDescriptorArgs),
        )
        .toList();
    final properties = myArgs.myPropertyNumbers.cast<int>().map(
      (myPropertyNumber) {
        final myPropertyArgs =
            MyGattCharacteristicPropertyArgs.values[myPropertyNumber];
        return myPropertyArgs.toProperty();
      },
    ).toList();
    return MyGattCharacteristic(
      hashCode,
      uuid,
      descriptors,
      properties,
    );
  }
}
