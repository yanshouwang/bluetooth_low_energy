import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_api.g.dart';

final class MyGATTDescriptor extends GATTDescriptor {
  final String uuidArgs;
  final int hashCodeArgs;

  MyGATTDescriptor({
    required this.uuidArgs,
    required this.hashCodeArgs,
    required super.uuid,
  });

  factory MyGATTDescriptor.fromArgs({
    required String uuidArgs,
    required MyGATTDescriptorArgs descriptorArgs,
  }) {
    return MyGATTDescriptor(
      uuidArgs: uuidArgs,
      hashCodeArgs: descriptorArgs.hashCodeArgs,
      uuid: UUID.fromString(descriptorArgs.uuidArgs),
    );
  }

  @override
  int get hashCode => Object.hash(uuidArgs, hashCodeArgs);

  @override
  bool operator ==(Object other) {
    return other is MyGATTDescriptor &&
        other.uuidArgs == uuidArgs &&
        other.hashCodeArgs == hashCodeArgs;
  }
}

final class MyGATTCharacteristic extends GATTCharacteristic {
  final String uuidArgs;
  final int hashCodeArgs;

  MyGATTCharacteristic({
    required this.uuidArgs,
    required this.hashCodeArgs,
    required super.uuid,
    required super.properties,
    required List<MyGATTDescriptor> descriptors,
  }) : super(
          descriptors: descriptors,
        );

  factory MyGATTCharacteristic.fromArgs({
    required String uuidArgs,
    required MyGATTCharacteristicArgs characteristicArgs,
  }) {
    return MyGATTCharacteristic(
      uuidArgs: uuidArgs,
      hashCodeArgs: characteristicArgs.hashCodeArgs,
      uuid: UUID.fromString(characteristicArgs.uuidArgs),
      properties: characteristicArgs.propertyNumbersArgs
          .cast<int>()
          .map((propertyNumberArgs) {
        final propertyArgs =
            MyGATTCharacteristicPropertyArgs.values[propertyNumberArgs];
        return propertyArgs.toProperty();
      }).toList(),
      descriptors: characteristicArgs.descriptorsArgs
          .cast<MyGATTDescriptorArgs>()
          .map((descriptorArgs) => MyGATTDescriptor.fromArgs(
                uuidArgs: uuidArgs,
                descriptorArgs: descriptorArgs,
              ))
          .toList(),
    );
  }

  @override
  List<MyGATTDescriptor> get descriptors =>
      super.descriptors.cast<MyGATTDescriptor>();

  @override
  int get hashCode => Object.hash(uuidArgs, hashCodeArgs);

  @override
  bool operator ==(Object other) {
    return other is MyGATTCharacteristic &&
        other.uuidArgs == uuidArgs &&
        other.hashCodeArgs == hashCodeArgs;
  }
}

final class MyGATTService extends GATTService {
  final String uuidArgs;
  final int hashCodeArgs;

  MyGATTService({
    required this.uuidArgs,
    required this.hashCodeArgs,
    required super.uuid,
    required super.isPrimary,
    required List<MyGATTService> includedServices,
    required List<MyGATTCharacteristic> characteristics,
  }) : super(
          includedServices: includedServices,
          characteristics: characteristics,
        );

  factory MyGATTService.fromArgs({
    required String uuidArgs,
    required MyGATTServiceArgs serviceArgs,
  }) {
    return MyGATTService(
      uuidArgs: uuidArgs,
      hashCodeArgs: serviceArgs.hashCodeArgs,
      uuid: UUID.fromString(serviceArgs.uuidArgs),
      isPrimary: serviceArgs.isPrimaryArgs,
      includedServices: serviceArgs.includedServicesArgs
          .cast<MyGATTServiceArgs>()
          .map((includedServiceArgs) => MyGATTService.fromArgs(
                uuidArgs: uuidArgs,
                serviceArgs: includedServiceArgs,
              ))
          .toList(),
      characteristics: serviceArgs.characteristicsArgs
          .cast<MyGATTCharacteristicArgs>()
          .map((characteristicArgs) => MyGATTCharacteristic.fromArgs(
                uuidArgs: uuidArgs,
                characteristicArgs: characteristicArgs,
              ))
          .toList(),
    );
  }

  @override
  List<MyGATTService> get includedServices =>
      super.includedServices.cast<MyGATTService>();

  @override
  List<MyGATTCharacteristic> get characteristics =>
      super.characteristics.cast<MyGATTCharacteristic>();

  @override
  int get hashCode => Object.hash(uuidArgs, hashCodeArgs);

  @override
  bool operator ==(Object other) {
    return other is MyGATTService &&
        other.uuidArgs == uuidArgs &&
        other.hashCodeArgs == hashCodeArgs;
  }
}

final class MyGATTReadRequest extends GATTReadRequest {
  final int hashCodeArgs;

  MyGATTReadRequest({
    required this.hashCodeArgs,
    required super.offset,
  });
}

final class MyGATTWriteRequest extends GATTWriteRequest {
  final int hashCodeArgs;

  MyGATTWriteRequest({
    required this.hashCodeArgs,
    required super.offset,
    required super.value,
  });
}
