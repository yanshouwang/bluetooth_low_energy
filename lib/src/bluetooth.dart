import 'bluetooth_state.dart';

/// The abstract base class that manages central and peripheral objects.
abstract class Bluetooth {
  /// Get the bluetooth state.
  Future<BluetoothState> getState();

  /// A stream for bluetooth state changed event.
  Stream<BluetoothState> get stateChanged;
}
