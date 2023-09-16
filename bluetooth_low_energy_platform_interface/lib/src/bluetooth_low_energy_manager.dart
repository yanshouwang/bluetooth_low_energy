import 'bluetooth_low_energy_state.dart';
import 'event_args.dart';

/// The abstract base class that manages central and peripheral objects.
abstract class BluetoothLowEnergyManager {
  /// The current state of the manager.
  BluetoothLowEnergyState get state;

  /// Tells the manager’s state updated.
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged;
}
