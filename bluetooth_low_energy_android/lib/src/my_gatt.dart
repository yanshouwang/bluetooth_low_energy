import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

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

base class MyGattCharacteristic extends BaseGattCharacteristic {
  final MyPeripheral peripheral;
  @override
  final int hashCode;

  MyGattCharacteristic({
    required this.peripheral,
    required this.hashCode,
    required super.uuid,
    required super.properties,
    required List<MyGattDescriptor> descriptors,
  }) : super(descriptors: descriptors);

  @override
  List<MyGattDescriptor> get descriptors =>
      super.descriptors.cast<MyGattDescriptor>();

  @override
  bool operator ==(Object other) {
    return other is MyGattCharacteristic &&
        other.peripheral == peripheral &&
        other.hashCode == hashCode;
  }
}

base class MyGattDescriptor extends BaseGattDescriptor {
  final MyPeripheral peripheral;
  @override
  final int hashCode;

  MyGattDescriptor({
    required this.peripheral,
    required this.hashCode,
    required super.uuid,
  });

  @override
  bool operator ==(Object other) {
    return other is MyGattDescriptor &&
        other.peripheral == peripheral &&
        other.hashCode == hashCode;
  }
}
