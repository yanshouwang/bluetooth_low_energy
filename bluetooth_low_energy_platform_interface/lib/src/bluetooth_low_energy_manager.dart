import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_low_energy_state.dart';

/// The bluetooth low energy state changed event.
final class BluetoothLowEnergyStateChangedEvent {
  /// The new state of the bluetooth low energy.
  final BluetoothLowEnergyState state;

  /// Constructs a [BluetoothLowEnergyStateChangedEvent].
  BluetoothLowEnergyStateChangedEvent(this.state);
}

/// The name changed event.
final class NameChangedEvent {
  /// The name.
  final String? name;

  /// Constructs a [NameChangedEvent].
  NameChangedEvent(this.name);
}

/// The abstract base class that manages central and peripheral objects.
abstract base class BluetoothLowEnergyManager extends PlatformInterface
    implements LogController {
  static final _token = Object();

  BluetoothLowEnergyManager.impl() : super(token: _token);

  /// Tells the manager's state updated.
  Stream<BluetoothLowEnergyStateChangedEvent> get stateChanged;

  /// The local Bluetooth adapter has changed its friendly Bluetooth name.
  ///
  /// This name is visible to remote Bluetooth devices
  ///
  /// This field is available on Android, throws [UnsupportedError] on other
  /// platforms.
  Stream<NameChangedEvent> get nameChanged;

  Future<bool> shouldShowAuthorizeRationale();

  Future<bool> authorize();

  Future<void> showAppSettings();

  /// Gets the manager's state.
  Future<BluetoothLowEnergyState> getState();

  /// Get the friendly Bluetooth name of the local Bluetooth adapter.
  ///
  /// This name is visible to remote Bluetooth devices.
  ///
  /// This method is available on Android, throws [UnsupportedError] on other
  /// platforms.
  Future<String?> getName();

  /// Set the friendly Bluetooth name of the local Bluetooth adapter.
  ///
  /// This name is visible to remote Bluetooth devices.
  ///
  /// Valid Bluetooth names are a maximum of 248 bytes using UTF-8 encoding,
  /// although many remote devices can only display the first 40 characters, and
  /// some may be limited to just 20.
  ///
  /// If Bluetooth state is not STATE_ON, this API will return false. After turning
  /// on Bluetooth, wait for ACTION_STATE_CHANGED with STATE_ON to get the updated
  /// value.
  ///
  /// This method is available on Android, throws [UnsupportedError] on other
  /// platforms.
  Future<void> setName(String? name);

  /// Turn on the local Bluetooth adapter—do not use without explicit user action
  /// to turn on Bluetooth.
  ///
  /// This powers on the underlying Bluetooth hardware, and starts all Bluetooth
  /// system services.
  Future<void> turnOn();

  /// Turn off the local Bluetooth adapter—do not use without explicit user action
  /// to turn off Bluetooth.
  ///
  /// This gracefully shuts down all Bluetooth connections, stops Bluetooth system
  /// services, and powers down the underlying Bluetooth hardware.
  Future<void> turnOff();
}
