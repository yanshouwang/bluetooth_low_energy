import 'package:hybrid_core/hybrid_core.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_low_energy_manager.dart';

/// The abstract base channel class that manages central and peripheral objects.
abstract base class BaseBluetoothLowEnergyManager extends PlatformInterface
    with LoggerProvider, LoggerController
    implements BluetoothLowEnergyManager {
  /// Constructs a [BaseBluetoothLowEnergyManager].
  BaseBluetoothLowEnergyManager({
    required super.token,
  });

  /// Initializes the [BaseBluetoothLowEnergyManager].
  void initialize();
}
