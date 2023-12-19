import 'package:log_service/log_service.dart';

import 'bluetooth_low_energy_event_args.dart';
import 'bluetooth_low_energy_state.dart';

/// The abstract base class that manages central and peripheral objects.
abstract class BluetoothLowEnergyManager implements LogController {
  /// Tells the manager's state updated.
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged;

  /// Sets up the manager.
  Future<void> setUp();

  /// Gets the manager's state.
  Future<BluetoothLowEnergyState> getState();
}
