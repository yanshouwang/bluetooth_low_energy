import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';

// ToObject
extension MyBluetoothLowEnergyStateArgsX on MyBluetoothLowEnergyStateArgs {
  BluetoothLowEnergyState toState() {
    switch (this) {
      case MyBluetoothLowEnergyStateArgs.unknown:
        return BluetoothLowEnergyState.unknown;
      case MyBluetoothLowEnergyStateArgs.unsupported:
        return BluetoothLowEnergyState.unsupported;
      case MyBluetoothLowEnergyStateArgs.disabled:
        return BluetoothLowEnergyState.unsupported;
      case MyBluetoothLowEnergyStateArgs.off:
        return BluetoothLowEnergyState.poweredOff;
      case MyBluetoothLowEnergyStateArgs.on:
        return BluetoothLowEnergyState.poweredOn;
    }
  }
}

extension MyConnectionStateArgsX on MyConnectionStateArgs {
  ConnectionState toState() {
    switch (this) {
      case MyConnectionStateArgs.disconnected:
        return ConnectionState.disconnected;
      case MyConnectionStateArgs.connected:
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

extension GATTCharacteristicPermissionsX on List<GATTPermission> {
  MyGATTProtectionLevelArgs? toReadArgs() {
    return contains(GATTPermission.readEncrypted)
        ? MyGATTProtectionLevelArgs.entryptionRequired
        : contains(GATTPermission.read)
            ? MyGATTProtectionLevelArgs.plain
            : null;
  }

  MyGATTProtectionLevelArgs? toWriteArgs() {
    return contains(GATTPermission.writeEncrypted)
        ? MyGATTProtectionLevelArgs.entryptionRequired
        : contains(GATTPermission.write)
            ? MyGATTProtectionLevelArgs.plain
            : null;
  }
}

extension GATTErrorX on GATTError {
  MyGATTProtocolErrorArgs toArgs() {
    switch (this) {
      case GATTError.invalidHandle:
        return MyGATTProtocolErrorArgs.invalidHandle;
      case GATTError.readNotPermitted:
        return MyGATTProtocolErrorArgs.readNotPermitted;
      case GATTError.writeNotPermitted:
        return MyGATTProtocolErrorArgs.writeNotPermitted;
      case GATTError.invalidPDU:
        return MyGATTProtocolErrorArgs.invalidPDU;
      case GATTError.insufficientAuthentication:
        return MyGATTProtocolErrorArgs.insufficientAuthentication;
      case GATTError.requestNotSupported:
        return MyGATTProtocolErrorArgs.requestNotSupported;
      case GATTError.invalidOffset:
        return MyGATTProtocolErrorArgs.invalidOffset;
      case GATTError.insufficientAuthorization:
        return MyGATTProtocolErrorArgs.insufficientAuthorization;
      case GATTError.prepareQueueFull:
        return MyGATTProtocolErrorArgs.prepareQueueFull;
      case GATTError.attributeNotFound:
        return MyGATTProtocolErrorArgs.attributeNotFound;
      case GATTError.attributeNotLong:
        return MyGATTProtocolErrorArgs.attributeNotLong;
      case GATTError.insufficientEncryptionKeySize:
        return MyGATTProtocolErrorArgs.insufficientEncryptionKeySize;
      case GATTError.invalidAttributeValueLength:
        return MyGATTProtocolErrorArgs.invalidAttributeValueLength;
      case GATTError.unlikelyError:
        return MyGATTProtocolErrorArgs.unlikelyError;
      case GATTError.insufficientEncryption:
        return MyGATTProtocolErrorArgs.insufficientEncryption;
      case GATTError.unsupportedGroupType:
        return MyGATTProtocolErrorArgs.unsupportedGroupType;
      case GATTError.insufficientResources:
        return MyGATTProtocolErrorArgs.insufficientResources;
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
  MyAdvertisementArgs toArgs() {
    // When configuring the publisher object, you can't add restricted section types
    // (BluetoothLEAdvertisementPublisher.Advertisement.Flags and
    // BluetoothLEAdvertisementPublisher.Advertisement.LocalName). Trying to set those property values results in a
    // runtime exception. You can still set the manufacturer data section, or any other sections not defined by the list of
    // restrictions.
    // See: https://learn.microsoft.com/en-us/uwp/api/windows.devices.bluetooth.advertisement.bluetoothleadvertisementpublisher.advertisement?view=winrt-22621
    if (name != null) {
      throw UnsupportedError('name is not supported on Windows.');
    }
    return MyAdvertisementArgs(
      nameArgs: null,
      serviceUUIDsArgs: serviceUUIDs.map((uuid) => uuid.toArgs()).toList(),
      serviceDataArgs: serviceData.map((uuid, data) {
        final uuidArgs = uuid.toArgs();
        return MapEntry(uuidArgs, data);
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
      valueArgs: this is ImmutableGATTDescriptor
          ? (this as ImmutableGATTDescriptor).value
          : null,
      readProtectionLevelArgs: permissions.toReadArgs(),
      writeProtectionLevelArgs: permissions.toWriteArgs(),
    );
  }
}

extension MutableGATTCharacteristicX on MutableGATTCharacteristic {
  MyMutableGATTCharacteristicArgs toArgs() {
    return MyMutableGATTCharacteristicArgs(
      hashCodeArgs: hashCode,
      uuidArgs: uuid.toArgs(),
      valueArgs: this is ImmutableGATTCharacteristic
          ? (this as ImmutableGATTCharacteristic).value
          : null,
      propertyNumbersArgs: properties.map((property) {
        final propertyArgs = property.toArgs();
        return propertyArgs.index;
      }).toList(),
      readProtectionLevelArgs: permissions.toReadArgs(),
      writeProtectionLevelArgs: permissions.toWriteArgs(),
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
