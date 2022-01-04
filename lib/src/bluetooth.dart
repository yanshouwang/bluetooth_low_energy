import 'bluetooth_state.dart';

/// The abstract base class that manages central and peripheral objects.
abstract class Bluetooth {
  /// A stream for bluetooth state changed event.
  Stream<BluetoothState> get stateChanged;

  /// Get the bluetooth state.
  Future<BluetoothState> getState();
}
