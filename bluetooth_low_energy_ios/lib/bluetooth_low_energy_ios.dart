
import 'bluetooth_low_energy_ios_platform_interface.dart';

class BluetoothLowEnergyIos {
  Future<String?> getPlatformVersion() {
    return BluetoothLowEnergyIosPlatform.instance.getPlatformVersion();
  }
}
