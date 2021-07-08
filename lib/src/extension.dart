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
}

extension on proto.Discovery {
  Discovery get discovery {
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
  GATT toGATT(UUID uuid) {
    final services = {
      for (var service in this.services)
        service.uuid.uuid: service.toGattService(uuid)
    };
    return _GATT(uuid, id, mtu, services);
  }
}

extension on proto.GattService {
  GattService toGattService(UUID deviceUUID) {
    final uuid = this.uuid.uuid;
    final characteristics = {
      for (var characteristic in this.characteristics)
        characteristic.uuid.uuid:
            characteristic.toGattCharacteristic(deviceUUID, uuid)
    };
    return _GattService(
      deviceUUID,
      id,
      uuid,
      characteristics,
    );
  }
}

extension on proto.GattCharacteristic {
  GattCharacteristic toGattCharacteristic(UUID deviceUUID, UUID serviceUUID) {
    final uuid = this.uuid.uuid;
    final descriptors = {
      for (var descriptor in this.descriptors)
        descriptor.uuid.uuid:
            descriptor.toGattDescriptor(deviceUUID, serviceUUID, uuid)
    };
    return _GattCharacteristic(
      deviceUUID,
      serviceUUID,
      id,
      uuid,
      descriptors,
      canRead,
      canWrite,
      canWriteWithoutResponse,
      canNotify,
    );
  }
}

extension on proto.GattDescriptor {
  GattDescriptor toGattDescriptor(
      UUID deviceUUID, UUID serviceUUID, UUID characteristicUUID) {
    final uuid = this.uuid.uuid;
    return _GattDescriptor(
      deviceUUID,
      serviceUUID,
      characteristicUUID,
      id,
      uuid,
    );
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
