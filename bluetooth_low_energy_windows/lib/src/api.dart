import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'api.g.dart';
import 'central_impl.dart';
import 'gatt_impl.dart';
import 'peripheral_impl.dart';

// ToObject
extension BluetoothLowEnergyStateArgsX on BluetoothLowEnergyStateArgs {
  BluetoothLowEnergyState toState() {
    switch (this) {
      case BluetoothLowEnergyStateArgs.unknown:
        return BluetoothLowEnergyState.unknown;
      case BluetoothLowEnergyStateArgs.unsupported:
        return BluetoothLowEnergyState.unsupported;
      case BluetoothLowEnergyStateArgs.disabled:
        return BluetoothLowEnergyState.unsupported;
      case BluetoothLowEnergyStateArgs.off:
        return BluetoothLowEnergyState.poweredOff;
      case BluetoothLowEnergyStateArgs.on:
        return BluetoothLowEnergyState.poweredOn;
    }
  }
}

extension ConnectionStateArgsX on ConnectionStateArgs {
  ConnectionState toState() {
    switch (this) {
      case ConnectionStateArgs.disconnected:
        return ConnectionState.disconnected;
      case ConnectionStateArgs.connected:
        return ConnectionState.connected;
    }
  }
}

extension GATTCharacteristicWriteTypeArgsX on GATTCharacteristicWriteTypeArgs {
  GATTCharacteristicWriteType toType() {
    return GATTCharacteristicWriteType.values[index];
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
      serviceUUIDs: serviceUUIDsArgs
          .map((args) => UUID.fromString(args))
          .toList(),
      serviceData: serviceDataArgs.map((uuidArgs, dataArgs) {
        final uuid = UUID.fromString(uuidArgs);
        return MapEntry(uuid, dataArgs);
      }),
      manufacturerSpecificData: manufacturerSpecificDataArgs
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
      handle: handleArgs,
      uuid: UUID.fromString(uuidArgs),
    );
  }
}

extension GATTCharacteristicArgsX on GATTCharacteristicArgs {
  GATTCharacteristic toCharacteristic() {
    return GATTCharacteristicImpl(
      handle: handleArgs,
      uuid: UUID.fromString(uuidArgs),
      properties: propertyNumbersArgs.map((args) {
        final propertyArgs = GATTCharacteristicPropertyArgs.values[args];
        return propertyArgs.toProperty();
      }).toList(),
      descriptors: descriptorsArgs
          .map((args) => args.toDescriptor())
          .cast<GATTDescriptorImpl>()
          .toList(),
    );
  }
}

extension GATTServiceArgsX on GATTServiceArgs {
  GATTService toService() {
    return GATTServiceImpl(
      handle: handleArgs,
      uuid: UUID.fromString(uuidArgs),
      isPrimary: isPrimaryArgs,
      includedServices: includedServicesArgs
          .map((args) => args.toService())
          .cast<GATTServiceImpl>()
          .toList(),
      characteristics: characteristicsArgs
          .map((args) => args.toCharacteristic())
          .cast<GATTCharacteristicImpl>()
          .toList(),
    );
  }
}

