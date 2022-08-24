
import 'bluetooth_low_energy_platform_interface.dart';

class BluetoothLowEnergy {
  Future<String?> getPlatformVersion() {
    return BluetoothLowEnergyPlatform.instance.getPlatformVersion();
  }
}
