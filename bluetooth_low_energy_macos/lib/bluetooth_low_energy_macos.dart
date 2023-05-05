
import 'bluetooth_low_energy_macos_platform_interface.dart';

class BluetoothLowEnergyMacos {
  Future<String?> getPlatformVersion() {
    return BluetoothLowEnergyMacosPlatform.instance.getPlatformVersion();
  }
}
