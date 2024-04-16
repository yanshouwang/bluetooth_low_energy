import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'base_bluetooth_low_energy_manager.dart';
import 'peripheral_manager.dart';

/// Platform-specific implementations should implement this class to support [BasePeripheralManager].
abstract base class BasePeripheralManager extends BaseBluetoothLowEnergyManager
    implements PeripheralManager {
  static final Object _token = Object();

  static BasePeripheralManager? _instance;

  /// The default instance of [BasePeripheralManager] to use.
  static BasePeripheralManager get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
          'PeripheralManager is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BasePeripheralManager] when
  /// they register themselves.
  static set instance(BasePeripheralManager instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Constructs a [BasePeripheralManager].
  BasePeripheralManager() : super(token: _token);
}
