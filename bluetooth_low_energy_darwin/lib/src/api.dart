import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'api.g.dart';
import 'central_impl.dart';
import 'gatt_impl.dart';
import 'peripheral_impl.dart';

// ToObject
extension Uint8ListX on Uint8List {
  List<ManufacturerSpecificData> toManufacturerSpecificData() {
    if (length > 2) {
      return [
        ManufacturerSpecificData(
          id: ByteData.view(
            buffer,
            offsetInBytes,
            length,
          ).getUint16(0, Endian.host),
          data: sublist(2),
        ),
      ];
    } else {
      return [];
    }
  }
}

extension BluetoothLowEnergyStateArgsX on BluetoothLowEnergyStateArgs {
  BluetoothLowEnergyState toState() {
    switch (this) {
      case BluetoothLowEnergyStateArgs.unknown:
      case BluetoothLowEnergyStateArgs.resetting:
        return BluetoothLowEnergyState.unknown;
      case BluetoothLowEnergyStateArgs.unsupported:
        return BluetoothLowEnergyState.unsupported;
      case BluetoothLowEnergyStateArgs.unauthorized:
        return BluetoothLowEnergyState.unauthorized;
      case BluetoothLowEnergyStateArgs.poweredOff:
        return BluetoothLowEnergyState.poweredOff;
      case BluetoothLowEnergyStateArgs.poweredOn:
        return BluetoothLowEnergyState.poweredOn;
    }
  }
}

extension ConnectionStateArgsX on ConnectionStateArgs {
  ConnectionState toState() {
    return ConnectionState.values[index];
  }
}

extension GATTCharacteristicPropertyArgsX on GATTCharacteristicPropertyArgs {
  GATTCharacteristicProperty toProperty() {
    return GATTCharacteristicProperty.values[index];
  }
}

extension AdvertisementArgsX on AdvertisementArgs {
  Advertisement toAdvertisement() {
    return Advertisement(
      name: nameArgs,
      serviceUUIDs:
          serviceUUIDsArgs
              .cast<String>()
              .map((args) => UUID.fromString(args))
              .toList(),
      serviceData: serviceDataArgs.cast<String, Uint8List>().map((
        uuidArgs,
        dataArgs,
      ) {
        final uuid = UUID.fromString(uuidArgs);
        return MapEntry(uuid, dataArgs);
      }),
      manufacturerSpecificData:
          manufacturerSpecificDataArgs?.toManufacturerSpecificData() ?? [],
    );
  }
}

extension PeripheralArgsX on PeripheralArgs {
  Peripheral toPeripheral() {
    return PeripheralImpl(uuid: UUID.fromString(uuidArgs));
  }
}

extension GATTDescriptorArgsX on GATTDescriptorArgs {
  GATTDescriptor toDescriptor() {
    return GATTDescriptorImpl(
      hashCode: hashCodeArgs,
      uuid: UUID.fromString(uuidArgs),
    );
  }
}

extension GATTCharacteristicArgsX on GATTCharacteristicArgs {
  GATTCharacteristic toCharacteristic() {
    return GATTCharacteristicImpl(
      hashCode: hashCodeArgs,
      uuid: UUID.fromString(uuidArgs),
      properties:
          propertyNumbersArgs.cast<int>().map((args) {
            final propertyArgs = GATTCharacteristicPropertyArgs.values[args];
            return propertyArgs.toProperty();
          }).toList(),
      descriptors:
          descriptorsArgs
              .cast<GATTDescriptorArgs>()
              .map((args) => args.toDescriptor())
              .toList(),
    );
  }
}

extension GATTServiceArgsX on GATTServiceArgs {
  GATTService toService() {
    return GATTServiceImpl(
      hashCode: hashCodeArgs,
      uuid: UUID.fromString(uuidArgs),
      isPrimary: isPrimaryArgs,
      includedServices:
          includedServicesArgs
              .cast<GATTServiceArgs>()
              .map((args) => args.toService())
              .toList(),
      characteristics:
          characteristicsArgs
              .cast<GATTCharacteristicArgs>()
              .map((args) => args.toCharacteristic())
              .toList(),
    );
  }
}

extension CentralArgsX on CentralArgs {
  Central toCentral() {
    return CentralImpl(uuid: UUID.fromString(uuidArgs));
  }
}

// ToArgs
extension UUIDX on UUID {
  String toArgs() {
    return toString();
  }
}

extension GATTCharacteristicWriteTypeX on GATTCharacteristicWriteType {
  GATTCharacteristicWriteTypeArgs toArgs() {
    return GATTCharacteristicWriteTypeArgs.values[index];
  }
}

extension GATTCharacteristicPropertyX on GATTCharacteristicProperty {
  GATTCharacteristicPropertyArgs toArgs() {
    return GATTCharacteristicPropertyArgs.values[index];
  }
}

