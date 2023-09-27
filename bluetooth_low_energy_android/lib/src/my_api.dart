import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';

export 'my_api.g.dart';

extension MyBluetoothLowEnergyStateArgsX on MyBluetoothLowEnergyStateArgs {
  BluetoothLowEnergyState toMyState() {
    return BluetoothLowEnergyState.values[index];
  }
}

extension MyAdvertisementArgsX on MyAdvertisementArgs {
  Advertisement toMyAdvertisement() {
    final name = myName;
    final manufacturerSpecificData =
        myManufacturerSpecificData.cast<int, Uint8List>();
    final serviceUUIDs = myServiceUUIDs
        .cast<String>()
        .map((uuidValue) => UUID.fromString(uuidValue))
        .toList();
    final serviceData = myServiceData.cast<String, Uint8List>().map(
      (uuidValue, data) {
        final uuid = UUID.fromString(uuidValue);
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

extension MyGattCharacteristicPropertyArgsX
    on MyGattCharacteristicPropertyArgs {
  GattCharacteristicProperty toMyProperty() {
    return GattCharacteristicProperty.values[index];
  }
}

extension GattCharacteristicWriteTypeX on GattCharacteristicWriteType {
  MyGattCharacteristicWriteTypeArgs toMyArgs() {
    return MyGattCharacteristicWriteTypeArgs.values[index];
  }
}

extension MyPeripheralArgsX on MyPeripheralArgs {
  MyPeripheral toMyPeripheral() {
    final uuid = UUID.fromString(myUUID);
    return MyPeripheral(
      myHashCode: myHashCode,
      uuid: uuid,
    );
  }
}

extension MyGattServiceArgsX on MyGattServiceArgs {
  MyGattService toMyService() {
    final uuid = UUID.fromString(myUUID);
    final characteristics = myCharacteristicArgses
        .cast<MyGattCharacteristicArgs>()
        .map(
            (myCharacteristicArgs) => myCharacteristicArgs.toMyCharacteristic())
        .toList();
    return MyGattService(
      myHashCode: myHashCode,
      uuid: uuid,
      characteristics: characteristics,
    );
  }
}

extension MyGattCharacteristicArgsX on MyGattCharacteristicArgs {
  MyGattCharacteristic toMyCharacteristic() {
    final uuid = UUID.fromString(myUUID);
    final properties = myPropertyNumbers.cast<int>().map(
      (myPropertyNumber) {
        final myPropertyArgs =
            MyGattCharacteristicPropertyArgs.values[myPropertyNumber];
        return myPropertyArgs.toMyProperty();
      },
    ).toList();
    final descriptors = myDescriptorArgses
        .cast<MyGattDescriptorArgs>()
        .map((myDescriptorArgs) => myDescriptorArgs.toMyDescriptor())
        .toList();
    return MyGattCharacteristic(
      myHashCode: myHashCode,
      uuid: uuid,
      properties: properties,
      descriptors: descriptors,
    );
  }
}

extension MyGattDescriptorArgsX on MyGattDescriptorArgs {
  MyGattDescriptor toMyDescriptor() {
    final uuid = UUID.fromString(myUUID);
    return MyGattDescriptor(
      myHashCode: myHashCode,
      uuid: uuid,
    );
  }
}

extension MyCentralArgsX on MyCentralArgs {
  MyCentral toMyCentral() {
    final uuid = UUID.fromString(myUUID);
    return MyCentral(
      myHashCode: myHashCode,
      uuid: uuid,
    );
  }
}

extension AdvertisementX on Advertisement {
  MyAdvertisementArgs toMyArgs() {
    final myName = name;
    final myManufacturerSpecificData = manufacturerSpecificData;
    final myServiceUUIDs = serviceUUIDs
        .map(
          (uuid) => uuid.toString(),
        )
        .toList();
    final myServiceData = serviceData.map(
      (uuid, data) {
        final uuidValue = uuid.toString();
        return MapEntry(uuidValue, data);
      },
    );
    return MyAdvertisementArgs(
      myName: myName,
      myManufacturerSpecificData: myManufacturerSpecificData,
      myServiceUUIDs: myServiceUUIDs,
      myServiceData: myServiceData,
    );
  }
}

extension MyGattServiceX on MyGattService {
  MyGattServiceArgs toMyArgs() {
    final myHashCode = hashCode;
    final myUUID = uuid.toString();
    final myCharacteristicArgses = characteristics
        .cast<MyGattCharacteristic>()
        .map((myCharacteristic) => myCharacteristic.toMyArgs())
        .toList();
    return MyGattServiceArgs(
      myHashCode: myHashCode,
      myUUID: myUUID,
      myCharacteristicArgses: myCharacteristicArgses,
    );
  }
}

extension MyGattCharacteristicX on MyGattCharacteristic {
  MyGattCharacteristicArgs toMyArgs() {
    final myHashCode = hashCode;
    final myUUID = uuid.toString();
    final myPropertyNumbers = properties.map((property) {
      final myPropertyArgs = property.toMyArgs();
      return myPropertyArgs.index;
    }).toList();
    final myDescriptorArgses = descriptors
        .cast<MyGattDescriptor>()
        .map((myDescriptor) => myDescriptor.toMyArgs())
        .toList();
    return MyGattCharacteristicArgs(
      myHashCode: myHashCode,
      myUUID: myUUID,
      myPropertyNumbers: myPropertyNumbers,
      myDescriptorArgses: myDescriptorArgses,
    );
  }
}

extension MyGattDescriptorX on MyGattDescriptor {
  MyGattDescriptorArgs toMyArgs() {
    final myHashCode = hashCode;
    final myUUID = uuid.toString();
    final myValue = value;
    return MyGattDescriptorArgs(
      myHashCode: myHashCode,
      myUUID: myUUID,
      myValue: myValue,
    );
  }
}

extension GattCharacteristicPropertyX on GattCharacteristicProperty {
  MyGattCharacteristicPropertyArgs toMyArgs() {
    return MyGattCharacteristicPropertyArgs.values[index];
  }
}
