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
  /// Gets the manager's state.
  BluetoothLowEnergyState get state;

  /// Tells the manager's state updated.
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged;

  /// Requests permissions to be granted to this application. These permissions
  /// must be requested in your manifest, they should not be granted to your app,
  /// and they should have protection level dangerous, regardless whether they
  /// are declared by the platform or a third-party app.
  ///
  /// This method is available on Android, throws [UnsupportedError] on other
  /// platforms.
  Future<bool> authorize();

  /// Show screen of details about a particular application.
  ///
  /// This method is available on Android and iOS, throws [UnsupportedError] on
  /// other platforms.
  Future<void> showAppSettings();
}

/// The abstract base channel class that manages central and peripheral objects.
abstract base class PlatformBluetoothLowEnergyManager extends PlatformInterface
    with TypeLogger, LoggerController
    implements BluetoothLowEnergyManager {
  /// Constructs a [PlatformBluetoothLowEnergyManager].
  PlatformBluetoothLowEnergyManager({
    required super.token,
  });

  /// Initializes the [PlatformBluetoothLowEnergyManager].
  void initialize();
}
