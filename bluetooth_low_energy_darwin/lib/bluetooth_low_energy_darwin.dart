import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'src/my_central_manager_2.dart';
import 'src/my_peripheral_manager_2.dart';

abstract class BluetoothLowEnergyDarwin {
  static void registerWith() {
    MyCentralManager.instance = MyCentralManager2();
    MyPeripheralManager.instance = MyPeripheralManager2();
  }
}
