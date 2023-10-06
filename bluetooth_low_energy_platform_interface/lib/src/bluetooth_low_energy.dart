import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'central_manager.dart';
import 'peripheral_manager.dart';

/// The bluetooth low energy interface.
///
/// Call `setUp` before use any api.
abstract class BluetoothLowEnergy extends PlatformInterface {
  /// Constructs a [BluetoothLowEnergy].
  BluetoothLowEnergy() : super(token: _token);

  static final Object _token = Object();

  static BluetoothLowEnergy? _instance;

  /// The default instance of [BluetoothLowEnergy] to use.
  static BluetoothLowEnergy get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
        '`BluetoothLowEnergy` is not implemented on this platform.',
      );
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

  /// Gets the bluetooth low energy central manager instance.
  CentralManager get centralManager;

  /// Gets the bluetooth low energy peripheral manager instance.
  PeripheralManager get peripheralManager;

  /// Sets up the bluetooth low energy.
  Future<void> setUp();
}
