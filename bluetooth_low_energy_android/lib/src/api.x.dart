import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'api.g.dart';
import 'impl.dart';

extension ConnectionPriorityX on ConnectionPriority {
  ConnectionPriorityApi get api {
    switch (this) {
      case ConnectionPriority.balanced:
        return ConnectionPriorityApi.balanced;
      case ConnectionPriority.high:
        return ConnectionPriorityApi.high;
      case ConnectionPriority.lowPower:
        return ConnectionPriorityApi.lowPower;
      case ConnectionPriority.dck:
        return ConnectionPriorityApi.dck;
    }
  }
}

extension GATTCharacteristicWriteTypeX on GATTCharacteristicWriteType {
  GATTCharacteristicWriteTypeApi get api {
    switch (this) {
      case GATTCharacteristicWriteType.withResponse:
        return GATTCharacteristicWriteTypeApi.withResponse;
      case GATTCharacteristicWriteType.withoutResponse:
        return GATTCharacteristicWriteTypeApi.withoutResponse;
    }
  }
}

extension BluetoothLowEnergyStateApiX on BluetoothLowEnergyStateApi {
  BluetoothLowEnergyState get impl {
    switch (this) {
      case BluetoothLowEnergyStateApi.unknown:
        return BluetoothLowEnergyState.unknown;
      case BluetoothLowEnergyStateApi.unsupported:
        return BluetoothLowEnergyState.unsupported;
      case BluetoothLowEnergyStateApi.unauthorized:
        return BluetoothLowEnergyState.unauthorized;
      case BluetoothLowEnergyStateApi.off:
        return BluetoothLowEnergyState.off;
      case BluetoothLowEnergyStateApi.turningOn:
        return BluetoothLowEnergyState.turningOn;
      case BluetoothLowEnergyStateApi.on:
        return BluetoothLowEnergyState.on;
      case BluetoothLowEnergyStateApi.turningOff:
        return BluetoothLowEnergyState.turningOff;
    }
  }
}

extension AdvertisementApiX on AdvertisementApi {
  Advertisement get impl {
    return Advertisement(
      name: name,
      serviceUUIDs: serviceUUIDs.map((e) => UUID.fromString(e)).toList(),
      serviceData: {
        for (var entry in serviceData.entries)
          UUID.fromString(entry.key): Uint8List.fromList(entry.value)
      },
      manufacturerSpecificData:
          manufacturerSpecificData.map((e) => e.impl).toList(),
    );
  }
}

extension ManufacturerSpecificDataApiX on ManufacturerSpecificDataApi {
  ManufacturerSpecificData get impl {
    return ManufacturerSpecificData(
      id: id,
      data: Uint8List.fromList(data),
    );
  }
}

extension ConnectionStateApiX on ConnectionStateApi {
  ConnectionState get impl {
    switch (this) {
      case ConnectionStateApi.disconnected:
        return ConnectionState.disconnected;
      case ConnectionStateApi.connecting:
        return ConnectionState.connecting;
      case ConnectionStateApi.connected:
        return ConnectionState.connected;
      case ConnectionStateApi.disconnecting:
        return ConnectionState.disconnecting;
    }
  }
}

extension PeripheralApiX on PeripheralApi {
  PeripheralImpl get impl {
    return PeripheralImpl(
      address: address,
    );
  }
}

extension GATTDescriptorApiX on GATTDescriptorApi {
  GATTDescriptorImpl get impl {
    return GATTDescriptorImpl(
      id: id,
      uuid: UUID.fromString(uuid),
    );
  }
}

extension GATTCharacteristicApiX on GATTCharacteristicApi {
  GATTCharacteristicImpl get impl {
    return GATTCharacteristicImpl(
      id: id,
      uuid: UUID.fromString(uuid),
      properties: properties.map((e) => e.impl).toList(),
      descriptors: descriptors.map((e) => e.impl).toList(),
    );
  }
}

extension GATTServiceApiX on GATTServiceApi {
  GATTServiceImpl get impl {
    return GATTServiceImpl(
      id: id,
      uuid: UUID.fromString(uuid),
      isPrimary: isPrimary,
      includedServices: includedServices.map((e) => e.impl).toList(),
      characteristics: characteristics.map((e) => e.impl).toList(),
    );
  }
}

extension GATTCharacteristicPropertyApiX on GATTCharacteristicPropertyApi {
  GATTCharacteristicProperty get impl {
    switch (this) {
      case GATTCharacteristicPropertyApi.read:
        return GATTCharacteristicProperty.read;
      case GATTCharacteristicPropertyApi.write:
        return GATTCharacteristicProperty.write;
      case GATTCharacteristicPropertyApi.writeWithoutResponse:
        return GATTCharacteristicProperty.writeWithoutResponse;
      case GATTCharacteristicPropertyApi.notify:
        return GATTCharacteristicProperty.notify;
      case GATTCharacteristicPropertyApi.indicate:
        return GATTCharacteristicProperty.indicate;
    }
  }
}
