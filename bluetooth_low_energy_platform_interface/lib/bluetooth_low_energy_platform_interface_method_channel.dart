import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bluetooth_low_energy_platform_interface_platform_interface.dart';

/// An implementation of [BluetoothLowEnergyPlatformInterfacePlatform] that uses method channels.
class MethodChannelBluetoothLowEnergyPlatformInterface extends BluetoothLowEnergyPlatformInterfacePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bluetooth_low_energy_platform_interface');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
