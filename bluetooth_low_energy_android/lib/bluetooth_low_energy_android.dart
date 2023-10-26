import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'src/my_central_manager2.dart';
import 'src/my_peripheral_manager2.dart';

abstract class BluetoothLowEnergyAndroid {
  static void registerWith() {
    MyCentralManager.instance = MyCentralManager2();
    MyPeripheralManager.instance = MyPeripheralManager2();
  }
}
