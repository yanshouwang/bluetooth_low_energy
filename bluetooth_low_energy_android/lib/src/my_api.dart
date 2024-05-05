import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';
import 'my_central.dart';
import 'my_gatt.dart';
import 'my_peripheral.dart';

extension StringX on String {
  UUID toUUID() {
    return UUID.fromString(this);
  }
}

extension UUIDX on UUID {
  String toArgs() {
    return toString();
  }
}

extension MyBluetoothLowEnergyStateArgsX on MyBluetoothLowEnergyStateArgs {
  BluetoothLowEnergyState toState() {
    switch (this) {
      case MyBluetoothLowEnergyStateArgs.unknown:
        return BluetoothLowEnergyState.unknown;
      case MyBluetoothLowEnergyStateArgs.unsupported:
        return BluetoothLowEnergyState.unsupported;
      case MyBluetoothLowEnergyStateArgs.unauthorized:
        return BluetoothLowEnergyState.unauthorized;
      case MyBluetoothLowEnergyStateArgs.off:
      case MyBluetoothLowEnergyStateArgs.turningOn:
        return BluetoothLowEnergyState.poweredOff;
      case MyBluetoothLowEnergyStateArgs.on:
      case MyBluetoothLowEnergyStateArgs.turningOff:
        return BluetoothLowEnergyState.poweredOn;
    }
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
  MyCentral toCentral() {
    return MyCentral(
      address: addressArgs,
    );
  }
}

extension MyPeripheralArgsX on MyPeripheralArgs {
  MyPeripheral toPeripheral() {
    return MyPeripheral(
      address: addressArgs,
    );
  }
}

extension MyGattDescriptorArgsX on MyGattDescriptorArgs {
  MyGattDescriptor toDescriptor(MyPeripheral peripheral) {
    final hashCode = hashCodeArgs;
    final uuid = uuidArgs.toUUID();
    return MyGattDescriptor(
      peripheral: peripheral,
      hashCode: hashCode,
      uuid: uuid,
    );
  }
}

extension MyGattCharacteristicArgsX on MyGattCharacteristicArgs {
  MyGattCharacteristic toCharacteristic(MyPeripheral peripheral) {
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
        .map((args) => args.toDescriptor(peripheral))
        .toList();
    return MyGattCharacteristic(
      peripheral: peripheral,
      hashCode: hashCode,
      uuid: uuid,
      properties: properties,
      descriptors: descriptors,
    );
  }
}

extension MyGattServiceArgsX on MyGattServiceArgs {
  MyGattService toService(MyPeripheral peripheral) {
    final hashCode = hashCodeArgs;
    final uuid = uuidArgs.toUUID();
    final characteristics = characteristicsArgs
        .cast<MyGattCharacteristicArgs>()
        .map((args) => args.toCharacteristic(peripheral))
        .toList();
    return MyGattService(
      peripheral: peripheral,
      hashCode: hashCode,
      uuid: uuid,
      characteristics: characteristics,
    );
  }
}

extension GattCharacteristicWriteTypeX on GattCharacteristicWriteType {
  MyGattCharacteristicWriteTypeArgs toArgs() {
    return MyGattCharacteristicWriteTypeArgs.values[index];
  }
}

extension GattCharacteristicPropertyX on GattCharacteristicProperty {
  MyGattCharacteristicPropertyArgs toArgs() {
    return MyGattCharacteristicPropertyArgs.values[index];
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

extension GattDescriptorX on MutableGattDescriptor {
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

extension GattCharacteristicX on MutableGattCharacteristic {
  MyGattCharacteristicArgs toArgs(List<MyGattDescriptorArgs> descriptorsArgs) {
    final hashCodeArgs = hashCode;
    final uuidArgs = uuid.toArgs();
    final propertyNumbersArgs = properties.map((property) {
      final propertyArgs = property.toArgs();
      return propertyArgs.index;
    }).toList();
    return MyGattCharacteristicArgs(
      hashCodeArgs: hashCodeArgs,
      uuidArgs: uuidArgs,
      propertyNumbersArgs: propertyNumbersArgs,
      descriptorsArgs: descriptorsArgs,
    );
  }
}

extension GattServiceX on MutableGattService {
  MyGattServiceArgs toArgs(List<MyGattCharacteristicArgs> characteristicsArgs) {
    final hashCodeArgs = hashCode;
    final uuidArgs = uuid.toArgs();
    return MyGattServiceArgs(
      hashCodeArgs: hashCodeArgs,
      uuidArgs: uuidArgs,
      characteristicsArgs: characteristicsArgs,
    );
  }
}
