import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bluetooth_low_energy_linux_platform_interface.dart';

/// An implementation of [BluetoothLowEnergyLinuxPlatform] that uses method channels.
class MethodChannelBluetoothLowEnergyLinux extends BluetoothLowEnergyLinuxPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bluetooth_low_energy_linux');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
