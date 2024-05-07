import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_low_energy_peer.dart';
import 'bluetooth_low_energy_state.dart';
import 'connection_state.dart';
import 'event_args.dart';

/// The bluetooth low energy state changed event arguments.
final class BluetoothLowEnergyStateChangedEventArgs extends EventArgs {
  /// The new state of the bluetooth low energy.
  final BluetoothLowEnergyState state;

  /// Constructs a [BluetoothLowEnergyStateChangedEventArgs].
  BluetoothLowEnergyStateChangedEventArgs(this.state);
}

/// The connection state cahnged event arguments.
final class ConnectionStateChangedEventArgs extends EventArgs {
  /// The peer which connection state changed.
  final BluetoothLowEnergyPeer peer;

  /// The state.
  final ConnectionState state;

  /// Constructs a [ConnectionStateChangedEventArgs].
  ConnectionStateChangedEventArgs(this.peer, this.state);
}

/// The peripheral MTU changed event arguments.
final class MTUChangedEventArgs extends EventArgs {
  /// The peer which MTU changed.
  final BluetoothLowEnergyPeer peer;

  /// The MTU.
  final int mtu;

  MTUChangedEventArgs(this.peer, this.mtu);
}

/// The abstract base class that manages central and peripheral objects.
abstract interface class BluetoothLowEnergyManager implements LogController {
  /// Gets the manager's state.
  BluetoothLowEnergyState get state;

  /// Tells the manager's state updated.
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged;

  /// Callback indicating the MTU for a given device connection has changed.
  ///
  /// This callback is triggered in response to the BluetoothGatt#requestMtu function,
  /// or in response to a connection event.
  ///
  /// This event is available on Android, throws [UnsupportedError] on other platforms.
  Stream<MTUChangedEventArgs> get mtuChanged;
}

/// The abstract base channel class that manages central and peripheral objects.
abstract base class BaseBluetoothLowEnergyManager extends PlatformInterface
    with TypeLogger, LoggerController
    implements BluetoothLowEnergyManager {
  /// Constructs a [BaseBluetoothLowEnergyManager].
  BaseBluetoothLowEnergyManager({
    required super.token,
  });

  /// Initializes the [BaseBluetoothLowEnergyManager].
  void initialize();
}
