import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';

// ToObj
extension MyBluetoothLowEnergyStateArgsX on MyBluetoothLowEnergyStateArgs {
  BluetoothLowEnergyState toState() {
    switch (this) {
      case MyBluetoothLowEnergyStateArgs.unknown:
        return BluetoothLowEnergyState.unknown;
      case MyBluetoothLowEnergyStateArgs.unsupported:
        return BluetoothLowEnergyState.unsupported;
      case MyBluetoothLowEnergyStateArgs.unauthorized:
        return BluetoothLowEnergyState.unauthorized;
      case MyBluetoothLowEnergyStateArgs.off:
        return BluetoothLowEnergyState.off;
      case MyBluetoothLowEnergyStateArgs.turningOn:
        return BluetoothLowEnergyState.turningOn;
      case MyBluetoothLowEnergyStateArgs.on:
        return BluetoothLowEnergyState.on;
      case MyBluetoothLowEnergyStateArgs.turningOff:
        return BluetoothLowEnergyState.turningOff;
    }
  }
}

extension MyConnectionStateArgsX on MyConnectionStateArgs {
  ConnectionState toState() {
    switch (this) {
      case MyConnectionStateArgs.disconnected:
      case MyConnectionStateArgs.connecting:
        return ConnectionState.disconnected;
      case MyConnectionStateArgs.connected:
      case MyConnectionStateArgs.disconnecting:
        return ConnectionState.connected;
    }
  }
}

extension MyGATTCharacteristicPropertyArgsX
    on MyGATTCharacteristicPropertyArgs {
  GATTCharacteristicProperty toProperty() {
    return GATTCharacteristicProperty.values[index];
  }
}

extension MyManufacturerSpecificDataArgsX on MyManufacturerSpecificDataArgs {
  ManufacturerSpecificData toManufacturerSpecificData() {
    return ManufacturerSpecificData(
      id: idArgs,
      data: dataArgs,
    );
  }
}

extension MyAdvertisementArgsX on MyAdvertisementArgs {
  Advertisement toAdvertisement() {
    return Advertisement(
      name: nameArgs,
      serviceUUIDs: serviceUUIDsArgs
          .cast<String>()
          .map((args) => UUID.fromString(args))
          .toList(),
      serviceData: serviceDataArgs.cast<String, Uint8List>().map(
        (uuidArgs, dataArgs) {
          final uuid = UUID.fromString(uuidArgs);
          return MapEntry(uuid, dataArgs);
        },
      ),
      manufacturerSpecificData: manufacturerSpecificDataArgs
          .cast<MyManufacturerSpecificDataArgs>()
          .map((args) => args.toManufacturerSpecificData())
          .toList(),
    );
  }
}

// ToArgs
extension UUIDX on UUID {
  String toArgs() {
    return toString();
  }
}

extension GATTCharacteristicWriteTypeX on GATTCharacteristicWriteType {
  MyGATTCharacteristicWriteTypeArgs toArgs() {
    return MyGATTCharacteristicWriteTypeArgs.values[index];
  }
}

extension GATTCharacteristicPropertyX on GATTCharacteristicProperty {
  MyGATTCharacteristicPropertyArgs toArgs() {
    return MyGATTCharacteristicPropertyArgs.values[index];
  }
}

extension GATTCharacteristicPermissionX on GATTCharacteristicPermission {
  MyGATTCharacteristicPermissionArgs toArgs() {
    return MyGATTCharacteristicPermissionArgs.values[index];
  }
}

extension GATTErrorX on GATTError {
  MyGATTStatusArgs toArgs() {
    switch (this) {
      case GATTError.readNotPermitted:
        return MyGATTStatusArgs.readNotPermitted;
      case GATTError.writeNotPermitted:
        return MyGATTStatusArgs.writeNotPermitted;
      case GATTError.insufficientAuthentication:
        return MyGATTStatusArgs.insufficientAuthentication;
      case GATTError.requestNotSupported:
        return MyGATTStatusArgs.requestNotSupported;
      case GATTError.invalidOffset:
        return MyGATTStatusArgs.invalidOffset;
      case GATTError.insufficientAuthorization:
        return MyGATTStatusArgs.insufficientAuthorization;
      case GATTError.invalidAttributeValueLength:
        return MyGATTStatusArgs.invalidAttributeLength;
      case GATTError.insufficientEncryption:
        return MyGATTStatusArgs.insufficientEncryption;
      default:
        return MyGATTStatusArgs.failure;
    }
  }
}

extension ManufacturerSpecificDataX on ManufacturerSpecificData {
  MyManufacturerSpecificDataArgs toArgs() {
    return MyManufacturerSpecificDataArgs(
      idArgs: id,
      dataArgs: data,
    );
  }
}

extension AdvertisementX on Advertisement {
  MyAdvertiseDataArgs toAdvertiseDataArgs() {
    if (name != null) {
      throw UnsupportedError('name is not supported on Android.');
    }
    return MyAdvertiseDataArgs(
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
}

extension MutableGATTDescriptorX on MutableGATTDescriptor {
  MyMutableGATTDescriptorArgs toArgs() {
    return MyMutableGATTDescriptorArgs(
      hashCodeArgs: hashCode,
      uuidArgs: uuid.toArgs(),
      permissionNumbersArgs: permissions.map((permission) {
        final permissionArgs = permission.toArgs();
        return permissionArgs.index;
      }).toList(),
    );
  }
}

extension MutableGATTCharacteristicX on MutableGATTCharacteristic {
  MyMutableGATTCharacteristicArgs toArgs() {
    // Add CCC descriptor.
    final cccUUID = UUID.short(0x2902);
    final descriptorsArgs = descriptors
        .cast<MutableGATTDescriptor>()
        .where((descriptor) => descriptor.uuid != cccUUID)
        .map((descriptor) => descriptor.toArgs())
        .toList();
    final cccDescriptor = MutableGATTDescriptor(
      uuid: cccUUID,
      permissions: [
        GATTCharacteristicPermission.read,
        GATTCharacteristicPermission.write,
      ],
    );
    final cccDescriptorArgs = cccDescriptor.toArgs();
    descriptorsArgs.add(cccDescriptorArgs);
    return MyMutableGATTCharacteristicArgs(
      hashCodeArgs: hashCode,
      uuidArgs: uuid.toArgs(),
      permissionNumbersArgs: permissions.map((permission) {
        final permissionArgs = permission.toArgs();
        return permissionArgs.index;
      }).toList(),
      propertyNumbersArgs: properties.map((property) {
        final propertyArgs = property.toArgs();
        return propertyArgs.index;
      }).toList(),
      descriptorsArgs: descriptorsArgs,
    );
  }
}

extension GATTServiceX on GATTService {
  MyMutableGATTServiceArgs toArgs() {
    return MyMutableGATTServiceArgs(
      hashCodeArgs: hashCode,
      uuidArgs: uuid.toArgs(),
      isPrimaryArgs: isPrimary,
      includedServicesArgs:
          includedServices.map((service) => service.toArgs()).toList(),
      characteristicsArgs: characteristics
          .cast<MutableGATTCharacteristic>()
          .map((characteristic) => characteristic.toArgs())
          .toList(),
    );
  }
}
