import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

final class MyGATTDescriptor extends GATTDescriptor {
  final int address;
  final int handle;

  MyGATTDescriptor({
    required this.address,
    required this.handle,
    required super.uuid,
  });

  @override
  int get hashCode => Object.hash(address, handle);

  @override
  bool operator ==(Object other) {
    return other is MyGATTDescriptor &&
        other.address == address &&
        other.handle == handle;
  }
}

final class MyGATTCharacteristic extends GATTCharacteristic {
  final int address;
  final int handle;

  MyGATTCharacteristic({
    required this.address,
    required this.handle,
    required super.uuid,
    required super.properties,
    required List<MyGATTDescriptor> descriptors,
  }) : super(descriptors: descriptors);

  @override
  List<MyGATTDescriptor> get descriptors =>
      super.descriptors.cast<MyGATTDescriptor>();

  @override
  int get hashCode => Object.hash(address, handle);

  @override
  bool operator ==(Object other) {
    return other is MyGATTCharacteristic &&
        other.address == address &&
        other.handle == handle;
  }
}

final class MyGATTService extends GATTService {
  final int address;
  final int handle;

  MyGATTService({
    required this.address,
    required this.handle,
    required super.uuid,
    required List<MyGATTService> includedServices,
    required List<MyGATTCharacteristic> characteristics,
  }) : super(
          includedServices: includedServices,
          characteristics: characteristics,
        );

  @override
  List<MyGATTService> get includedServices =>
      super.includedServices.cast<MyGATTService>();

  @override
  List<MyGATTCharacteristic> get characteristics =>
      super.characteristics.cast<MyGATTCharacteristic>();

  @override
  int get hashCode => Object.hash(address, handle);

  @override
  bool operator ==(Object other) {
    return other is MyGATTService &&
        other.address == address &&
        other.handle == handle;
  }
}
