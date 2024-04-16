import 'package:hybrid_core/hybrid_core.dart';

import 'bluetooth_low_energy_state.dart';
import 'bluetooth_low_energy_state_changed_event_args.dart';

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
