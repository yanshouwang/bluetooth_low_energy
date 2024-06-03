import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_gatt.dart';

extension BlueZUUIDX on BlueZUUID {
  UUID toMyUUID() => UUID(value);
}

extension BlueZGattCharacteristicFlagX on BlueZGattCharacteristicFlag {
  GATTCharacteristicProperty? toMyProperty() {
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
  BluetoothLowEnergyState get myState {
    return powered
        ? BluetoothLowEnergyState.poweredOn
        : BluetoothLowEnergyState.poweredOff;
  }
}

extension BlueZDeviceX on BlueZDevice {
  UUID get myUUID => UUID.fromAddress(address);

  List<MyGATTService> get myServices =>
      gattServices.map((service) => MyGATTService(service)).toList();

  Advertisement get myAdvertisement {
    return Advertisement(
      name: name.isEmpty ? null : name,
      serviceUUIDs: uuids.map((uuid) => uuid.toMyUUID()).toList(),
      serviceData: serviceData.map((uuid, data) {
        final myUUID = uuid.toMyUUID();
        final myData = Uint8List.fromList(data);
        return MapEntry(myUUID, myData);
      }),
      manufacturerSpecificData: manufacturerData.entries.map((entry) {
        final myId = entry.key.id;
        final myData = Uint8List.fromList(entry.value);
        return ManufacturerSpecificData(
          id: myId,
          data: myData,
        );
      }).toList(),
    );
  }
}

extension BlueZGattDescriptorX on BlueZGattDescriptor {
  UUID get myUUID => uuid.toMyUUID();
}

extension MyBlueZGattCharacteristic on BlueZGattCharacteristic {
  UUID get myUUID => uuid.toMyUUID();

  List<GATTCharacteristicProperty> get myProperties => flags
      .map((e) => e.toMyProperty())
      .whereType<GATTCharacteristicProperty>()
      .toList();

  List<MyGATTDescriptor> get myDescriptors =>
      descriptors.map((descriptor) => MyGATTDescriptor(descriptor)).toList();
}

extension BlueZGattServiceX on BlueZGattService {
  UUID get myUUID => uuid.toMyUUID();

  List<MyGATTCharacteristic> get myCharacteristics => characteristics
      .map((characteristic) => MyGATTCharacteristic(characteristic))
      .toList();
}
