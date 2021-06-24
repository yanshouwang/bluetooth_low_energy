part of bluetooth_low_energy;

final Central central = _Central();

/// The abstract base class that manages central and peripheral objects.
abstract class Bluetooth {
  /// The current state of the manager.
  Future<BluetoothState> get state;

  /// The central manager’s state changed.
  Stream<BluetoothState> get stateChanged;
}

class _Bluetooth implements Bluetooth {
  @override
  Future<BluetoothState> get state => method
      .invokeMethod<int>(proto.MessageCategory.BLUETOOTH_STATE.name)
      .then((value) => proto.BluetoothState.valueOf(value!)!.conversion);

  @override
  Stream<BluetoothState> get stateChanged => stream
      .map((event) => proto.Message.fromBuffer(event))
      .where((message) =>
          message.category == proto.MessageCategory.BLUETOOTH_STATE)
      .map((message) => message.state.conversion);
}

/// An object that scans for, discovers, connects to, and manages peripherals.
abstract class Central extends Bluetooth {
  Future<bool> get scanning;

  Stream<bool> get scanningChanged;

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
  Future<bool> get scanning => method
      .invokeMethod<bool>(proto.MessageCategory.CENTRAL_SCANNING.name)
      .then((value) => value!);

  @override
  Stream<bool> get scanningChanged => stream
      .map((event) => proto.Message.fromBuffer(event))
      .where((message) =>
          message.category == proto.MessageCategory.CENTRAL_SCANNING)
      .map((message) => message.scanning);

  @override
  Stream<Discovery> get discovered => stream
      .map((event) => proto.Message.fromBuffer(event))
      .where((message) =>
          message.category == proto.MessageCategory.CENTRAL_DISCOVERED)
      .map((message) => message.discovery.conversion);

  @override
  Future startDiscovery({List<UUID>? services}) => method.invokeMethod(
        proto.MessageCategory.CENTRAL_START_DISCOVERY.name,
        proto.DiscoveryArguments(
          services: services?.map((uuid) => uuid.name),
        ).writeToBuffer(),
      );

  @override
  Future stopDiscovery() =>
      method.invokeMethod(proto.MessageCategory.CENTRAL_STOP_DISCOVERY.name);

  @override
  Future<GATT> connect(MAC address) => method
      .invokeMethod<List<int>>(
          proto.MessageCategory.CENTRAL_CONNECT.name, address.name)
      .map((value) => );
}

/// The possible states of a bluetooth manager.
enum BluetoothState {
  /// The manager’s state is unknown.
  unknown,

  /// A state that indicates the connection with the system service was momentarily lost.
  resetting,

  /// A state that indicates this device doesn’t support the bluetooth low energy central or client role.
  unsupported,

  /// A state that indicates the application isn’t authorized to use the bluetooth low energy role.
  unauthorized,

  /// A state that indicates bluetooth is currently powered off.
  poweredOff,

  /// A state that indicates bluetooth is currently powered on and available to use.
  poweredOn,
}
