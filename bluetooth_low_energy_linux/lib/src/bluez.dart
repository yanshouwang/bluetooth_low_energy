import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

extension BlueZUUIDX on BlueZUUID {
  UUID toUUID() => UUID(value);
}

extension BlueZGattCharacteristicFlagX on BlueZGattCharacteristicFlag {
  GATTCharacteristicProperty? toProperty() {
    switch (this) {
      case BlueZGattCharacteristicFlag.read:
        return GATTCharacteristicProperty.read;
      case BlueZGattCharacteristicFlag.write:
        return GATTCharacteristicProperty.write;
      case BlueZGattCharacteristicFlag.writeWithoutResponse:
        return GATTCharacteristicProperty.writeWithoutResponse;
      case BlueZGattCharacteristicFlag.notify:
        return GATTCharacteristicProperty.notify;
      case BlueZGattCharacteristicFlag.indicate:
        return GATTCharacteristicProperty.indicate;
      default:
        return null;
    }
  }
}

extension GattCharacteristicWriteTypeX on GATTCharacteristicWriteType {
  BlueZGattCharacteristicWriteType toBlueZWriteType() {
    switch (this) {
      case GATTCharacteristicWriteType.withResponse:
        return BlueZGattCharacteristicWriteType.request;
      case GATTCharacteristicWriteType.withoutResponse:
        return BlueZGattCharacteristicWriteType.command;
    }
  }
}

extension BlueZAdapterX on BlueZAdapter {
  BluetoothLowEnergyState get state {
    return powered
        ? BluetoothLowEnergyState.poweredOn
        : BluetoothLowEnergyState.poweredOff;
  }
}

extension BlueZDeviceX on BlueZDevice {
  Advertisement get advertisement {
    return Advertisement(
      name: name.isEmpty ? null : name,
      serviceUUIDs: uuids.map((uuid) => uuid.toUUID()).toList(),
      serviceData: serviceData.map((uuid, data) {
        final myUUID = uuid.toUUID();
        final myData = Uint8List.fromList(data);
        return MapEntry(myUUID, myData);
      }),
      manufacturerSpecificData:
          manufacturerData.entries.map((entry) {
            final myId = entry.key.id;
            final myData = Uint8List.fromList(entry.value);
            return ManufacturerSpecificData(id: myId, data: myData);
          }).toList(),
    );
  }
}
