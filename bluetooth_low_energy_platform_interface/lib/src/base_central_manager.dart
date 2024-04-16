import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'base_bluetooth_low_energy_manager.dart';
import 'central_manager.dart';

/// Platform-specific implementations should implement this class to support [BaseCentralManager].
abstract base class BaseCentralManager extends BaseBluetoothLowEnergyManager
    implements CentralManager {
  static final Object _token = Object();

  static BaseCentralManager? _instance;

  /// The default instance of [BaseCentralManager] to use.
  static BaseCentralManager get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
          'CentralManager is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BaseCentralManager] when
  /// they register themselves.
  static set instance(BaseCentralManager instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Constructs a [BaseCentralManager].
  BaseCentralManager() : super(token: _token);
}
