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
  Future<GATT> connect(MAC address);
}

class _Central extends _Bluetooth implements Central {
  @override
  Stream<Discovery> get discovered => stream
      .map((event) => proto.Message.fromBuffer(event))
      .where((message) =>
          message.category == proto.MessageCategory.CENTRAL_DISCOVERED)
      .map((message) => message.discovery.conversion);

  @override
  Future startDiscovery({List<UUID>? services}) {
    final name = proto.MessageCategory.CENTRAL_START_DISCOVERY.name;
    final arguments = proto.StartDiscoveryArguments(
      services: services?.map((uuid) => uuid.name),
    ).writeToBuffer();
    return method.invokeMethod(name, arguments);
  }

  @override
  Future stopDiscovery() {
    final name = proto.MessageCategory.CENTRAL_STOP_DISCOVERY.name;
    return method.invokeMethod(name);
  }

  @override
  Future<GATT> connect(MAC address) {
    final name = proto.MessageCategory.CENTRAL_CONNECT.name;
    final arguments =
        proto.ConnectArguments(address: address.name).writeToBuffer();
    return method
        .invokeMethod<List<int>>(name, arguments)
        .then((value) => proto.GATT.fromBuffer(value!).convert(address));
  }
}
