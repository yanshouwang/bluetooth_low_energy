
import 'bluetooth_low_energy_android_platform_interface.dart';

class BluetoothLowEnergyAndroid {
  Future<String?> getPlatformVersion() {
    return BluetoothLowEnergyAndroidPlatform.instance.getPlatformVersion();
  }
}
