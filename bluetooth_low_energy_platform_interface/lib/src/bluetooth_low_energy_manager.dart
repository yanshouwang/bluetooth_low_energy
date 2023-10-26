import 'bluetooth_low_energy_event_args.dart';
import 'bluetooth_low_energy_state.dart';
import 'logger_controller.dart';
import 'set_up.dart';

/// The abstract base class that manages central and peripheral objects.
abstract class BluetoothLowEnergyManager implements SetUp, LoggerController {
  /// The current state of the manager.
  BluetoothLowEnergyState get state;

  /// Tells the manager’s state updated.
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged;
}
