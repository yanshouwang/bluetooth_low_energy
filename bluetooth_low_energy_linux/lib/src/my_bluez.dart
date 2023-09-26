import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

extension MyBlueZAdapter on BlueZAdapter {
  BluetoothLowEnergyState get state {
    return powered
        ? BluetoothLowEnergyState.poweredOn
        : BluetoothLowEnergyState.poweredOff;
  }
}

extension MyBlueZDevice on BlueZDevice {
  BlueZUUID get uuid {
    final node = address.replaceAll(':', '');
    // We don't know the timestamp of the bluetooth device, use nil UUID as prefix.
    return BlueZUUID.fromString("00000000-0000-0000-0000-$node");
  }

  Advertisement get advertisement {
    final name = this.name.isNotEmpty ? this.name : null;
    final manufacturerSpecificData = manufacturerData.map((key, value) {
      final id = key.id;
      final data = Uint8List.fromList(value);
      return MapEntry(id, data);
    });
    final serviceUUIDs = uuids.map((uuid) => uuid.toUUID()).toList();
    final serviceData = this.serviceData.map((uuid, data) {
      final key = uuid.toUUID();
      final value = Uint8List.fromList(data);
      return MapEntry(key, value);
    });
    return Advertisement(
      name: name,
      manufacturerSpecificData: manufacturerSpecificData,
      serviceUUIDs: serviceUUIDs,
      serviceData: serviceData,
    );
  }
}

extension MyBlueZUUID on BlueZUUID {
  UUID toUUID() => UUID(value);
}

extension MyBlueZGattCharacteristic on BlueZGattCharacteristic {
  List<GattCharacteristicProperty> get properties => flags
      .map((e) => e.toProperty())
      .whereType<GattCharacteristicProperty>()
      .toList();
}

extension MyBlueZGattCharacteristicFlag on BlueZGattCharacteristicFlag {
  GattCharacteristicProperty? toProperty() {
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

extension MyGattCharacteristicWriteType on GattCharacteristicWriteType {
  BlueZGattCharacteristicWriteType toBlueZ() {
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
