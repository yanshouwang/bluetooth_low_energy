import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'bluez_central_manager.dart';

class BluetoothLowEnergyLinuxPlugin {
  static void registerWith() {
    CentralManager.instance = BlueZCentralManager();
  }
}
