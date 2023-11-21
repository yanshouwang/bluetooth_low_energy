import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';
import 'my_gatt_characteristic2.dart';
import 'my_gatt_descriptor2.dart';
import 'my_gatt_service2.dart';

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

extension MyCentralArgsX on MyCentralArgs {
  MyCentral toCentral() {
    final uuid = addressArgs.toUUID();
    return MyCentral(
      uuid: uuid,
    );
  }
}

extension MyPeripheralArgsX on MyPeripheralArgs {
  MyPeripheral toPeripheral() {
    final uuid = addressArgs.toUUID();
    return MyPeripheral(
      uuid: uuid,
    );
  }
}

extension MyAddressArgsX on int {
  UUID toUUID() {
    final node = (this & 0xFFFFFFFFFFFF).toRadixString(16).padLeft(12, '0');
    return UUID.fromString('00000000-0000-0000-0000-$node');
  }
}

extension MyGattServiceArgsX on MyGattServiceArgs {
  MyGattService2 toService2(MyPeripheral peripheral) {
    final handle = handleArgs;
    final uuid = UUID.fromString(uuidArgs);
    final characteristics = characteristicsArgs
        .cast<MyGattCharacteristicArgs>()
        .map((args) => args.toCharacteristic2(peripheral))
        .toList();
    return MyGattService2(
      peripheral: peripheral,
      handle: handle,
      uuid: uuid,
      characteristics: characteristics,
    );
  }
}

extension MyGattCharacteristicArgsX on MyGattCharacteristicArgs {
  MyGattCharacteristic2 toCharacteristic2(MyPeripheral peripheral) {
    final handle = handleArgs;
    final uuid = UUID.fromString(uuidArgs);
    final properties = propertyNumbersArgs.cast<int>().map(
      (args) {
        final propertyArgs = MyGattCharacteristicPropertyArgs.values[args];
        return propertyArgs.toProperty();
      },
    ).toList();
    final descriptors = descriptorsArgs
        .cast<MyGattDescriptorArgs>()
        .map((args) => args.toDescriptor2(peripheral))
        .toList();
    return MyGattCharacteristic2(
      peripheral: peripheral,
      handle: handle,
      uuid: uuid,
      properties: properties,
      descriptors: descriptors,
    );
  }
}

extension MyGattCharacteristicPropertyArgsX
    on MyGattCharacteristicPropertyArgs {
  GattCharacteristicProperty toProperty() {
    return GattCharacteristicProperty.values[index];
  }
}

extension MyGattDescriptorArgsX on MyGattDescriptorArgs {
  MyGattDescriptor2 toDescriptor2(MyPeripheral peripheral) {
    final handle = handleArgs;
    final uuid = UUID.fromString(uuidArgs);
    return MyGattDescriptor2(
      peripheral: peripheral,
      handle: handle,
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

extension MyPeripheralX on MyPeripheral {
  MyPeripheralArgs toArgs() {
    final addressArgs = uuid.toAddressArgs();
    return MyPeripheralArgs(
      addressArgs: addressArgs,
    );
  }
}

extension MyGattService2X on MyGattService2 {
  MyGattServiceArgs toArgs() {
    final handleArgs = handle;
    final uuidArgs = uuid.toArgs();
    final characteristicsArgs = characteristics
        .map((characteristic) => characteristic.toArgs())
        .toList();
    return MyGattServiceArgs(
      handleArgs: handleArgs,
      uuidArgs: uuidArgs,
      characteristicsArgs: characteristicsArgs,
    );
  }
}

extension MyGattCharacteristic2X on MyGattCharacteristic2 {
  MyGattCharacteristicArgs toArgs() {
    final handleArgs = handle;
    final uuidArgs = uuid.toArgs();
    final propertyNumbersArgs =
        properties.map((property) => property.toArgs().index).toList();
    final descriptorsArgs =
        descriptors.map((descriptor) => descriptor.toArgs()).toList();
    return MyGattCharacteristicArgs(
      handleArgs: handleArgs,
      uuidArgs: uuidArgs,
      propertyNumbersArgs: propertyNumbersArgs,
      descriptorsArgs: descriptorsArgs,
    );
  }
}

extension MyGattDescriptor2X on MyGattDescriptor2 {
  MyGattDescriptorArgs toArgs() {
    final handleArgs = handle;
    final uuidArgs = uuid.toArgs();
    final valueArgs = value;
    return MyGattDescriptorArgs(
      handleArgs: handleArgs,
      uuidArgs: uuidArgs,
      valueArgs: valueArgs,
    );
  }
}

extension UuidX on UUID {
  String toArgs() {
    return toString();
  }

  int toAddressArgs() {
    final node = toString().split('-').last;
    final address = int.parse(
      node,
      radix: 16,
    );
    return address;
  }
}

extension GattCharacteristicPropertyX on GattCharacteristicProperty {
  MyGattCharacteristicPropertyArgs toArgs() {
    return MyGattCharacteristicPropertyArgs.values[index];
  }
}

extension GattCharacteristicWriteTypeX on GattCharacteristicWriteType {
  MyGattCharacteristicWriteTypeArgs toArgs() {
    return MyGattCharacteristicWriteTypeArgs.values[index];
  }
}
