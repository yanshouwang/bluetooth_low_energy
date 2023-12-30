import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';
import 'my_central2.dart';
import 'my_gatt_characteristic2.dart';
import 'my_gatt_descriptor2.dart';
import 'my_gatt_service2.dart';
import 'my_peripheral2.dart';

export 'my_api.g.dart';

// ToObject
extension MyBluetoothLowEnergyStateArgsX on MyBluetoothLowEnergyStateArgs {
  BluetoothLowEnergyState toState() {
    return BluetoothLowEnergyState.values[index];
  }
}

extension MyGattCharacteristicPropertyArgsX
    on MyGattCharacteristicPropertyArgs {
  GattCharacteristicProperty toProperty() {
    return GattCharacteristicProperty.values[index];
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
  MyCentral2 toCentral() {
    return MyCentral2(
      address: addressArgs,
    );
  }
}

extension MyPeripheralArgsX on MyPeripheralArgs {
  MyPeripheral2 toPeripheral() {
    return MyPeripheral2(
      address: addressArgs,
    );
  }
}

extension MyGattDescriptorArgsX on MyGattDescriptorArgs {
  MyGattDescriptor2 toDescriptor2(MyPeripheral2 peripheral) {
    final hashCode = hashCodeArgs;
    final uuid = uuidArgs.toUUID();
    return MyGattDescriptor2(
      peripheral: peripheral,
      hashCode: hashCode,
      uuid: uuid,
    );
  }
}

extension MyGattCharacteristicArgsX on MyGattCharacteristicArgs {
  MyGattCharacteristic2 toCharacteristic2(MyPeripheral2 peripheral) {
    final hashCode = hashCodeArgs;
    final uuid = uuidArgs.toUUID();
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
      hashCode: hashCode,
      uuid: uuid,
      properties: properties,
      descriptors: descriptors,
    );
  }
}

extension MyGattServiceArgsX on MyGattServiceArgs {
  MyGattService2 toService2(MyPeripheral2 peripheral) {
    final hashCode = hashCodeArgs;
    final uuid = uuidArgs.toUUID();
    final characteristics = characteristicsArgs
        .cast<MyGattCharacteristicArgs>()
        .map((args) => args.toCharacteristic2(peripheral))
        .toList();
    return MyGattService2(
      peripheral: peripheral,
      hashCode: hashCode,
      uuid: uuid,
      characteristics: characteristics,
    );
  }
}

extension MyUuidArgsX on String {
  UUID toUUID() {
    return UUID.fromString(this);
  }
}

// ToArgs
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

extension MyGattDescriptorX on MyGattDescriptor {
  MyGattDescriptorArgs toArgs() {
    final hashCodeArgs = hashCode;
    final uuidArgs = uuid.toArgs();
    final valueArgs = value;
    return MyGattDescriptorArgs(
      hashCodeArgs: hashCodeArgs,
      uuidArgs: uuidArgs,
      valueArgs: valueArgs,
    );
  }
}

extension MyGattCharacteristicX on MyGattCharacteristic {
  MyGattCharacteristicArgs toArgs() {
    final hashCodeArgs = hashCode;
    final uuidArgs = uuid.toArgs();
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

extension MyGattServiceX on MyGattService {
  MyGattServiceArgs toArgs() {
    final hashCodeArgs = hashCode;
    final uuidArgs = uuid.toArgs();
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

extension UuidX on UUID {
  String toArgs() {
    return toString();
  }
}