extension CentralArgsX on CentralArgs {
  CentralImpl toCentral() {
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

extension GATTCharacteristicPermissionsX on List<GATTCharacteristicPermission> {
  GATTProtectionLevelArgs? toReadArgs() {
    return contains(GATTCharacteristicPermission.readEncrypted)
        ? GATTProtectionLevelArgs.entryptionRequired
        : contains(GATTCharacteristicPermission.read)
        ? GATTProtectionLevelArgs.plain
        : null;
  }

  GATTProtectionLevelArgs? toWriteArgs() {
    return contains(GATTCharacteristicPermission.writeEncrypted)
        ? GATTProtectionLevelArgs.entryptionRequired
        : contains(GATTCharacteristicPermission.write)
        ? GATTProtectionLevelArgs.plain
        : null;
  }
}

extension GATTErrorX on GATTError {
  GATTProtocolErrorArgs toArgs() {
    switch (this) {
      case GATTError.invalidHandle:
        return GATTProtocolErrorArgs.invalidHandle;
      case GATTError.readNotPermitted:
        return GATTProtocolErrorArgs.readNotPermitted;
      case GATTError.writeNotPermitted:
        return GATTProtocolErrorArgs.writeNotPermitted;
      case GATTError.invalidPDU:
        return GATTProtocolErrorArgs.invalidPDU;
      case GATTError.insufficientAuthentication:
        return GATTProtocolErrorArgs.insufficientAuthentication;
      case GATTError.requestNotSupported:
        return GATTProtocolErrorArgs.requestNotSupported;
      case GATTError.invalidOffset:
        return GATTProtocolErrorArgs.invalidOffset;
      case GATTError.insufficientAuthorization:
        return GATTProtocolErrorArgs.insufficientAuthorization;
      case GATTError.prepareQueueFull:
        return GATTProtocolErrorArgs.prepareQueueFull;
      case GATTError.attributeNotFound:
        return GATTProtocolErrorArgs.attributeNotFound;
      case GATTError.attributeNotLong:
        return GATTProtocolErrorArgs.attributeNotLong;
      case GATTError.insufficientEncryptionKeySize:
        return GATTProtocolErrorArgs.insufficientEncryptionKeySize;
      case GATTError.invalidAttributeValueLength:
        return GATTProtocolErrorArgs.invalidAttributeValueLength;
      case GATTError.unlikelyError:
        return GATTProtocolErrorArgs.unlikelyError;
      case GATTError.insufficientEncryption:
        return GATTProtocolErrorArgs.insufficientEncryption;
      case GATTError.unsupportedGroupType:
        return GATTProtocolErrorArgs.unsupportedGroupType;
      case GATTError.insufficientResources:
        return GATTProtocolErrorArgs.insufficientResources;
    }
  }
}

extension ManufacturerSpecificDataX on ManufacturerSpecificData {
  ManufacturerSpecificDataArgs toArgs() {
    return ManufacturerSpecificDataArgs(idArgs: id, dataArgs: data);
  }
}

extension AdvertisementX on Advertisement {
  AdvertisementArgs toArgs() {
    // When configuring the publisher object, you can't add restricted section types
    // (BluetoothLEAdvertisementPublisher.Advertisement.Flags and
    // BluetoothLEAdvertisementPublisher.Advertisement.LocalName). Trying to set those property values results in a
    // runtime exception. You can still set the manufacturer data section, or any other sections not defined by the list of
    // restrictions.
    // See: https://learn.microsoft.com/en-us/uwp/api/windows.devices.bluetooth.advertisement.bluetoothleadvertisementpublisher.advertisement?view=winrt-22621
    if (name != null) {
      throw UnsupportedError('name is not supported on Windows.');
    }
    return AdvertisementArgs(
      nameArgs: null,
      serviceUUIDsArgs: serviceUUIDs.map((uuid) => uuid.toArgs()).toList(),
      serviceDataArgs: serviceData.map((uuid, data) {
        final uuidArgs = uuid.toArgs();
        return MapEntry(uuidArgs, data);
      }),
      manufacturerSpecificDataArgs: manufacturerSpecificData
          .map((data) => data.toArgs())
          .toList(),
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
      readProtectionLevelArgs: impl.permissions.toReadArgs(),
      writeProtectionLevelArgs: impl.permissions.toWriteArgs(),
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
      valueArgs: impl is ImmutableGATTCharacteristicImpl ? impl.value : null,
      propertyNumbersArgs: impl.properties.map((property) {
        final propertyArgs = property.toArgs();
        return propertyArgs.index;
      }).toList(),
      readProtectionLevelArgs: impl.permissions.toReadArgs(),
      writeProtectionLevelArgs: impl.permissions.toWriteArgs(),
      descriptorsArgs: descriptors
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
      includedServicesArgs: impl.includedServices
          .map((service) => service.toArgs())
          .toList(),
      characteristicsArgs: impl.characteristics
          .map((characteristic) => characteristic.toArgs())
          .toList(),
    );
  }
}
