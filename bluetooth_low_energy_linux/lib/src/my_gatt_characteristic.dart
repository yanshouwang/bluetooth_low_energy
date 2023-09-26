import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';
import 'my_gatt_descriptor.dart';
import 'my_gatt_service.dart';
import 'my_object.dart';

class MyGattCharacteristic extends MyObject implements GattCharacteristic {
  final BlueZGattCharacteristic characteristic;

  @override
  final UUID uuid;
  @override
  final List<GattCharacteristicProperty> properties;
  @override
  final List<MyGattDescriptor> descriptors;

  late final MyGattService myService;

  MyGattCharacteristic(this.characteristic)
      : uuid = characteristic.uuid.toUUID(),
        properties = characteristic.properties,
        descriptors = characteristic.descriptors
            .map((descriptor) => MyGattDescriptor(descriptor))
            .toList(),
        super(characteristic);
}
