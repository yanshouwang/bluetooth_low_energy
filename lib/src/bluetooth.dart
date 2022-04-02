import 'bluetooth_state.dart';

/// The abstract base class that manages central and peripheral objects.
abstract class Bluetooth {
  /// Only worked on Android, iOS will do this when the app run for the first time after declare necessary keys in the info.plist
  Future<void> authorize();

  /// Get the bluetooth state.
  Future<BluetoothState> getState();

  /// A stream for bluetooth state changed event.
  Stream<BluetoothState> get stateChanged;
}
