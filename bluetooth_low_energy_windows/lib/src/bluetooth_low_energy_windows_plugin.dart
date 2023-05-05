import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'quick_blue_central_manager.dart';

class BluetoothLowEnergyWindowsPlugin {
  static void registerWith() {
    CentralManager.instance = QuickBlueCentralManager();
  }
}
