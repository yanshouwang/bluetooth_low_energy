import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'pigeon.dart';

final class GATTDescriptorImpl extends GATTDescriptor {
  final String uuidArgs;
  final int hashCodeArgs;

  GATTDescriptorImpl({
    required super.uuid,
    required this.uuidArgs,
    required this.hashCodeArgs,
  });

  factory GATTDescriptorImpl.fromArgs({
    required String uuidArgs,
    required GATTDescriptorArgs descriptorArgs,
  }) {
    return GATTDescriptorImpl(
      uuid: UUID.fromString(descriptorArgs.uuidArgs),
      uuidArgs: uuidArgs,
      hashCodeArgs: descriptorArgs.hashCodeArgs,
    );
  }

  @override
  int get hashCode => Object.hash(uuidArgs, hashCodeArgs);

  @override
  bool operator ==(Object other) {
    return other is GATTDescriptorImpl &&
        other.uuidArgs == uuidArgs &&
        other.hashCodeArgs == hashCodeArgs;
  }
}

final class GATTCharacteristicImpl extends GATTCharacteristic {
  final String uuidArgs;
  final int hashCodeArgs;

  GATTCharacteristicImpl({
    required super.uuid,
    required super.properties,
    required super.descriptors,
    required this.uuidArgs,
    required this.hashCodeArgs,
  });

  factory GATTCharacteristicImpl.fromArgs({
    required String uuidArgs,
    required GATTCharacteristicArgs characteristicArgs,
  }) {
    return GATTCharacteristicImpl(
      uuid: UUID.fromString(characteristicArgs.uuidArgs),
      properties: characteristicArgs.propertyNumbersArgs
          .cast<int>()
          .map((propertyNumberArgs) {
        final propertyArgs =
            GATTCharacteristicPropertyArgs.values[propertyNumberArgs];
        return propertyArgs.toProperty();
      }).toList(),
      descriptors: characteristicArgs.descriptorsArgs
          .cast<GATTDescriptorArgs>()
          .map((descriptorArgs) => GATTDescriptorImpl.fromArgs(
                uuidArgs: uuidArgs,
                descriptorArgs: descriptorArgs,
              ))
          .toList(),
      uuidArgs: uuidArgs,
      hashCodeArgs: characteristicArgs.hashCodeArgs,
    );
  }

  @override
  List<GATTDescriptorImpl> get descriptors =>
      super.descriptors.cast<GATTDescriptorImpl>();

  @override
  int get hashCode => Object.hash(uuidArgs, hashCodeArgs);

  @override
  bool operator ==(Object other) {
    return other is GATTCharacteristicImpl &&
        other.uuidArgs == uuidArgs &&
        other.hashCodeArgs == hashCodeArgs;
  }
}

final class GATTServiceImpl extends GATTService {
  final String uuidArgs;
  final int hashCodeArgs;

  GATTServiceImpl({
    required super.uuid,
    required super.isPrimary,
    required super.includedServices,
    required super.characteristics,
    required this.uuidArgs,
    required this.hashCodeArgs,
  });

  factory GATTServiceImpl.fromArgs({
    required String uuidArgs,
    required GATTServiceArgs serviceArgs,
  }) {
    return GATTServiceImpl(
      uuid: UUID.fromString(serviceArgs.uuidArgs),
      isPrimary: serviceArgs.isPrimaryArgs,
      includedServices: serviceArgs.includedServicesArgs
          .cast<GATTServiceArgs>()
          .map((includedServiceArgs) => GATTServiceImpl.fromArgs(
                uuidArgs: uuidArgs,
                serviceArgs: includedServiceArgs,
              ))
          .toList(),
      characteristics: serviceArgs.characteristicsArgs
          .cast<GATTCharacteristicArgs>()
          .map((characteristicArgs) => GATTCharacteristicImpl.fromArgs(
                uuidArgs: uuidArgs,
                characteristicArgs: characteristicArgs,
              ))
          .toList(),
      uuidArgs: uuidArgs,
      hashCodeArgs: serviceArgs.hashCodeArgs,
    );
  }

  @override
  List<GATTServiceImpl> get includedServices =>
      super.includedServices.cast<GATTServiceImpl>();

  @override
  List<GATTCharacteristicImpl> get characteristics =>
      super.characteristics.cast<GATTCharacteristicImpl>();

  @override
  int get hashCode => Object.hash(uuidArgs, hashCodeArgs);

  @override
  bool operator ==(Object other) {
    return other is GATTServiceImpl &&
        other.uuidArgs == uuidArgs &&
        other.hashCodeArgs == hashCodeArgs;
  }
}

final class GATTReadRequestImpl extends GATTReadRequest {
  final int hashCodeArgs;

  GATTReadRequestImpl({
    required this.hashCodeArgs,
    required super.offset,
  });
}

final class GATTWriteRequestImpl extends GATTWriteRequest {
  final int hashCodeArgs;

  GATTWriteRequestImpl({
    required this.hashCodeArgs,
    required super.offset,
    required super.value,
  });
}
