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
    final manufacturerSpecificData =
        manufacturerSpecificDataArgs?.toManufacturerSpecificData();
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
    return Advertisement(
      name: name,
      manufacturerSpecificData: manufacturerSpecificData,
      serviceUUIDs: serviceUUIDs,
      serviceData: serviceData,
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
  MyPeripheral toPeripheral() {
    final hashCode = hashCodeArgs;
    final uuid = UUID.fromString(uuidArgs);
    return MyPeripheral(
      hashCode: hashCode,
      uuid: uuid,
    );
  }
}

extension MyGattServiceArgsX on MyGattServiceArgs {
  MyGattService2 toService2() {
    final hashCode = hashCodeArgs;
    final uuid = UUID.fromString(uuidArgs);
    final characteristics = characteristicsArgs
        .cast<MyGattCharacteristicArgs>()
        .map((args) => args.toCharacteristic2())
        .toList();
    return MyGattService2(
      hashCode: hashCode,
      uuid: uuid,
      characteristics: characteristics,
    );
  }
}

extension MyGattCharacteristicArgsX on MyGattCharacteristicArgs {
  MyGattCharacteristic2 toCharacteristic2() {
    final hashCode = hashCodeArgs;
    final uuid = UUID.fromString(uuidArgs);
    final properties = propertyNumbersArgs.cast<int>().map(
      (args) {
        final propertyArgs = MyGattCharacteristicPropertyArgs.values[args];
        return propertyArgs.toProperty();
      },
    ).toList();
    final descriptors = descriptorsArgs
        .cast<MyGattDescriptorArgs>()
        .map((args) => args.toDescriptor2())
        .toList();
    return MyGattCharacteristic2(
      hashCode: hashCode,
      uuid: uuid,
      properties: properties,
      descriptors: descriptors,
    );
  }
}

extension MyGattDescriptorArgsX on MyGattDescriptorArgs {
  MyGattDescriptor2 toDescriptor2() {
    final hashCode = hashCodeArgs;
    final uuid = UUID.fromString(uuidArgs);
    return MyGattDescriptor2(
      hashCode: hashCode,
      uuid: uuid,
    );
  }
}

extension MyCentralArgsX on MyCentralArgs {
  MyCentral toCentral() {
    final hashCode = hashCodeArgs;
    final uuid = UUID.fromString(uuidArgs);
    return MyCentral(
      hashCode: hashCode,
      uuid: uuid,
    );
  }
}

extension AdvertisementX on Advertisement {
  MyAdvertisementArgs toArgs() {
    final nameArgs = name;
    final manufacturerSpecificDataArgs = manufacturerSpecificData?.toArgs();
    final serviceUUIDsArgs =
        serviceUUIDs.map((uuid) => uuid.toString()).toList();
    final serviceDataArgs = serviceData.map((uuid, data) {
      final uuidArgs = uuid.toString();
      final dataArgs = data;
      return MapEntry(uuidArgs, dataArgs);
    });
    return MyAdvertisementArgs(
      nameArgs: nameArgs,
      manufacturerSpecificDataArgs: manufacturerSpecificDataArgs,
      serviceUUIDsArgs: serviceUUIDsArgs,
      serviceDataArgs: serviceDataArgs,
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

extension MyGattServiceX on MyGattService {
  MyGattServiceArgs toArgs() {
    final hashCodeArgs = hashCode;
    final uuidArgs = uuid.toString();
    final characteristicsArgs = characteristics
        .cast<MyGattCharacteristic>()
        .map((characteristic) => characteristic.toArgs())
        .toList();
    return MyGattServiceArgs(
      hashCodeArgs: hashCodeArgs,
      uuidArgs: uuidArgs,
      characteristicsArgs: characteristicsArgs,
    );
  }
}

extension MyGattCharacteristicX on MyGattCharacteristic {
  MyGattCharacteristicArgs toArgs() {
    final hashCodeArgs = hashCode;
    final uuidArgs = uuid.toString();
    final propertyNumbersArgs = properties.map((property) {
      final propertyArgs = property.toArgs();
      return propertyArgs.index;
    }).toList();
    final descriptorsArgs = descriptors
        .cast<MyGattDescriptor>()
        .map((descriptor) => descriptor.toArgs())
        .toList();
    return MyGattCharacteristicArgs(
      hashCodeArgs: hashCodeArgs,
      uuidArgs: uuidArgs,
      propertyNumbersArgs: propertyNumbersArgs,
      descriptorsArgs: descriptorsArgs,
    );
  }
}

extension MyGattDescriptorX on MyGattDescriptor {
  MyGattDescriptorArgs toArgs() {
    final hashCodeArgs = hashCode;
    final uuidArgs = uuid.toString();
    final valueArgs = value;
    return MyGattDescriptorArgs(
      hashCodeArgs: hashCodeArgs,
      uuidArgs: uuidArgs,
      valueArgs: valueArgs,
    );
  }
}

extension GattCharacteristicPropertyX on GattCharacteristicProperty {
  MyGattCharacteristicPropertyArgs toArgs() {
    return MyGattCharacteristicPropertyArgs.values[index];
  }
}
