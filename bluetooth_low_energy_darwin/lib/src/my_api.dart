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
      manufacturerSpecificData: manufacturerSpecificData.cast<int, Uint8List>(),
      serviceUUIDs: serviceUUIDs,
      serviceData: serviceData,
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
  MyGattCharacteristicWriteTypeArgs toMyArgs() {
    return MyGattCharacteristicWriteTypeArgs.values[index];
  }
}
