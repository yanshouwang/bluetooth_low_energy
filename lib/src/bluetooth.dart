import 'gatt.dart';
import 'discovery.dart';
import 'mac.dart';
import 'message.pb.dart' as proto;
import 'util.dart';
import 'uuid.dart';

/// The abstract base class that manages central and peripheral objects.
abstract class Bluetooth {
  /// The current state of the manager.
  Future<BluetoothState> get state;

  /// The central manager’s state changed.
  Stream<BluetoothState> get stateChanged;

  factory Bluetooth() => _Bluetooth();
}

class _Bluetooth implements Bluetooth {
  final stream = event.receiveBroadcastStream();

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

  /// The central manager discovered a peripheral while scanning for devices.
  Stream<Discovery> get discovered;

  /// Scans for peripherals that are advertising services.
  Future startDiscovery({List<UUID>? services});

  /// Asks the central manager to stop scanning for peripherals.
  Future stopDiscovery();

  /// Establishes a local connection to a peripheral.
  Future<GATT> connect(MAC address);

  factory Central() => _Central();
}

class _Central extends _Bluetooth implements Central {
  @override
  Future<bool> get scanning => method
      .invokeMethod<bool>(proto.MessageCategory.CENTRAL_SCANNING.name)
      .then((value) => value!);

  @override
  Stream<Discovery> get discovered => stream
      .map((event) => proto.Message.fromBuffer(event))
      .where((message) =>
          message.category == proto.MessageCategory.CENTRAL_DISCOVERED)
      .map((message) => message.discovery.conversion);

  @override
  Future startDiscovery({List<UUID>? services}) => method.invokeMethod(
        proto.MessageCategory.CENTRAL_START_DISCOVERY.name,
        proto.DiscoverArguments(
          services: services?.map((uuid) => uuid.name),
        ).writeToBuffer(),
      );

  @override
  Future stopDiscovery() =>
      method.invokeMethod(proto.MessageCategory.CENTRAL_STOP_DISCOVERY.name);

  @override
  Future<GATT> connect(MAC address) {
    // TODO: implement connect
    throw UnimplementedError();
  }
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

extension on proto.BluetoothState {
  BluetoothState get conversion => BluetoothState.values[value];
}

extension on proto.Discovery {
  Discovery get conversion =>
      Discovery(address.conversion, rssi, advertisements);
}

extension on String {
  MAC get conversion => MAC(this);
}
