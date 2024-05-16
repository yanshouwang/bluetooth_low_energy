import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';
import 'my_gatt.dart';

// ToObject
extension MyBluetoothLowEnergyStateArgsX on MyBluetoothLowEnergyStateArgs {
  BluetoothLowEnergyState toState() {
    switch (this) {
      case MyBluetoothLowEnergyStateArgs.unknown:
      case MyBluetoothLowEnergyStateArgs.resetting:
        return BluetoothLowEnergyState.unknown;
      case MyBluetoothLowEnergyStateArgs.unsupported:
        return BluetoothLowEnergyState.unsupported;
      case MyBluetoothLowEnergyStateArgs.unauthorized:
        return BluetoothLowEnergyState.unauthorized;
      case MyBluetoothLowEnergyStateArgs.poweredOff:
        return BluetoothLowEnergyState.poweredOff;
      case MyBluetoothLowEnergyStateArgs.poweredOn:
        return BluetoothLowEnergyState.poweredOn;
    }
  }
}

extension MyConnectionStateArgsX on MyConnectionStateArgs {
  ConnectionState toState() {
    return ConnectionState.values[index];
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
    final serviceUUIDs =
        serviceUUIDsArgs.cast<String>().map((args) => args.toUUID()).toList();
    final serviceData = serviceDataArgs.cast<String, Uint8List>().map(
      (uuidArgs, dataArgs) {
        final uuid = uuidArgs.toUUID();
        return MapEntry(uuid, dataArgs);
      },
    );
    final manufacturerSpecificData =
        manufacturerSpecificDataArgs?.toManufacturerSpecificData();
    return Advertisement(
      name: nameArgs,
      serviceUUIDs: serviceUUIDs,
      serviceData: serviceData,
      manufacturerSpecificData: manufacturerSpecificData,
    );
  }
}

extension MyCentralArgsX on MyCentralArgs {
  Central toCentral() {
    final uuid = uuidArgs.toUUID();
    return Central(
      uuid: uuid,
    );
  }
}

extension MyPeripheralArgsX on MyPeripheralArgs {
  Peripheral toPeripheral() {
    final uuid = uuidArgs.toUUID();
    return Peripheral(
      uuid: uuid,
    );
  }
}

extension MyGATTDescriptorArgsX on MyGATTDescriptorArgs {
  MyGATTDescriptor toDescriptor() {
    final uuid = uuidArgs.toUUID();
    return MyGATTDescriptor(
      hashCodeArgs: hashCodeArgs,
      uuid: uuid,
    );
  }
}

extension MyGATTCharacteristicArgsX on MyGATTCharacteristicArgs {
  MyGATTCharacteristic toCharacteristic() {
    final uuid = uuidArgs.toUUID();
    final properties = propertyNumbersArgs.cast<int>().map(
      (args) {
        final propertyArgs = MyGATTCharacteristicPropertyArgs.values[args];
        return propertyArgs.toProperty();
      },
    ).toList();
    final descriptors = descriptorsArgs
        .cast<MyGATTDescriptorArgs>()
        .map((args) => args.toDescriptor())
        .toList();
    return MyGATTCharacteristic(
      hashCodeArgs: hashCodeArgs,
      uuid: uuid,
      properties: properties,
      descriptors: descriptors,
    );
  }
}

extension MyGATTServiceArgsX on MyGATTServiceArgs {
  MyGATTService toService() {
    final uuid = uuidArgs.toUUID();
    final includedServices = includedServicesArgs
        .cast<MyGATTServiceArgs>()
        .map((args) => args.toService())
        .toList();
    final characteristics = characteristicsArgs
        .cast<MyGATTCharacteristicArgs>()
        .map((args) => args.toCharacteristic())
        .toList();
    return MyGATTService(
      hashCodeArgs: hashCodeArgs,
      uuid: uuid,
      isPrimary: isPrimaryArgs,
      includedServices: includedServices,
      characteristics: characteristics,
    );
  }
}

extension StringX on String {
  UUID toUUID() {
    return UUID.fromString(this);
  }
}

// ToArgs
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

extension GATTCharacteristicWriteTypeX on GATTCharacteristicWriteType {
  MyGATTCharacteristicWriteTypeArgs toArgs() {
    return MyGATTCharacteristicWriteTypeArgs.values[index];
  }
}

