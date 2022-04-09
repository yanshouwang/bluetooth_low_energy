import 'bluetooth_state.dart';
import 'event_subscription.dart';

/// The abstract base class that manages central and peripheral objects.
abstract class Bluetooth {
  /// Only worked on Android, iOS will do this when the app run for the first time after declare necessary keys in the info.plist
  Future<void> authorize();

  /// Get the bluetooth state.
  Future<BluetoothState> getState();

  /// Listen bluetooth state changed event.
  Future<EventSubscription> subscribeStateChanged({
    required void Function(BluetoothState state) onStateChanged,
  });
}
