import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'src/my_bluetooth_low_energy.dart';

class BluetoothLowEnergyAndroid {
  static void registerWith() {
    CentralController.instance = MyCentralController();
  }
}
