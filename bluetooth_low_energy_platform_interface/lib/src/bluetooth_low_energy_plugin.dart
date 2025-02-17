import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'central_manager.dart';
import 'peripheral_manager.dart';

/// The abstract base channel class that manages central and peripheral objects.
abstract base class BluetoothLowEnergyPlugin extends PlatformInterface {
  static final _token = Object();

  /// Constructs a [BluetoothLowEnergyPlugin].
  BluetoothLowEnergyPlugin.impl() : super(token: _token);

  static BluetoothLowEnergyPlugin? _instance;

  /// The default instance of [BluetoothLowEnergyPlugin] to use.
  static BluetoothLowEnergyPlugin get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
          'bluetooth_low_energy is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BluetoothLowEnergyPlugin] when
  /// they register themselves.
  static set instance(BluetoothLowEnergyPlugin instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Creates the central manager instance.
  CentralManager createCentralManager();

  /// Creates the peripheral manager instance.
  PeripheralManager createPeripheralManager();
}
