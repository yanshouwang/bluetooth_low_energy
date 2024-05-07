import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_peripheral.dart';

base class MyGATTDescriptor extends BaseGATTDescriptor {
  final MyPeripheral peripheral;
  final int handle;

  MyGATTDescriptor({
    required this.peripheral,
    required this.handle,
    required super.uuid,
  });

  @override
  int get hashCode => Object.hash(peripheral, handle);

  @override
  bool operator ==(Object other) {
    return other is MyGATTDescriptor &&
        other.peripheral == peripheral &&
        other.handle == handle;
  }
}

base class MyGATTCharacteristic extends BaseGATTCharacteristic {
  final MyPeripheral peripheral;
  final int handle;

  MyGATTCharacteristic({
    required this.peripheral,
    required this.handle,
    required super.uuid,
    required super.properties,
    required List<MyGATTDescriptor> descriptors,
  }) : super(descriptors: descriptors);

  @override
  List<MyGATTDescriptor> get descriptors =>
      super.descriptors.cast<MyGATTDescriptor>();

  @override
  int get hashCode => Object.hash(peripheral, handle);

  @override
  bool operator ==(Object other) {
    return other is MyGATTCharacteristic &&
        other.peripheral == peripheral &&
        other.handle == handle;
  }
}

base class MyGATTService extends BaseGATTService {
  final MyPeripheral peripheral;
  final int handle;

  MyGATTService({
    required this.peripheral,
    required this.handle,
    required super.uuid,
    required List<MyGATTCharacteristic> characteristics,
  }) : super(characteristics: characteristics);

  @override
  List<MyGATTCharacteristic> get characteristics =>
      super.characteristics.cast<MyGATTCharacteristic>();

  @override
  int get hashCode => Object.hash(peripheral, handle);

  @override
  bool operator ==(Object other) {
    return other is MyGATTService &&
        other.peripheral == peripheral &&
        other.handle == handle;
  }
}
