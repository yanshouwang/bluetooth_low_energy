import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

final class MyGATTDescriptor extends GATTDescriptor {
  final int hashCodeArgs;

  MyGATTDescriptor({
    required this.hashCodeArgs,
    required super.uuid,
  });

  @override
  int get hashCode => hashCodeArgs;

  @override
  bool operator ==(Object other) {
    return other is MyGATTDescriptor && other.hashCodeArgs == hashCodeArgs;
  }
}

final class MyGATTCharacteristic extends GATTCharacteristic {
  final int hashCodeArgs;

  MyGATTCharacteristic({
    required this.hashCodeArgs,
    required super.uuid,
    required super.properties,
    required List<MyGATTDescriptor> descriptors,
  }) : super(
          descriptors: descriptors,
        );

  @override
  List<MyGATTDescriptor> get descriptors =>
      super.descriptors.cast<MyGATTDescriptor>();

  @override
  int get hashCode => hashCodeArgs;

  @override
  bool operator ==(Object other) {
    return other is MyGATTCharacteristic && other.hashCodeArgs == hashCodeArgs;
  }
}

final class MyGATTService extends GATTService {
  final int hashCodeArgs;

  MyGATTService({
    required this.hashCodeArgs,
    required super.uuid,
    required super.isPrimary,
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
  int get hashCode => hashCodeArgs;

  @override
  bool operator ==(Object other) {
    return other is MyGATTService && other.hashCodeArgs == hashCodeArgs;
  }
}
