import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_low_energy_core_method_channel.dart';

abstract class BluetoothLowEnergyCorePlatform extends PlatformInterface {
  /// Constructs a BluetoothLowEnergyCorePlatform.
  BluetoothLowEnergyCorePlatform() : super(token: _token);

  static final Object _token = Object();

  static BluetoothLowEnergyCorePlatform _instance = MethodChannelBluetoothLowEnergyCore();

  /// The default instance of [BluetoothLowEnergyCorePlatform] to use.
  ///
  /// Defaults to [MethodChannelBluetoothLowEnergyCore].
  static BluetoothLowEnergyCorePlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BluetoothLowEnergyCorePlatform] when
  /// they register themselves.
  static set instance(BluetoothLowEnergyCorePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
