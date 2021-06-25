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
  Discovery get conversion =>
      Discovery(address.conversionOfMAC, rssi, advertisements);
}

extension on proto.GATT {
  GATT convert(MAC address) {
    final convertedServices =
        services.map((service) => service.conversion).toList();
    return _GATT(address, mtu, convertedServices);
  }
}

extension on proto.GattService {
  GattService get conversion {
    final convertedCharacteristics = characteristics
        .map((characteristic) => characteristic.conversion)
        .toList();
    return _GattService(uuid.conversionOfUUID, convertedCharacteristics);
  }
}

extension on proto.GattCharacteristic {
  GattCharacteristic get conversion {
    final convertedDescriptors =
        descriptors.map((descriptor) => descriptor.conversion).toList();
    return _GattCharacteristic(
      uuid.conversionOfUUID,
      convertedDescriptors,
      canRead,
      canWrite,
      canWriteWithoutResponse,
      canNotify,
    );
  }
}

extension on proto.GattDescriptor {
  GattDescriptor get conversion => _GattDescriptor(uuid.conversionOfUUID);
}
