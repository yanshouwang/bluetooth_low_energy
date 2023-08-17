import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'src/my_central_controller.dart';

abstract class BluetoothLowEnergymacOS {
  static void registerWith() {
    CentralController.instance = MyCentralController();
  }
}
