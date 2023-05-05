import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_low_energy_ios_method_channel.dart';

abstract class BluetoothLowEnergyIosPlatform extends PlatformInterface {
  /// Constructs a BluetoothLowEnergyIosPlatform.
  BluetoothLowEnergyIosPlatform() : super(token: _token);

  static final Object _token = Object();

  static BluetoothLowEnergyIosPlatform _instance = MethodChannelBluetoothLowEnergyIos();

  /// The default instance of [BluetoothLowEnergyIosPlatform] to use.
  ///
  /// Defaults to [MethodChannelBluetoothLowEnergyIos].
  static BluetoothLowEnergyIosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BluetoothLowEnergyIosPlatform] when
  /// they register themselves.
  static set instance(BluetoothLowEnergyIosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
