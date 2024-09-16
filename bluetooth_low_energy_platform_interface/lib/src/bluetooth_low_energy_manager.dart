import 'package:hybrid_logging/hybrid_logging.dart';

import 'bluetooth_low_energy_state.dart';
import 'event_args.dart';

/// The bluetooth low energy state changed event arguments.
final class BluetoothLowEnergyStateChangedEventArgs extends EventArgs {
  /// The new state of the bluetooth low energy.
  final BluetoothLowEnergyState state;

  /// Constructs a [BluetoothLowEnergyStateChangedEventArgs].
  BluetoothLowEnergyStateChangedEventArgs(this.state);
}

/// The name changed event arguments.
final class NameChangedEventArgs extends EventArgs {
  /// The name.
  final String name;

  /// Constructs a [NameChangedEventArgs].
  NameChangedEventArgs(this.name);
}

/// The abstract base class that manages central and peripheral objects.
abstract interface class BluetoothLowEnergyManager implements LogController {
  /// Gets the manager's state.
  BluetoothLowEnergyState get state;

  /// Tells the manager's state updated.
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged;

  /// The local Bluetooth adapter has changed its friendly Bluetooth name.
  ///
  /// This name is visible to remote Bluetooth devices
  ///
  /// This field is available on Android, throws [UnsupportedError] on other
  /// platforms.
  Stream<NameChangedEventArgs> get nameChanged;

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

  /// Get the friendly Bluetooth name of the local Bluetooth adapter.
  ///
  /// This name is visible to remote Bluetooth devices.
  ///
  /// This method is available on Android, throws [UnsupportedError] on other
  /// platforms.
  Future<String> getName();

  /// Set the friendly Bluetooth name of the local Bluetooth adapter.
  ///
  /// This name is visible to remote Bluetooth devices.
  ///
  /// Valid Bluetooth names are a maximum of 248 bytes using UTF-8 encoding,
  /// although many remote devices can only display the first 40 characters, and
  /// some may be limited to just 20.
  ///
  /// If Bluetooth state is not STATE_ON, this API will return false. After turning
  /// on Bluetooth, wait for ACTION_STATE_CHANGED with STATE_ON to get the updated
  /// value.
  ///
  /// This method is available on Android, throws [UnsupportedError] on other
  /// platforms.
  Future<void> setName(String name);
}
