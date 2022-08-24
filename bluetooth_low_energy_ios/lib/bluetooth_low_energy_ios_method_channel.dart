import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bluetooth_low_energy_ios_platform_interface.dart';

/// An implementation of [BluetoothLowEnergyIosPlatform] that uses method channels.
class MethodChannelBluetoothLowEnergyIos extends BluetoothLowEnergyIosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bluetooth_low_energy_ios');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
