import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_gatt_characteristic.dart';
import 'my_object.dart';
import 'my_peripheral.dart';

class MyGattService extends MyObject implements GattService {
  @override
  final UUID uuid;
  @override
  final List<MyGattCharacteristic> characteristics;

  late MyPeripheral myPeripheral;

  MyGattService(super.hashCode, this.uuid, this.characteristics);

  factory MyGattService.fromMyArgs(MyGattServiceArgs myArgs) {
    final hashCode = myArgs.myKey;
    final uuid = UUID.fromString(myArgs.myUUID);
    final characteristics = myArgs.myCharacteristicArgses
        .cast<MyGattCharacteristicArgs>()
        .map(
          (myCharacteristicArgs) =>
              MyGattCharacteristic.fromMyArgs(myCharacteristicArgs),
        )
        .toList();
    return MyGattService(hashCode, uuid, characteristics);
  }
}
