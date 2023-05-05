import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_low_energy_android_method_channel.dart';

abstract class BluetoothLowEnergyAndroidPlatform extends PlatformInterface {
  /// Constructs a BluetoothLowEnergyAndroidPlatform.
  BluetoothLowEnergyAndroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static BluetoothLowEnergyAndroidPlatform _instance = MethodChannelBluetoothLowEnergyAndroid();

  /// The default instance of [BluetoothLowEnergyAndroidPlatform] to use.
  ///
  /// Defaults to [MethodChannelBluetoothLowEnergyAndroid].
  static BluetoothLowEnergyAndroidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BluetoothLowEnergyAndroidPlatform] when
  /// they register themselves.
  static set instance(BluetoothLowEnergyAndroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
