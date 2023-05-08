
import 'bluetooth_low_energy_linux_platform_interface.dart';

class BluetoothLowEnergyLinux {
  Future<String?> getPlatformVersion() {
    return BluetoothLowEnergyLinuxPlatform.instance.getPlatformVersion();
  }
}
