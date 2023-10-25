import 'bluetooth_low_energy_state.dart';

/// The base event arguments.
abstract class EventArgs {}

/// The bluetooth low energy state changed event arguments.
class BluetoothLowEnergyStateChangedEventArgs extends EventArgs {
  /// The new state of the bluetooth low energy.
  final BluetoothLowEnergyState state;

  /// Constructs a [BluetoothLowEnergyStateChangedEventArgs].
  BluetoothLowEnergyStateChangedEventArgs(this.state);
}
