part of bluetooth_low_energy;

final Central central = _Central();

/// An object that scans for, discovers, connects to, and manages peripherals.
abstract class Central extends Bluetooth {
  /// The central discovered a peripheral while scanning for devices.
  Stream<Discovery> get discovered;

  /// Start discover peripherals that are advertising services.
  Future startDiscovery({List<UUID>? services});

  /// Stop discover peripherals.
  Future stopDiscovery();

  /// Establishes a local connection to a peripheral.
  Future<GATT> connect(UUID uuid);
}

class _Central extends _Bluetooth implements Central {
  @override
  Stream<Discovery> get discovered => stream
      .where((message) =>
          message.category == proto.MessageCategory.CENTRAL_DISCOVERED)
      .map((message) => message.discovery.discovery);

  @override
  Future startDiscovery({List<UUID>? services}) {
    final message = proto.Message(
      category: proto.MessageCategory.CENTRAL_START_DISCOVERY,
      startDiscoveryArguments: proto.StartDiscoveryArguments(
        services: services?.map((uuid) => uuid.name),
      ),
    ).writeToBuffer();
    return method.invokeMethod('', message);
  }

  @override
  Future stopDiscovery() {
    final message = proto.Message(
      category: proto.MessageCategory.CENTRAL_STOP_DISCOVERY,
    ).writeToBuffer();
    return method.invokeMethod('', message);
  }

  @override
  Future<GATT> connect(UUID uuid) {
    final message = proto.Message(
      category: proto.MessageCategory.CENTRAL_CONNECT,
      connectArguments: proto.ConnectArguments(uuid: uuid.name),
    ).writeToBuffer();
    return method
        .invokeMethod<List<int>>('', message)
        .then((value) => proto.GATT.fromBuffer(value!).toGATT(uuid));
  }
}
