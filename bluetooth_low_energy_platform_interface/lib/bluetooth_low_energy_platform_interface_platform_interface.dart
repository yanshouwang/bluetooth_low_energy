import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_low_energy_platform_interface_method_channel.dart';

abstract class BluetoothLowEnergyPlatformInterfacePlatform extends PlatformInterface {
  /// Constructs a BluetoothLowEnergyPlatformInterfacePlatform.
  BluetoothLowEnergyPlatformInterfacePlatform() : super(token: _token);

  static final Object _token = Object();

  static BluetoothLowEnergyPlatformInterfacePlatform _instance = MethodChannelBluetoothLowEnergyPlatformInterface();

  /// The default instance of [BluetoothLowEnergyPlatformInterfacePlatform] to use.
  ///
  /// Defaults to [MethodChannelBluetoothLowEnergyPlatformInterface].
  static BluetoothLowEnergyPlatformInterfacePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BluetoothLowEnergyPlatformInterfacePlatform] when
  /// they register themselves.
  static set instance(BluetoothLowEnergyPlatformInterfacePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
