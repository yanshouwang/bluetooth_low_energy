import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';
import 'my_gatt_characteristic.dart';
import 'my_object.dart';
import 'my_peripheral.dart';

class MyGattService extends MyObject implements GattService {
  final BlueZGattService service;

  @override
  final UUID uuid;
  @override
  final List<MyGattCharacteristic> characteristics;

  late final MyPeripheral myPeripheral;

  MyGattService(this.service)
      : uuid = service.uuid.toUUID(),
        characteristics = service.characteristics
            .map((characteristic) => MyGattCharacteristic(characteristic))
            .toList(),
        super(service);
}
