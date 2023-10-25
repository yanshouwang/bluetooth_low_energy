import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'src/my_central_manager.dart';
import 'src/my_peripheral_manager.dart';

abstract class BluetoothLowEnergyDarwin {
  static void registerWith() {
    CentralManager.instance = MyCentralManager();
    PeripheralManager.instance = MyPeripheralManager();
  }
}
