import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';
import 'my_gatt.dart';
import 'my_peripheral.dart';

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
    final serviceUUIDs = serviceUUIDsArgs
        .cast<String>()
        .map((args) => UUID.fromString(args))
        .toList();
    final serviceData = serviceDataArgs.cast<String, Uint8List>().map(
      (uuidArgs, dataArgs) {
        final uuid = UUID.fromString(uuidArgs);
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

extension MyPeripheralArgsX on MyPeripheralArgs {
  MyPeripheral toPeripheral() {
    final node =
        (addressArgs & 0xFFFFFFFFFFFF).toRadixString(16).padLeft(12, '0');
    final uuid = UUID.fromString('00000000-0000-0000-0000-$node');
    return MyPeripheral(
      addressArgs: addressArgs,
      uuid: uuid,
    );
  }
}

extension MyGATTDescriptorArgsX on MyGATTDescriptorArgs {
  MyGATTDescriptor toDescriptor() {
    final uuid = UUID.fromString(uuidArgs);
    return MyGATTDescriptor(
      handleArgs: handleArgs,
      uuid: uuid,
    );
  }
}

extension MyGATTCharacteristicArgsX on MyGATTCharacteristicArgs {
  MyGATTCharacteristic toCharacteristic() {
    final uuid = UUID.fromString(uuidArgs);
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
      handleArgs: handleArgs,
      uuid: uuid,
      properties: properties,
      descriptors: descriptors,
    );
  }
}

extension MyGATTServiceArgsX on MyGATTServiceArgs {
  MyGATTService toService() {
    final uuid = UUID.fromString(uuidArgs);
    final includedServices = includedServicesArgs
        .cast<MyGATTServiceArgs>()
        .map((args) => args.toService())
        .toList();
    final characteristics = characteristicsArgs
        .cast<MyGATTCharacteristicArgs>()
        .map((args) => args.toCharacteristic())
        .toList();
    return MyGATTService(
      handleArgs: handleArgs,
      uuid: uuid,
      isPrimary: isPrimaryArgs,
      includedServices: includedServices,
      characteristics: characteristics,
    );
  }
}

extension MyCentralArgsX on MyCentralArgs {
  Central toCentral() {
    final node =
        (addressArgs & 0xFFFFFFFFFFFF).toRadixString(16).padLeft(12, '0');
    final uuid = UUID.fromString('00000000-0000-0000-0000-$node');
    return Central(
      uuid: uuid,
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

extension GATTCharacteristicPermissionsX on List<GATTCharacteristicPermission> {
  MyGATTProtectionLevelArgs? toReadArgs() {
    return contains(GATTCharacteristicPermission.readEncrypted)
        ? MyGATTProtectionLevelArgs.entryptionRequired
        : contains(GATTCharacteristicPermission.read)
            ? MyGATTProtectionLevelArgs.plain
            : null;
  }

  MyGATTProtectionLevelArgs? toWriteArgs() {
    return contains(GATTCharacteristicPermission.writeEncrypted)
        ? MyGATTProtectionLevelArgs.entryptionRequired
        : contains(GATTCharacteristicPermission.write)
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
      readProtectionLevelArgs: permissions.toReadArgs(),
      writeProtectionLevelArgs: permissions.toWriteArgs(),
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
    final descriptorsArgs = descriptors
        .cast<MutableGATTDescriptor>()
        .map((descriptor) => descriptor.toArgs())
        .toList();
    return MyMutableGATTCharacteristicArgs(
      hashCodeArgs: hashCodeArgs,
      uuidArgs: uuidArgs,
      valueArgs: this is ImmutableGATTCharacteristic
          ? (this as ImmutableGATTCharacteristic).value
          : null,
      propertyNumbersArgs: propertyNumbersArgs,
      readProtectionLevelArgs: permissions.toReadArgs(),
      writeProtectionLevelArgs: permissions.toWriteArgs(),
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
      includedServicesArgs: includedServicesArgs,
      characteristicsArgs: characteristicsArgs,
    );
  }
}
