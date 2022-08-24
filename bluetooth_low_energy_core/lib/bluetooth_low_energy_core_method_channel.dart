import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bluetooth_low_energy_core_platform_interface.dart';

/// An implementation of [BluetoothLowEnergyCorePlatform] that uses method channels.
class MethodChannelBluetoothLowEnergyCore extends BluetoothLowEnergyCorePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bluetooth_low_energy_core');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
