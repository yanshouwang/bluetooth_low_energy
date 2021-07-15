part of bluetooth_low_energy;

extension on String {
  String get uuidName {
    final lowerCase = toLowerCase();
    final exp0 = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    if (exp0.hasMatch(lowerCase)) {
      return lowerCase;
    }
    final exp1 = RegExp(
      r'^[0-9a-f]{4}$',
      caseSensitive: false,
    );
    if (exp1.hasMatch(lowerCase)) {
      return '0000$lowerCase-0000-1000-8000-00805f9b34fb';
    }
    throw ArgumentError.value(this);
  }

  List<int> get uuidVaue {
    final from = RegExp(r'-');
    final encoded = replaceAll(from, '');
    return hex.decode(encoded);
  }

  UUID get uuid => UUID(this);

  Exception get exceptoin => Exception(this);
}

extension on proto.BluetoothState {
  BluetoothState toState() => BluetoothState.values[value];
}

extension on proto.Discovery {
  Discovery toDiscovery() {
    final advertisements = <int, List<int>>{};
    var start = 0;
    while (start < this.advertisements.length) {
      final length = this.advertisements[start++];
      if (length == 0) break;
      final end = start + length;
      final key = this.advertisements[start++];
      final value = this.advertisements.sublist(start, end);
      start = end;
      advertisements[key] = value;
    }
    return _Discovery(uuid.uuid, rssi, advertisements, connectable);
  }
}

extension on proto.GATT {
  GATT toGATT() {
    final services = {
      for (var service in this.services)
        service.uuid.uuid: service.toGattService(key)
    };
    return _GATT(key, maximumWriteLength, services);
  }
}

extension on proto.GattService {
  GattService toGattService(String gattKey) {
    final uuid = this.uuid.uuid;
    final characteristics = {
      for (var characteristic in this.characteristics)
        characteristic.uuid.uuid: characteristic.toGattCharacteristic(
          gattKey,
          key,
        )
    };
    return _GattService(gattKey, key, uuid, characteristics);
  }
}

extension on proto.GattCharacteristic {
  GattCharacteristic toGattCharacteristic(String gattKey, String serviceKey) {
    final uuid = this.uuid.uuid;
    final descriptors = {
      for (var descriptor in this.descriptors)
        descriptor.uuid.uuid: descriptor.toGattDescriptor(
          gattKey,
          serviceKey,
          key,
        )
    };
    return _GattCharacteristic(
      gattKey,
      serviceKey,
      key,
      uuid,
      canRead,
      canWrite,
      canWriteWithoutResponse,
      canNotify,
      descriptors,
    );
  }
}

extension on proto.GattDescriptor {
  GattDescriptor toGattDescriptor(
    String gattKey,
    String serviceKey,
    String characteristicKey,
  ) {
    final uuid = this.uuid.uuid;
    return _GattDescriptor(gattKey, serviceKey, characteristicKey, key, uuid);
  }
}

/// TO BE DONE.
extension DiscoveryX on Discovery {
  /// TO BE DONE.
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