extension GATTErrorX on GATTError {
  MyATTErrorArgs toArgs() {
    switch (this) {
      case GATTError.invalidHandle:
        return MyATTErrorArgs.invalidHandle;
      case GATTError.readNotPermitted:
        return MyATTErrorArgs.readNotPermitted;
      case GATTError.writeNotPermitted:
        return MyATTErrorArgs.writeNotPermitted;
      case GATTError.invalidPDU:
        return MyATTErrorArgs.invalidPDU;
      case GATTError.insufficientAuthentication:
        return MyATTErrorArgs.insufficientAuthentication;
      case GATTError.requestNotSupported:
        return MyATTErrorArgs.requestNotSupported;
      case GATTError.invalidOffset:
        return MyATTErrorArgs.invalidOffset;
      case GATTError.insufficientAuthorization:
        return MyATTErrorArgs.insufficientAuthorization;
      case GATTError.prepareQueueFull:
        return MyATTErrorArgs.prepareQueueFull;
      case GATTError.attributeNotFound:
        return MyATTErrorArgs.attributeNotFound;
      case GATTError.attributeNotLong:
        return MyATTErrorArgs.attributeNotLong;
      case GATTError.insufficientEncryptionKeySize:
        return MyATTErrorArgs.insufficientEncryptionKeySize;
      case GATTError.invalidAttributeValueLength:
        return MyATTErrorArgs.invalidAttributeValueLength;
      case GATTError.unlikelyError:
        return MyATTErrorArgs.unlikelyError;
      case GATTError.insufficientEncryption:
        return MyATTErrorArgs.insufficientEncryption;
      case GATTError.unsupportedGroupType:
        return MyATTErrorArgs.unsupportedGroupType;
      case GATTError.insufficientResources:
        return MyATTErrorArgs.insufficientResources;
    }
  }
}

extension ManufacturerSpecificDataX on ManufacturerSpecificData {
  MyManufacturerSpecificDataArgs toArgs() {
    final idArgs = id;
    final dataArgs = data;
    return MyManufacturerSpecificDataArgs(
      idArgs: idArgs,
      dataArgs: dataArgs,
    );
  }
}

extension AdvertisementX on Advertisement {
  MyAdvertisementArgs toArgs() {
    final serviceUUIDsArgs = serviceUUIDs.map((uuid) => uuid.toArgs()).toList();
    final serviceDataArgs = serviceData.map((uuid, data) {
      final uuidArgs = uuid.toArgs();
      return MapEntry(uuidArgs, data);
    });
    final manufacturerSpecificDataArgs = manufacturerSpecificData?.toArgs();
    return MyAdvertisementArgs(
      nameArgs: name,
      serviceUUIDsArgs: serviceUUIDsArgs,
      serviceDataArgs: serviceDataArgs,
      manufacturerSpecificDataArgs: manufacturerSpecificDataArgs,
    );
  }
}

extension MutableGATTDescriptorX on MutableGATTDescriptor {
  MyMutableGATTDescriptorArgs toArgs() {
    final uuidArgs = uuid.toArgs();
    return MyMutableGATTDescriptorArgs(
      hashCodeArgs: hashCode,
      uuidArgs: uuidArgs,
      valueArgs: this is ImmutableGATTDescriptor
          ? (this as ImmutableGATTDescriptor).value
          : null,
    );
  }
}

extension MutableGATTCharacteristicX on MutableGATTCharacteristic {
  MyMutableGATTCharacteristicArgs toArgs() {
    final hashCodeArgs = hashCode;
    final uuidArgs = uuid.toArgs();
    final propertyNumbersArgs = properties.map((property) {
      final propertyArgs = property.toArgs();
      return propertyArgs.index;
    }).toList();
    final permissionNumbersArgs = permissions.map((permission) {
      final permissionArgs = permission.toArgs();
      return permissionArgs.index;
    }).toList();
    final descriptorsArgs = descriptors
        .cast<MutableGATTDescriptor>()
        .map((descriptor) => descriptor.toArgs())
        .toList();
    return MyMutableGATTCharacteristicArgs(
      hashCodeArgs: hashCodeArgs,
      uuidArgs: uuidArgs,
      propertyNumbersArgs: propertyNumbersArgs,
      permissionNumbersArgs: permissionNumbersArgs,
      valueArgs: this is ImmutableGATTCharacteristic
          ? (this as ImmutableGATTCharacteristic).value
          : null,
      descriptorsArgs: descriptorsArgs,
    );
  }
}

extension GATTServiceX on GATTService {
  MyMutableGATTServiceArgs toArgs() {
    final hashCodeArgs = hashCode;
    final uuidArgs = uuid.toArgs();
    final includedServicesArgs =
        includedServices.map((service) => service.toArgs()).toList();
    final characteristicsArgs = characteristics
        .cast<MutableGATTCharacteristic>()
        .map((characteristic) => characteristic.toArgs())
        .toList();
    return MyMutableGATTServiceArgs(
      hashCodeArgs: hashCodeArgs,
      uuidArgs: uuidArgs,
      isPrimaryArgs: isPrimary,
      includedServices: includedServicesArgs,
      characteristicsArgs: characteristicsArgs,
    );
  }
}

extension UUIDX on UUID {
  String toArgs() {
    return toString().toLowerCase();
  }
}
