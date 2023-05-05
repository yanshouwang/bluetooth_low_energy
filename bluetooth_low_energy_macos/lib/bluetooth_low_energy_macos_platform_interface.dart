import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_low_energy_macos_method_channel.dart';

abstract class BluetoothLowEnergyMacosPlatform extends PlatformInterface {
  /// Constructs a BluetoothLowEnergyMacosPlatform.
  BluetoothLowEnergyMacosPlatform() : super(token: _token);

  static final Object _token = Object();

  static BluetoothLowEnergyMacosPlatform _instance = MethodChannelBluetoothLowEnergyMacos();

  /// The default instance of [BluetoothLowEnergyMacosPlatform] to use.
  ///
  /// Defaults to [MethodChannelBluetoothLowEnergyMacos].
  static BluetoothLowEnergyMacosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BluetoothLowEnergyMacosPlatform] when
  /// they register themselves.
  static set instance(BluetoothLowEnergyMacosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
