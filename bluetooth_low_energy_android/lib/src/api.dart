import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'api.g.dart';
import 'central_impl.dart';
import 'gatt_impl.dart';
import 'peripheral_impl.dart';

// ToObj
extension BluetoothLowEnergyStateArgsX on BluetoothLowEnergyStateArgs {
  BluetoothLowEnergyState toState() {
    switch (this) {
      case BluetoothLowEnergyStateArgs.unknown:
        return BluetoothLowEnergyState.unknown;
      case BluetoothLowEnergyStateArgs.unsupported:
        return BluetoothLowEnergyState.unsupported;
      case BluetoothLowEnergyStateArgs.unauthorized:
        return BluetoothLowEnergyState.unauthorized;
      case BluetoothLowEnergyStateArgs.off:
      case BluetoothLowEnergyStateArgs.turningOn:
        return BluetoothLowEnergyState.poweredOff;
      case BluetoothLowEnergyStateArgs.on:
      case BluetoothLowEnergyStateArgs.turningOff:
        return BluetoothLowEnergyState.poweredOn;
    }
  }
}

extension ConnectionStateArgsX on ConnectionStateArgs {
  ConnectionState toState() {
    switch (this) {
      case ConnectionStateArgs.disconnected:
      case ConnectionStateArgs.connecting:
        return ConnectionState.disconnected;
      case ConnectionStateArgs.connected:
      case ConnectionStateArgs.disconnecting:
        return ConnectionState.connected;
    }
  }
}

extension GATTCharacteristicPropertyArgsX on GATTCharacteristicPropertyArgs {
  GATTCharacteristicProperty toProperty() {
    return GATTCharacteristicProperty.values[index];
  }
}

extension ManufacturerSpecificDataArgsX on ManufacturerSpecificDataArgs {
  ManufacturerSpecificData toManufacturerSpecificData() {
    return ManufacturerSpecificData(id: idArgs, data: dataArgs);
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
          manufacturerSpecificDataArgs
              .cast<ManufacturerSpecificDataArgs>()
              .map((args) => args.toManufacturerSpecificData())
              .toList(),
    );
  }
}

extension PeripheralArgsX on PeripheralArgs {
  Peripheral toPeripheral() {
    return PeripheralImpl(address: addressArgs);
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
              .cast<GATTServiceImpl>()
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
    return CentralImpl(address: addressArgs);
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
  GATTStatusArgs toArgs() {
    switch (this) {
      case GATTError.readNotPermitted:
        return GATTStatusArgs.readNotPermitted;
      case GATTError.writeNotPermitted:
        return GATTStatusArgs.writeNotPermitted;
      case GATTError.insufficientAuthentication:
        return GATTStatusArgs.insufficientAuthentication;
      case GATTError.requestNotSupported:
        return GATTStatusArgs.requestNotSupported;
      case GATTError.invalidOffset:
        return GATTStatusArgs.invalidOffset;
      case GATTError.insufficientAuthorization:
        return GATTStatusArgs.insufficientAuthorization;
      case GATTError.invalidAttributeValueLength:
        return GATTStatusArgs.invalidAttributeLength;
      case GATTError.insufficientEncryption:
        return GATTStatusArgs.insufficientEncryption;
      default:
        return GATTStatusArgs.failure;
    }
  }
}

extension ManufacturerSpecificDataX on ManufacturerSpecificData {
  ManufacturerSpecificDataArgs toArgs() {
    return ManufacturerSpecificDataArgs(idArgs: id, dataArgs: data);
  }
}

extension AdvertisementX on Advertisement {
  AdvertiseDataArgs toAdvertiseDataArgs() {
    return AdvertiseDataArgs(
      serviceUUIDsArgs: serviceUUIDs.map((uuid) => uuid.toArgs()).toList(),
      serviceDataArgs: serviceData.map((uuid, data) {
        final uuidArgs = uuid.toArgs();
        final dataArgs = data;
        return MapEntry(uuidArgs, dataArgs);
      }),
      manufacturerSpecificDataArgs:
          manufacturerSpecificData.map((data) => data.toArgs()).toList(),
    );
  }

  AdvertiseDataArgs toScanResponseArgs() {
    return AdvertiseDataArgs(
      includeDeviceNameArgs: name != null,
      serviceUUIDsArgs: [],
      serviceDataArgs: {},
      manufacturerSpecificDataArgs: [],
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
      permissionNumbersArgs:
          impl.permissions.map((permission) {
            final permissionArgs = permission.toArgs();
            return permissionArgs.index;
          }).toList(),
    );
  }
}

extension GATTCharacteristicX on GATTCharacteristic {
  MutableGATTCharacteristicArgs toArgs() {
    final impl = this;
    if (impl is! MutableGATTCharacteristicImpl) throw TypeError();
    // Add CCC descriptor.
    final cccUUID = UUID.short(0x2902);
    final descriptorsArgs =
        impl.descriptors
            .where((descriptor) => descriptor.uuid != cccUUID)
            .map((descriptor) => descriptor.toArgs())
            .toList();
    final cccDescriptor = GATTDescriptor.mutable(
      uuid: cccUUID,
      permissions: [
        GATTCharacteristicPermission.read,
        GATTCharacteristicPermission.write,
      ],
    );
    final cccDescriptorArgs = cccDescriptor.toArgs();
    descriptorsArgs.add(cccDescriptorArgs);
    return MutableGATTCharacteristicArgs(
      hashCodeArgs: impl.hashCode,
      uuidArgs: impl.uuid.toArgs(),
      permissionNumbersArgs:
          impl.permissions.map((permission) {
            final permissionArgs = permission.toArgs();
            return permissionArgs.index;
          }).toList(),
      propertyNumbersArgs:
          impl.properties.map((property) {
            final propertyArgs = property.toArgs();
            return propertyArgs.index;
          }).toList(),
      descriptorsArgs: descriptorsArgs,
    );
  }
}

extension GATTServiceX on GATTService {
  MutableGATTServiceArgs toArgs() {
    final impl = this;
    if (this is! MutableGATTServiceImpl) throw TypeError();
    return MutableGATTServiceArgs(
      hashCodeArgs: impl.hashCode,
      uuidArgs: impl.uuid.toArgs(),
      isPrimaryArgs: impl.isPrimary,
      includedServicesArgs:
          impl.includedServices.map((service) => service.toArgs()).toList(),
      characteristicsArgs:
          impl.characteristics
              .map((characteristic) => characteristic.toArgs())
              .toList(),
    );
  }
}
