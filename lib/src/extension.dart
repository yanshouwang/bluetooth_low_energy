part of bluetooth_low_energy;

extension on String {
  String get nameOfMAC {
    final upper = toUpperCase();
    final exp = RegExp(
      r'^[0-9A-F]{2}(:[0-9A-F]{2}){5}$',
      multiLine: true,
      caseSensitive: true,
    );
    if (exp.hasMatch(upper)) {
      return upper;
    }
    throw ArgumentError.value(this);
  }

  List<int> get valueOfMAC {
    final from = RegExp(r':');
    final encoded = replaceAll(from, '');
    return hex.decode(encoded);
  }

  String get nameOfUUID {
    final upper = toUpperCase();
    final exp0 = RegExp(
      r'[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$',
      multiLine: true,
      caseSensitive: true,
    );
    if (exp0.hasMatch(upper)) {
      return upper;
    }
    final exp1 = RegExp(
      r'^[0-9A-F]{4}$',
      multiLine: true,
      caseSensitive: true,
    );
    if (exp1.hasMatch(upper)) {
      return '0000$upper-0000-1000-8000-00805F9B34FB';
    }
    throw ArgumentError.value(this);
  }

  List<int> get valueOfUUID {
    final from = RegExp(r'-');
    final encoded = replaceAll(from, '');
    return hex.decode(encoded);
  }

  MAC get conversionOfMAC => MAC(this);

  UUID get conversionOfUUID => UUID(this);
}

extension on proto.BluetoothState {
  BluetoothState get conversion => BluetoothState.values[value];
}

extension on proto.Discovery {
  Discovery get conversion {
    final convertedAdvertisements = <int, List<int>>{};
    var start = 0;
    while (start < advertisements.length) {
      final length = advertisements[start++];
      if (length == 0) {
        break;
      }
      final end = start + length;
      final key = advertisements[start++];
      final value = advertisements.sublist(start, end);
      start = end;
      convertedAdvertisements[key] = value;
    }
    return Discovery(address.conversionOfMAC, rssi, convertedAdvertisements);
  }
}

extension on proto.GATT {
  GATT convert(MAC device) {
    final convertedServices = {
      for (var service in services)
        service.uuid.conversionOfUUID: service.convert(device)
    };
    return _GATT(device, mtu, convertedServices);
  }
}

extension on proto.GattService {
  GattService convert(MAC device) {
    final convertedUUID = uuid.conversionOfUUID;
    final convertedCharacteristics = {
      for (var characteristic in characteristics)
        characteristic.uuid.conversionOfUUID:
            characteristic.convert(device, convertedUUID)
    };
    return _GattService(
      device,
      convertedUUID,
      convertedCharacteristics,
    );
  }
}

extension on proto.GattCharacteristic {
  GattCharacteristic convert(MAC device, UUID service) {
    final convertedUUID = uuid.conversionOfUUID;
    final convertedDescriptors = {
      for (var descriptor in descriptors)
        descriptor.uuid.conversionOfUUID:
            descriptor.convert(device, service, convertedUUID)
    };
    return _GattCharacteristic(
      device,
      service,
      convertedUUID,
      convertedDescriptors,
      canRead,
      canWrite,
      canWriteWithoutResponse,
      canNotify,
    );
  }
}

extension on proto.GattDescriptor {
  GattDescriptor convert(MAC device, UUID service, UUID characteristic) {
    final convertedUUID = uuid.conversionOfUUID;
    return _GattDescriptor(
      device,
      service,
      characteristic,
      convertedUUID,
    );
  }
}

extension DiscoveryX on Discovery {
  String? get name {
    if (advertisements.containsKey(0x08)) {
      return utf8.decode(advertisements[0x08]!);
    } else if (advertisements.containsKey(0x09)) {
      return utf8.decode(advertisements[0x09]!);
    } else {
      return null;
    }
  }
}