extension GATTCharacteristicPermissionX on GATTCharacteristicPermission {
  GATTCharacteristicPermissionArgs toArgs() {
    return GATTCharacteristicPermissionArgs.values[index];
  }
}

extension GATTErrorX on GATTError {
  ATTErrorArgs toArgs() {
    switch (this) {
      case GATTError.invalidHandle:
        return ATTErrorArgs.invalidHandle;
      case GATTError.readNotPermitted:
        return ATTErrorArgs.readNotPermitted;
      case GATTError.writeNotPermitted:
        return ATTErrorArgs.writeNotPermitted;
      case GATTError.invalidPDU:
        return ATTErrorArgs.invalidPDU;
      case GATTError.insufficientAuthentication:
        return ATTErrorArgs.insufficientAuthentication;
      case GATTError.requestNotSupported:
        return ATTErrorArgs.requestNotSupported;
      case GATTError.invalidOffset:
        return ATTErrorArgs.invalidOffset;
      case GATTError.insufficientAuthorization:
        return ATTErrorArgs.insufficientAuthorization;
      case GATTError.prepareQueueFull:
        return ATTErrorArgs.prepareQueueFull;
      case GATTError.attributeNotFound:
        return ATTErrorArgs.attributeNotFound;
      case GATTError.attributeNotLong:
        return ATTErrorArgs.attributeNotLong;
      case GATTError.insufficientEncryptionKeySize:
        return ATTErrorArgs.insufficientEncryptionKeySize;
      case GATTError.invalidAttributeValueLength:
        return ATTErrorArgs.invalidAttributeValueLength;
      case GATTError.unlikelyError:
        return ATTErrorArgs.unlikelyError;
      case GATTError.insufficientEncryption:
        return ATTErrorArgs.insufficientEncryption;
      case GATTError.unsupportedGroupType:
        return ATTErrorArgs.unsupportedGroupType;
      case GATTError.insufficientResources:
        return ATTErrorArgs.insufficientResources;
    }
  }
}

extension AdvertisementX on Advertisement {
  AdvertisementArgs toArgs() {
    // CoreBluetooth only support `CBAdvertisementDataLocalNameKey` and `CBAdvertisementDataServiceUUIDsKey`
    // see https://developer.apple.com/documentation/corebluetooth/cbperipheralmanager/1393252-startadvertising
    if (serviceData.isNotEmpty || manufacturerSpecificData.isNotEmpty) {
      throw UnsupportedError(
        'serviceData and manufacturerSpecificData is not supported on Darwin.',
      );
    }
    return AdvertisementArgs(
      nameArgs: name,
      serviceUUIDsArgs: serviceUUIDs.map((uuid) => uuid.toArgs()).toList(),
      serviceDataArgs: {},
      manufacturerSpecificDataArgs: null,
    );
  }
}

extension GATTDescriptorX on GATTDescriptor {
  MutableGATTDescriptorArgs toArgs() {
    final impl = this;
    if (impl is! MutableGATTDescriptorImpl) throw TypeError();
    return MutableGATTDescriptorArgs(
      hashCodeArgs: impl.hashCode,
      uuidArgs: impl.uuid.toArgs(),
      valueArgs: impl is ImmutableGATTDescriptorImpl ? impl.value : null,
    );
  }
}

extension GATTCharacteristicX on GATTCharacteristic {
  MutableGATTCharacteristicArgs toArgs() {
    final impl = this;
    if (impl is! MutableGATTCharacteristicImpl) throw TypeError();
    return MutableGATTCharacteristicArgs(
      hashCodeArgs: impl.hashCode,
      uuidArgs: impl.uuid.toArgs(),
      propertyNumbersArgs:
          impl.properties.map((property) {
            final propertyArgs = property.toArgs();
            return propertyArgs.index;
          }).toList(),
      permissionNumbersArgs:
          impl.permissions.map((permission) {
            final permissionArgs = permission.toArgs();
            return permissionArgs.index;
          }).toList(),
      valueArgs: impl is ImmutableGATTCharacteristicImpl ? impl.value : null,
      descriptorsArgs:
          impl.descriptors
              .cast<MutableGATTDescriptorImpl>()
              .map((descriptor) => descriptor.toArgs())
              .toList(),
    );
  }
}

extension GATTServiceX on GATTService {
  MutableGATTServiceArgs toArgs() {
    final impl = this;
    if (impl is! MutableGATTServiceImpl) throw TypeError();
    return MutableGATTServiceArgs(
      hashCodeArgs: impl.hashCode,
      uuidArgs: impl.uuid.toArgs(),
      isPrimaryArgs: impl.isPrimary,
      includedServicesArgs:
          impl.includedServices.map((service) => service.toArgs()).toList(),
      characteristicsArgs:
          impl.characteristics
              .cast<MutableGATTCharacteristicImpl>()
              .map((characteristic) => characteristic.toArgs())
              .toList(),
    );
  }
}
