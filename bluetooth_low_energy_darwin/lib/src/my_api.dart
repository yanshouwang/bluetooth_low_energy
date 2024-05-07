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

extension MyGATTCharacteristicPropertyArgsX
    on MyGATTCharacteristicPropertyArgs {
  GATTCharacteristicProperty toProperty() {
    return GATTCharacteristicProperty.values[index];
  }
}

extension MyManufacturerSpecificDataArgsX on MyManufacturerSpecificDataArgs {
  ManufacturerSpecificData toManufacturerSpecificData() {
    final id = idArgs;
    final data = dataArgs;
    return ManufacturerSpecificData(
      id: id,
      data: data,
    );
  }
}

extension MyAdvertisementArgsX on MyAdvertisementArgs {
  Advertisement toAdvertisement() {
    final name = nameArgs;
    final serviceUUIDs =
        serviceUUIDsArgs.cast<String>().map((args) => args.toUUID()).toList();
    final serviceData = serviceDataArgs.cast<String, Uint8List>().map(
      (uuidArgs, dataArgs) {
        final uuid = uuidArgs.toUUID();
        final data = dataArgs;
        return MapEntry(uuid, data);
      },
    );
    final manufacturerSpecificData =
        manufacturerSpecificDataArgs?.toManufacturerSpecificData();
    return Advertisement(
      name: name,
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
  MyGATTDescriptor toDescriptor(Peripheral peripheral) {
    final hashCode = hashCodeArgs;
    final uuid = uuidArgs.toUUID();
    return MyGATTDescriptor(
      peripheral: peripheral,
      hashCode: hashCode,
      uuid: uuid,
    );
  }
}

extension MyGATTCharacteristicArgsX on MyGATTCharacteristicArgs {
  MyGATTCharacteristic toCharacteristic(Peripheral peripheral) {
    final hashCode = hashCodeArgs;
    final uuid = uuidArgs.toUUID();
    final properties = propertyNumbersArgs.cast<int>().map(
      (args) {
        final propertyArgs = MyGATTCharacteristicPropertyArgs.values[args];
        return propertyArgs.toProperty();
      },
    ).toList();
    final descriptors = descriptorsArgs
        .cast<MyGATTDescriptorArgs>()
        .map((args) => args.toDescriptor(peripheral))
        .toList();
    return MyGATTCharacteristic(
      peripheral: peripheral,
      hashCode: hashCode,
      uuid: uuid,
      properties: properties,
      descriptors: descriptors,
    );
  }
}

extension MyGATTServiceArgsX on MyGATTServiceArgs {
  MyGATTService toService(Peripheral peripheral) {
    final hashCode = hashCodeArgs;
    final uuid = uuidArgs.toUUID();
    final characteristics = characteristicsArgs
        .cast<MyGATTCharacteristicArgs>()
        .map((args) => args.toCharacteristic(peripheral))
        .toList();
    return MyGATTService(
      peripheral: peripheral,
      hashCode: hashCode,
      uuid: uuid,
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

extension GATTCharacteristicWriteTypeX on GATTCharacteristicWriteType {
  MyGATTCharacteristicWriteTypeArgs toArgs() {
    return MyGATTCharacteristicWriteTypeArgs.values[index];
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
    final nameArgs = name;
    final serviceUUIDsArgs = serviceUUIDs.map((uuid) => uuid.toArgs()).toList();
    final serviceDataArgs = serviceData.map((uuid, data) {
      final uuidArgs = uuid.toArgs();
      final dataArgs = data;
      return MapEntry(uuidArgs, dataArgs);
    });
    final manufacturerSpecificDataArgs = manufacturerSpecificData?.toArgs();
    return MyAdvertisementArgs(
      nameArgs: nameArgs,
      serviceUUIDsArgs: serviceUUIDsArgs,
      serviceDataArgs: serviceDataArgs,
      manufacturerSpecificDataArgs: manufacturerSpecificDataArgs,
    );
  }
}

extension MutableGATTDescriptorX on MutableGATTDescriptor {
  MyMutableGATTDescriptorArgs toArgs() {
    final hashCodeArgs = hashCode;
    final uuidArgs = uuid.toArgs();
    final valueArgs = value;
    return MyMutableGATTDescriptorArgs(
      hashCodeArgs: hashCodeArgs,
      uuidArgs: uuidArgs,
      valueArgs: valueArgs,
    );
  }
}

extension MutableGATTCharacteristicX on MutableGATTCharacteristic {
  MyMutableGATTCharacteristicArgs toArgs(
      List<MyMutableGATTDescriptorArgs> descriptorsArgs) {
    final hashCodeArgs = hashCode;
    final uuidArgs = uuid.toArgs();
    final propertyNumbersArgs = properties.map((property) {
      final propertyArgs = property.toArgs();
      return propertyArgs.index;
    }).toList();
    final valueArgs = value;
    return MyMutableGATTCharacteristicArgs(
      hashCodeArgs: hashCodeArgs,
      uuidArgs: uuidArgs,
      propertyNumbersArgs: propertyNumbersArgs,
      valueArgs: valueArgs,
      descriptorsArgs: descriptorsArgs,
    );
  }
}

extension MutableGATTServiceX on MutableGATTService {
  MyMutableGATTServiceArgs toArgs(
      List<MyMutableGATTCharacteristicArgs> characteristicsArgs) {
    final hashCodeArgs = hashCode;
    final uuidArgs = uuid.toArgs();
    return MyMutableGATTServiceArgs(
      hashCodeArgs: hashCodeArgs,
      uuidArgs: uuidArgs,
      characteristicsArgs: characteristicsArgs,
    );
  }
}

extension UUIDX on UUID {
  String toArgs() {
    return toString().toLowerCase();
  }
}
