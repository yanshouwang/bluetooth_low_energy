import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'central_manager.dart';

abstract class BluetoothLowEnergy extends PlatformInterface {
  /// Constructs a BluetoothLowEnergy.
  BluetoothLowEnergy() : super(token: _token);

  static final Object _token = Object();

  static BluetoothLowEnergy? _instance;

  /// The default instance of [BluetoothLowEnergy] to use.
  static BluetoothLowEnergy get instance {
    final instance = _instance;
    if (instance == null) {
      const message =
          '`BluetoothLowEnergy` is not implemented on this platform.';
      throw UnimplementedError(message);
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BluetoothLowEnergy] when
  /// they register themselves.
  static set instance(BluetoothLowEnergy instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  CentralManager get centralManager;

  Future<void> initialize();
}
