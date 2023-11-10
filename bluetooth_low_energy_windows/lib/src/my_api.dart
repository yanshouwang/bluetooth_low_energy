import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';

export 'my_api.g.dart';

extension MyBluetoothLowEnergyStateArgsX on MyBluetoothLowEnergyStateArgs {
  BluetoothLowEnergyState toState() {
    return BluetoothLowEnergyState.values[index];
  }
}

extension MyAdvertisementArgsX on MyAdvertisementArgs {
  Advertisement toAdvertisement() {
    final name = nameArgs;
    final serviceUUIDs = serviceUUIDsArgs
        .cast<String>()
        .map((args) => UUID.fromString(args))
        .toList();
    final serviceData = serviceDataArgs.cast<String, Uint8List>().map(
      (uuidArgs, dataArgs) {
        final uuid = UUID.fromString(uuidArgs);
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

extension MyGattCharacteristicPropertyArgsX
    on MyGattCharacteristicPropertyArgs {
  GattCharacteristicProperty toProperty() {
    return GattCharacteristicProperty.values[index];
  }
}

extension GattCharacteristicWriteTypeX on GattCharacteristicWriteType {
  MyGattCharacteristicWriteTypeArgs toArgs() {
    return MyGattCharacteristicWriteTypeArgs.values[index];
  }
}

extension MyPeripheralArgsX on MyPeripheralArgs {
  Peripheral toPeripheral() {
    final uuid = UUID.fromString(uuidArgs);
    return MyPeripheral(
      uuid: uuid,
    );
  }
}

extension MyGattServiceArgsX on MyGattServiceArgs {
  MyGattService toService() {
    final uuid = UUID.fromString(uuidArgs);
    final characteristics = characteristicsArgs
        .cast<MyGattCharacteristicArgs>()
        .map((args) => args.toCharacteristic())
        .toList();
    return MyGattService(
      uuid: uuid,
      characteristics: characteristics,
    );
  }
}

extension MyGattCharacteristicArgsX on MyGattCharacteristicArgs {
  MyGattCharacteristic toCharacteristic() {
    final uuid = UUID.fromString(uuidArgs);
    final properties = propertyNumbersArgs.cast<int>().map(
      (args) {
        final propertyArgs = MyGattCharacteristicPropertyArgs.values[args];
        return propertyArgs.toProperty();
      },
    ).toList();
    final descriptors = descriptorsArgs
        .cast<MyGattDescriptorArgs>()
        .map((args) => args.toDescriptor())
        .toList();
    return MyGattCharacteristic(
      uuid: uuid,
      properties: properties,
      descriptors: descriptors,
    );
  }
}

extension MyGattDescriptorArgsX on MyGattDescriptorArgs {
  MyGattDescriptor toDescriptor() {
    final uuid = UUID.fromString(uuidArgs);
    return MyGattDescriptor(
      uuid: uuid,
    );
  }
}

extension MyCentralArgsX on MyCentralArgs {
  MyCentral toCentral() {
    final uuid = UUID.fromString(uuidArgs);
    return MyCentral(
      uuid: uuid,
    );
  }
}

extension AdvertisementX on Advertisement {
  MyAdvertisementArgs toArgs() {
    final nameArgs = name;
    final serviceUUIDsArgs =
        serviceUUIDs.map((uuid) => uuid.toString()).toList();
    final serviceDataArgs = serviceData.map((uuid, data) {
      final uuidArgs = uuid.toString();
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

extension GattCharacteristicPropertyX on GattCharacteristicProperty {
  MyGattCharacteristicPropertyArgs toArgs() {
    return MyGattCharacteristicPropertyArgs.values[index];
  }
}
