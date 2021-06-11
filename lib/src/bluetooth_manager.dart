import 'bluetooth.dart';
import 'channel.dart';
import 'discovery.dart';
import 'exception.dart';
import 'mac.dart';
import 'message.pb.dart' as proto;
import 'uuid.dart';

/// The abstract base class that manages central and peripheral objects.
abstract class BluetoothManager {
  /// The current state of the manager.
  Future<BluetoothManagerState> get state;

  /// The central manager’s state changed.
  Stream<BluetoothManagerState> get stateChanged;

  factory BluetoothManager() => _BluetoothManager();
}

class _BluetoothManager implements BluetoothManager {
  @override
  Future<BluetoothManagerState> get state => method
      .invokeMethod<int>(proto.MessageCategory.BLUETOOTH_MANAGER_STATE.name)
      .then((value) => proto.BluetoothManagerState.valueOf(value!)!.conversion);

  @override
  Stream<BluetoothManagerState> get stateChanged => stream
      .map((event) => proto.Message.fromBuffer(event))
      .where((message) =>
          message.category == proto.MessageCategory.BLUETOOTH_MANAGER_STATE)
      .map((message) => message.state.conversion);
}

/// An object that scans for, discovers, connects to, and manages peripherals.
abstract class CentralManager extends BluetoothManager {
  /// The central manager discovered a peripheral while scanning for devices.
  Stream<Discovery> get discovered;

  /// The central manager disconnected from a peripheral.
  Stream<ConnectionLostException> get connectionLost;

  /// Establishes a local connection to a peripheral.
  Future connect(Peripheral peripheral);

  /// Cancels an active or pending local connection to a peripheral.
  Future disconnect(Peripheral peripheral);

  /// Scans for peripherals that are advertising services.
  Future startDiscovery({List<UUID>? services});

  /// Asks the central manager to stop scanning for peripherals.
  Future stopDiscovery();

  factory CentralManager() => _CentralManager();
}

class _CentralManager extends _BluetoothManager implements CentralManager {
  @override
  Stream<Discovery> get discovered => stream
      .map((event) => proto.Message.fromBuffer(event))
      .where((message) =>
          message.category == proto.MessageCategory.CENTRAL_MANAGER_DISCOVERED)
      .map((message) => message.discovery.conversion);

  @override
  // TODO: implement connectionLost
  Stream<ConnectionLostException> get connectionLost =>
      throw UnimplementedError();

  @override
  Future startDiscovery({List<UUID>? services}) => method.invokeMethod(
      proto.MessageCategory.CENTRAL_MANAGER_START_DISCOVERY.name,
      services?.map((uuid) => uuid.value).toList());

  @override
  Future stopDiscovery() => method
      .invokeMethod(proto.MessageCategory.CENTRAL_MANAGER_STOP_DISCOVERY.name);

  @override
  Future connect(Peripheral peripheral) {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future disconnect(Peripheral peripheral) {
    // TODO: implement disconnect
    throw UnimplementedError();
  }
}

/// The possible states of a bluetooth manager.
enum BluetoothManagerState {
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

/// The current authorization state of a bluetooth manager.
enum BluetoothManagerAuthorization {
  /// A state that indicates the user has yet to authorize bluetooth for this app.
  notDetermined,

  /// A state that indicates this app isn’t authorized to use Bluetooth.
  restricted,

  /// A state that indicates the user explicitly denied bluetooth access for this app.
  denied,

  /// A state that indicates the user has authorized bluetooth at any time.
  allowedAlways,
}

extension on proto.BluetoothManagerState {
  BluetoothManagerState get conversion => BluetoothManagerState.values[value];
}

extension on proto.Discovery {
  Discovery get conversion =>
      Discovery(address.conversion, rssi, advertisements);
}

extension on String {
  MAC get conversion => MAC(this);
}
