import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'src/my_central_manager.dart';
import 'src/my_peripheral_manager.dart';

abstract class BluetoothLowEnergyDarwinPlugin {
  static void registerWith() {
    PlatformCentralManager.instance = MyCentralManager();
    PlatformPeripheralManager.instance = MyPeripheralManager();
  }
}
