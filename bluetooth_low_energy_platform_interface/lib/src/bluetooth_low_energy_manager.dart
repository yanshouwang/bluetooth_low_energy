import 'bluetooth_low_energy_state.dart';
import 'event_args.dart';

/// The abstract base class that manages central and peripheral objects.
abstract interface class BluetoothLowEnergyManager {
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
