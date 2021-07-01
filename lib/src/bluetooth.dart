part of bluetooth_low_energy;

final Central central = _Central();

/// The abstract base class that manages central and peripheral objects.
abstract class Bluetooth {
  Future<bool> get available;

  /// The current state of the manager.
  Future<bool> get state;

  /// The central manager’s state changed.
  Stream<bool> get stateChanged;
}

class _Bluetooth implements Bluetooth {
  @override
  Future<bool> get available => method
      .invokeMethod<bool>(proto.MessageCategory.BLUETOOTH_AVAILABLE.name)
      .then((value) => value!);

  @override
  Future<bool> get state => method
      .invokeMethod<bool>(proto.MessageCategory.BLUETOOTH_STATE.name)
      .then((value) => value!);

  @override
  Stream<bool> get stateChanged => stream
      .map((event) => proto.Message.fromBuffer(event))
      .where((message) =>
          message.category == proto.MessageCategory.BLUETOOTH_STATE)
      .map((message) => message.state);
}

/// An object that scans for, discovers, connects to, and manages peripherals.
abstract class Central extends Bluetooth {
  /// The central manager discovered a peripheral while scanning for devices.
  Stream<Discovery> get discovered;

  /// Scans for peripherals that are advertising services.
  Future startDiscovery({List<UUID>? services});

  /// Asks the central manager to stop scanning for peripherals.
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
