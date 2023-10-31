import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_low_energy_windows_method_channel.dart';

abstract class BluetoothLowEnergyWindowsPlatform extends PlatformInterface {
  /// Constructs a BluetoothLowEnergyWindowsPlatform.
  BluetoothLowEnergyWindowsPlatform() : super(token: _token);

  static final Object _token = Object();

  static BluetoothLowEnergyWindowsPlatform _instance = MethodChannelBluetoothLowEnergyWindows();

  /// The default instance of [BluetoothLowEnergyWindowsPlatform] to use.
  ///
  /// Defaults to [MethodChannelBluetoothLowEnergyWindows].
  static BluetoothLowEnergyWindowsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BluetoothLowEnergyWindowsPlatform] when
  /// they register themselves.
  static set instance(BluetoothLowEnergyWindowsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
