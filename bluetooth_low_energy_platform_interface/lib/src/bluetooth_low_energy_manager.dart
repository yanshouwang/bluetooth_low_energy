import 'package:hybrid_core/hybrid_core.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_low_energy_state.dart';
import 'event_args.dart';

/// The abstract base class that manages central and peripheral objects.
abstract interface class BluetoothLowEnergyManager implements LogController {
  /// Tells the manager's state updated.
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged;

  /// Gets the manager's state.
  Future<BluetoothLowEnergyState> getState();

  /// Authorizes the [BluetoothLowEnergyManager].
  ///
  /// This method is only available on Android, throws [UnsupportedError] on other platforms.
  Future<void> authorize();
}

/// The bluetooth low energy state changed event arguments.
base class BluetoothLowEnergyStateChangedEventArgs extends EventArgs {
  /// The new state of the bluetooth low energy.
  final BluetoothLowEnergyState state;

  /// Constructs a [BluetoothLowEnergyStateChangedEventArgs].
  BluetoothLowEnergyStateChangedEventArgs(this.state);
}

/// The abstract base channel class that manages central and peripheral objects.
abstract base class BaseBluetoothLowEnergyManager extends PlatformInterface
    with LoggerProvider, LoggerController
    implements BluetoothLowEnergyManager {
  /// Constructs a [BaseBluetoothLowEnergyManager].
  BaseBluetoothLowEnergyManager({
    required super.token,
  });

  /// Initializes the [BaseBluetoothLowEnergyManager].
  void initialize();
}
