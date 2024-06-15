import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';

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
      manufacturerSpecificData:
          manufacturerSpecificDataArgs?.toManufacturerSpecificData() ?? [],
    );
  }
}

extension MyPeripheralArgsX on MyPeripheralArgs {
  Peripheral toPeripheral() {
    return Peripheral(
      uuid: UUID.fromString(uuidArgs),
    );
  }
}

extension MyCentralArgsX on MyCentralArgs {
  Central toCentral() {
    return Central(
      uuid: UUID.fromString(uuidArgs),
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

extension AdvertisementX on Advertisement {
  MyAdvertisementArgs toArgs() {
    // CoreBluetooth only support `CBAdvertisementDataLocalNameKey` and `CBAdvertisementDataServiceUUIDsKey`
    // see https://developer.apple.com/documentation/corebluetooth/cbperipheralmanager/1393252-startadvertising
    if (serviceData.isNotEmpty || manufacturerSpecificData.isNotEmpty) {
      throw UnsupportedError(
          'serviceData and manufacturerSpecificData is not supported on Darwin.');
    }
    return MyAdvertisementArgs(
      nameArgs: name,
      serviceUUIDsArgs: serviceUUIDs.map((uuid) => uuid.toArgs()).toList(),
      serviceDataArgs: {},
      manufacturerSpecificDataArgs: null,
    );
  }
}

extension MutableGATTDescriptorX on MutableGATTDescriptor {
  MyMutableGATTDescriptorArgs toArgs() {
    return MyMutableGATTDescriptorArgs(
      hashCodeArgs: hashCode,
      uuidArgs: uuid.toArgs(),
      valueArgs: this is ImmutableGATTDescriptor
          ? (this as ImmutableGATTDescriptor).value
          : null,
    );
  }
}

extension MutableGATTCharacteristicX on MutableGATTCharacteristic {
  MyMutableGATTCharacteristicArgs toArgs() {
    return MyMutableGATTCharacteristicArgs(
      hashCodeArgs: hashCode,
      uuidArgs: uuid.toArgs(),
      propertyNumbersArgs: properties.map((property) {
        final propertyArgs = property.toArgs();
        return propertyArgs.index;
      }).toList(),
      permissionNumbersArgs: permissions.map((permission) {
        final permissionArgs = permission.toArgs();
        return permissionArgs.index;
      }).toList(),
      valueArgs: this is ImmutableGATTCharacteristic
          ? (this as ImmutableGATTCharacteristic).value
          : null,
      descriptorsArgs: descriptors
          .cast<MutableGATTDescriptor>()
          .map((descriptor) => descriptor.toArgs())
          .toList(),
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
