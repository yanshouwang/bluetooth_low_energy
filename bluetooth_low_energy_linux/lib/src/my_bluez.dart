import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_gatt_characteristic2.dart';
import 'my_gatt_descriptor2.dart';
import 'my_gatt_service2.dart';

extension BlueZAdapterX on BlueZAdapter {
  BluetoothLowEnergyState get myState {
    return powered
        ? BluetoothLowEnergyState.poweredOn
        : BluetoothLowEnergyState.poweredOff;
  }
}

extension BlueZDeviceX on BlueZDevice {
  BlueZUUID get uuid {
    final node = address.replaceAll(':', '');
    // We don't know the timestamp of the bluetooth device, use nil UUID as prefix.
    return BlueZUUID.fromString("00000000-0000-0000-0000-$node");
  }

  UUID get myUUID => uuid.toMyUUID();

  List<MyGattService2> get myServices =>
      gattServices.map((service) => MyGattService2(service)).toList();

  Advertisement get myAdvertisement {
    final myName = name.isNotEmpty ? name : null;
    final myServiceUUIDs = uuids.map((uuid) => uuid.toMyUUID()).toList();
    final myServiceData = serviceData.map((uuid, data) {
      final myUUID = uuid.toMyUUID();
      final myData = Uint8List.fromList(data);
      return MapEntry(myUUID, myData);
    });
    return Advertisement(
      name: myName,
      manufacturerSpecificData: myManufacturerSpecificData,
      serviceUUIDs: myServiceUUIDs,
      serviceData: myServiceData,
    );
  }

  ManufacturerSpecificData get myManufacturerSpecificData {
    final entry = manufacturerData.entries.last;
    final myId = entry.key.id;
    final myData = Uint8List.fromList(entry.value);
    return ManufacturerSpecificData(
      id: myId,
      data: myData,
    );
  }
}

extension BlueZGattServiceX on BlueZGattService {
  UUID get myUUID => uuid.toMyUUID();

  List<MyGattCharacteristic2> get myCharacteristics => characteristics
      .map((characteristic) => MyGattCharacteristic2(characteristic))
      .toList();
}

extension MyBlueZGattCharacteristic on BlueZGattCharacteristic {
  UUID get myUUID => uuid.toMyUUID();

  List<GattCharacteristicProperty> get myProperties => flags
      .map((e) => e.toMyProperty())
      .whereType<GattCharacteristicProperty>()
      .toList();

  List<MyGattDescriptor2> get myDescriptors =>
      descriptors.map((descriptor) => MyGattDescriptor2(descriptor)).toList();
}

extension BlueZGattDescriptorX on BlueZGattDescriptor {
  UUID get myUUID => uuid.toMyUUID();
}

extension BlueZUUIDX on BlueZUUID {
  UUID toMyUUID() => UUID(value);
}

extension BlueZGattCharacteristicFlagX on BlueZGattCharacteristicFlag {
  GattCharacteristicProperty? toMyProperty() {
    switch (this) {
      case BlueZGattCharacteristicFlag.read:
        return GattCharacteristicProperty.read;
      case BlueZGattCharacteristicFlag.write:
        return GattCharacteristicProperty.write;
      case BlueZGattCharacteristicFlag.writeWithoutResponse:
        return GattCharacteristicProperty.writeWithoutResponse;
      case BlueZGattCharacteristicFlag.notify:
        return GattCharacteristicProperty.notify;
      case BlueZGattCharacteristicFlag.indicate:
        return GattCharacteristicProperty.indicate;
      default:
        return null;
    }
  }
}

extension GattCharacteristicWriteTypeX on GattCharacteristicWriteType {
  BlueZGattCharacteristicWriteType toBlueZWriteType() {
    switch (this) {
      case GattCharacteristicWriteType.withResponse:
        return BlueZGattCharacteristicWriteType.request;
      case GattCharacteristicWriteType.withoutResponse:
        return BlueZGattCharacteristicWriteType.command;
      default:
        throw UnimplementedError();
    }
  }
}
