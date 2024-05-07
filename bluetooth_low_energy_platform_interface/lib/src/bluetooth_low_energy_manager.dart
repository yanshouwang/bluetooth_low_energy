import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_low_energy_state.dart';
import 'event_args.dart';

/// The bluetooth low energy state changed event arguments.
final class BluetoothLowEnergyStateChangedEventArgs extends EventArgs {
  /// The new state of the bluetooth low energy.
  final BluetoothLowEnergyState state;

  /// Constructs a [BluetoothLowEnergyStateChangedEventArgs].
  BluetoothLowEnergyStateChangedEventArgs(this.state);
}

/// The abstract base class that manages central and peripheral objects.
abstract interface class BluetoothLowEnergyManager implements LogController {
  /// Tells the manager's state updated.
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged;

  /// Gets the manager's state.
  BluetoothLowEnergyState get state;
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
