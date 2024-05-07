import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_peripheral.dart';

base class MyGattDescriptor extends BaseGATTDescriptor {
  final MyPeripheral peripheral;
  final int handle;

  MyGattDescriptor({
    required this.peripheral,
    required this.handle,
    required super.uuid,
  });

  @override
  int get hashCode => Object.hash(peripheral, handle);

  @override
  bool operator ==(Object other) {
    return other is MyGattDescriptor &&
        other.peripheral == peripheral &&
        other.handle == handle;
  }
}

base class MyGattCharacteristic extends BaseGATTCharacteristic {
  final MyPeripheral peripheral;
  final int handle;

  MyGattCharacteristic({
    required this.peripheral,
    required this.handle,
    required super.uuid,
    required super.properties,
    required List<MyGattDescriptor> descriptors,
  }) : super(descriptors: descriptors);

  @override
  List<MyGattDescriptor> get descriptors =>
      super.descriptors.cast<MyGattDescriptor>();

  @override
  int get hashCode => Object.hash(peripheral, handle);

  @override
  bool operator ==(Object other) {
    return other is MyGattCharacteristic &&
        other.peripheral == peripheral &&
        other.handle == handle;
  }
}

base class MyGattService extends BaseGATTService {
  final MyPeripheral peripheral;
  final int handle;

  MyGattService({
    required this.peripheral,
    required this.handle,
    required super.uuid,
    required List<MyGattCharacteristic> characteristics,
  }) : super(characteristics: characteristics);

  @override
  List<MyGattCharacteristic> get characteristics =>
      super.characteristics.cast<MyGattCharacteristic>();

  @override
  int get hashCode => Object.hash(peripheral, handle);

  @override
  bool operator ==(Object other) {
    return other is MyGattService &&
        other.peripheral == peripheral &&
        other.handle == handle;
  }
}
