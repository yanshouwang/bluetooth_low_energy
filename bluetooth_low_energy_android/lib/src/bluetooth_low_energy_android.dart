import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_central_manager.dart';

class BluetoothLowEnergyAndroid {
  static void registerWith() {
    CentralManager.instance = MyCentralManager();
  }
}