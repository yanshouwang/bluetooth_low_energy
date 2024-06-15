import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_api.g.dart';

final class MyGATTDescriptor extends GATTDescriptor {
  final int addressArgs;
  final int handleArgs;

  MyGATTDescriptor({
    required this.addressArgs,
    required this.handleArgs,
    required super.uuid,
  });

  factory MyGATTDescriptor.fromArgs({
    required int addressArgs,
    required MyGATTDescriptorArgs descriptorArgs,
  }) {
    return MyGATTDescriptor(
      addressArgs: addressArgs,
      handleArgs: descriptorArgs.handleArgs,
      uuid: UUID.fromString(descriptorArgs.uuidArgs),
    );
  }

  @override
  int get hashCode => Object.hash(addressArgs, handleArgs);

  @override
  bool operator ==(Object other) {
    return other is MyGATTDescriptor &&
        other.addressArgs == addressArgs &&
        other.handleArgs == handleArgs;
  }
}

final class MyGATTCharacteristic extends GATTCharacteristic {
  final int addressArgs;
  final int handleArgs;

  MyGATTCharacteristic({
    required this.addressArgs,
    required this.handleArgs,
    required super.uuid,
    required super.properties,
    required List<MyGATTDescriptor> descriptors,
  }) : super(descriptors: descriptors);

  factory MyGATTCharacteristic.fromArgs({
    required int addressArgs,
    required MyGATTCharacteristicArgs characteristicArgs,
  }) {
    return MyGATTCharacteristic(
      addressArgs: addressArgs,
      handleArgs: characteristicArgs.handleArgs,
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
                addressArgs: addressArgs,
                descriptorArgs: descriptorArgs,
              ))
          .toList(),
    );
  }

  @override
  List<MyGATTDescriptor> get descriptors =>
      super.descriptors.cast<MyGATTDescriptor>();

  @override
  int get hashCode => Object.hash(addressArgs, handleArgs);

  @override
  bool operator ==(Object other) {
    return other is MyGATTCharacteristic &&
        other.addressArgs == addressArgs &&
        other.handleArgs == handleArgs;
  }
}

final class MyGATTService extends GATTService {
  final int addressArgs;
  final int handleArgs;

  MyGATTService({
    required this.addressArgs,
    required this.handleArgs,
    required super.uuid,
    required super.isPrimary,
    required List<MyGATTService> includedServices,
    required List<MyGATTCharacteristic> characteristics,
  }) : super(
          includedServices: includedServices,
          characteristics: characteristics,
        );

  factory MyGATTService.fromArgs({
    required int addressArgs,
    required MyGATTServiceArgs serviceArgs,
  }) {
    return MyGATTService(
      addressArgs: addressArgs,
      handleArgs: serviceArgs.handleArgs,
      uuid: UUID.fromString(serviceArgs.uuidArgs),
      isPrimary: serviceArgs.isPrimaryArgs,
      includedServices: serviceArgs.includedServicesArgs
          .cast<MyGATTServiceArgs>()
          .map((includedServiceArgs) => MyGATTService.fromArgs(
                addressArgs: addressArgs,
                serviceArgs: includedServiceArgs,
              ))
          .toList(),
      characteristics: serviceArgs.characteristicsArgs
          .cast<MyGATTCharacteristicArgs>()
          .map((characteristicArgs) => MyGATTCharacteristic.fromArgs(
                addressArgs: addressArgs,
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
  int get hashCode => Object.hash(addressArgs, handleArgs);

  @override
  bool operator ==(Object other) {
    return other is MyGATTService &&
        other.addressArgs == addressArgs &&
        other.handleArgs == handleArgs;
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
