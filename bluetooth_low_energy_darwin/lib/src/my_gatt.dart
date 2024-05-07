import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

base class MyGATTDescriptor extends BaseGATTDescriptor {
  final Peripheral peripheral;
  @override
  final int hashCode;

  MyGATTDescriptor({
    required this.peripheral,
    required this.hashCode,
    required super.uuid,
  });

  @override
  bool operator ==(Object other) {
    return other is MyGATTDescriptor &&
        other.peripheral == peripheral &&
        other.hashCode == hashCode;
  }
}

base class MyGATTCharacteristic extends BaseGATTCharacteristic {
  final Peripheral peripheral;
  @override
  final int hashCode;

  MyGATTCharacteristic({
    required this.peripheral,
    required this.hashCode,
    required super.uuid,
    required super.properties,
    required List<MyGATTDescriptor> descriptors,
  }) : super(descriptors: descriptors);

  @override
  List<MyGATTDescriptor> get descriptors =>
      super.descriptors.cast<MyGATTDescriptor>();

  @override
  bool operator ==(Object other) {
    return other is MyGATTCharacteristic &&
        other.peripheral == peripheral &&
        other.hashCode == hashCode;
  }
}

base class MyGATTService extends BaseGATTService {
  final Peripheral peripheral;
  @override
  final int hashCode;

  MyGATTService({
    required this.peripheral,
    required this.hashCode,
    required super.uuid,
    required List<MyGATTCharacteristic> characteristics,
  }) : super(characteristics: characteristics);

  @override
  List<MyGATTCharacteristic> get characteristics =>
      super.characteristics.cast<MyGATTCharacteristic>();

  @override
  bool operator ==(Object other) {
    return other is MyGATTService &&
        other.peripheral == peripheral &&
        other.hashCode == hashCode;
  }
}
