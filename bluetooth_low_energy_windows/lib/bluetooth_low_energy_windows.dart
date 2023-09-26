import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'src/my_bluetooth_low_energy.dart';

abstract class BluetoothLowEnergyWindows {
  static void registerWith() {
    BluetoothLowEnergy.instance = MyBluetoothLowEnergy();
  }
}
