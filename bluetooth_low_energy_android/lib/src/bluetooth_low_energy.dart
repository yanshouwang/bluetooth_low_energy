import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_central_manager.dart';
import 'my_peripheral_manager.dart';

abstract class BluetoothLowEnergyAndroidPlugin {
  static void registerWith() {
    BaseCentralManager.instance = MyCentralManager();
    BasePeripheralManager.instance = MyPeripheralManager();
  }
}
