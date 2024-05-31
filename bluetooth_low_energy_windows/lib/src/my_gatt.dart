import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';

final class MyGATTDescriptor extends GATTDescriptor {
  final int handleArgs;

  MyGATTDescriptor({
    required this.handleArgs,
    required super.uuid,
  });

  @override
  int get hashCode => handleArgs;

  @override
  bool operator ==(Object other) {
    return other is MyGATTDescriptor && other.handleArgs == handleArgs;
  }
}

final class MyGATTCharacteristic extends GATTCharacteristic {
  final int handleArgs;

  MyGATTCharacteristic({
    required this.handleArgs,
    required super.uuid,
    required super.properties,
    required List<MyGATTDescriptor> descriptors,
  }) : super(descriptors: descriptors);

  @override
  List<MyGATTDescriptor> get descriptors =>
      super.descriptors.cast<MyGATTDescriptor>();

  @override
  int get hashCode => handleArgs;

  @override
  bool operator ==(Object other) {
    return other is MyGATTCharacteristic && other.handleArgs == handleArgs;
  }
}

final class MyGATTService extends GATTService {
  final int handleArgs;

  MyGATTService({
    required this.handleArgs,
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
  int get hashCode => handleArgs;

  @override
  bool operator ==(Object other) {
    return other is MyGATTService && other.handleArgs == handleArgs;
  }
}

final class MyGATTReadRequest extends GATTReadRequest {
  final int idArgs;
  final int lengthArgs;

  MyGATTReadRequest({
    required this.idArgs,
    required super.offset,
    required this.lengthArgs,
  });
}

final class MyGATTWriteRequest extends GATTWriteRequest {
  final int idArgs;
  final MyGATTCharacteristicWriteTypeArgs typeArgs;

  MyGATTWriteRequest({
    required this.idArgs,
    required super.offset,
    required super.value,
    required this.typeArgs,
  });
}
