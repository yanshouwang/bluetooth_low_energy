import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_low_energy_method_channel.dart';

abstract class BluetoothLowEnergyPlatform extends PlatformInterface {
  /// Constructs a BluetoothLowEnergyPlatform.
  BluetoothLowEnergyPlatform() : super(token: _token);

  static final Object _token = Object();

  static BluetoothLowEnergyPlatform _instance = MethodChannelBluetoothLowEnergy();

  /// The default instance of [BluetoothLowEnergyPlatform] to use.
  ///
  /// Defaults to [MethodChannelBluetoothLowEnergy].
  static BluetoothLowEnergyPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BluetoothLowEnergyPlatform] when
  /// they register themselves.
  static set instance(BluetoothLowEnergyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
