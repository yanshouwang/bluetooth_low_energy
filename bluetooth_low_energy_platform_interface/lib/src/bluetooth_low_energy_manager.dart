import 'package:log_service/log_service.dart';

import 'bluetooth_low_energy_event_args.dart';
import 'bluetooth_low_energy_state.dart';

/// The abstract base class that manages central and peripheral objects.
abstract class BluetoothLowEnergyManager implements LogController {
  /// The current state of the manager.
  BluetoothLowEnergyState get state;

  /// Tells the manager’s state updated.
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged;

  /// Sets up the manager.
  Future<void> setUp();
}
