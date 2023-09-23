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

extension MyGattCharacteristicPropertyArgsX
    on MyGattCharacteristicPropertyArgs {
  GattCharacteristicProperty toProperty() {
    return GattCharacteristicProperty.values[index];
  }
}

extension GattCharacteristicPropertyX on GattCharacteristicProperty {
  MyGattCharacteristicPropertyArgs toMyArgs() {
    return MyGattCharacteristicPropertyArgs.values[index];
  }
}

extension GattCharacteristicWriteTypeX on GattCharacteristicWriteType {
  MyGattCharacteristicWriteTypeArgs toMyArgs() {
    return MyGattCharacteristicWriteTypeArgs.values[index];
  }
}

extension CustomizedGattServiceX on CustomizedGattService {
  MyCustomizedGattServiceArgs toMyArgs() {
    final myKey = hashCode;
    final myUUID = uuid.toString();
    final myCharacteristicArgses = characteristics
        .cast<CustomizedGattCharacteristic>()
        .map((characteristic) => characteristic.toMyArgs())
        .toList();
    return MyCustomizedGattServiceArgs(
      myKey: myKey,
      myUUID: myUUID,
      myCharacteristicArgses: myCharacteristicArgses,
    );
  }
}

extension CustomizedGattCharacteristicX on CustomizedGattCharacteristic {
  MyCustomizedGattCharacteristicArgs toMyArgs() {
    final myKey = hashCode;
    final myUUID = uuid.toString();
    final myDescriptorArgses = descriptors
        .cast<CustomizedGattDescriptor>()
        .map((descriptor) => descriptor.toMyArgs())
        .toList();
    final myPropertyNumbers = properties.map((property) {
      final myPropertyArgs = property.toMyArgs();
      return myPropertyArgs.index;
    }).toList();
    return MyCustomizedGattCharacteristicArgs(
      myKey: myKey,
      myUUID: myUUID,
      myDescriptorArgses: myDescriptorArgses,
      myPropertyNumbers: myPropertyNumbers,
    );
  }
}

extension CustomizedGattDescriptorX on CustomizedGattDescriptor {
  MyCustomizedGattDescriptorArgs toMyArgs() {
    final myKey = hashCode;
    final myUUID = uuid.toString();
    final myValue = value;
    return MyCustomizedGattDescriptorArgs(
      myKey: myKey,
      myUUID: myUUID,
      myValue: myValue,
    );
  }
}
