export 'src/bluetooth_low_energy_windows_plugin.dart';

import 'bluetooth_low_energy_windows_platform_interface.dart';

class BluetoothLowEnergyWindows {
  Future<String?> getPlatformVersion() {
    return BluetoothLowEnergyWindowsPlatform.instance.getPlatformVersion();
  }
}
