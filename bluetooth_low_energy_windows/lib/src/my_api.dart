// ignore_for_file: camel_case_extensions

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

extension MyPeripheralArgsX on MyPeripheralArgs {
  MyPeripheral toPeripheral() {
    return MyPeripheral(
      addressArgs: addressArgs,
    );
  }
}

extension MyGATTDescriptorArgsX on MyGATTDescriptorArgs {
  MyGATTDescriptor toDescriptor() {
    final uuid = uuidArgs.toUUID();
    return MyGATTDescriptor(
      handleArgs: handleArgs,
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
      handleArgs: handleArgs,
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
      handleArgs: handleArgs,
      uuid: uuid,
      isPrimary: isPrimaryArgs,
      includedServices: includedServices,
      characteristics: characteristics,
    );
  }
}

extension intX on int {
  UUID toUUID() {
    final node = (this & 0xFFFFFFFFFFFF).toRadixString(16).padLeft(12, '0');
    return UUID.fromString('00000000-0000-0000-0000-$node');
  }
}

extension StringX on String {
  UUID toUUID() {
    return UUID.fromString(this);
  }
}

// ToArgs
extension MyPeripheralX on MyPeripheral {
  MyPeripheralArgs toArgs() {
    return MyPeripheralArgs(
      addressArgs: addressArgs,
    );
  }
}

extension GATTCharacteristicWriteTypeX on GATTCharacteristicWriteType {
  MyGATTCharacteristicWriteTypeArgs toArgs() {
    return MyGATTCharacteristicWriteTypeArgs.values[index];
  }
}

extension UUIDX on UUID {
  String toArgs() {
    return toString();
  }
}
